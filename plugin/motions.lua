local function smart_paragraph_jump(forward)
	-- 1. Dynamically extract the left and right sides of the commentstring
	-- e.g., "-- %s" -> left="--", right=""
	-- e.g., "(* %s *)" -> left="(*", right="*)"
	local cs = vim.bo.commentstring
	if cs == "" then cs = "%s" end
	local left, right = cs:match("^(.*)%%s(.*)$")
	left = vim.trim(left or "")
	right = vim.trim(right or "")

	-- 2. Build the regex for what constitutes a "blank" line
	local blank_pattern
	if left == "" then
		blank_pattern = "\\s*"
	elseif right == "" then
		-- Handles: empty line, "#", "--", "--   "
		blank_pattern = string.format("\\s*(\\V%s\\v)?\\s*", left:gsub("\\", "\\\\"))
	else
		-- Handles: empty line, "(**)", "/* */"
		blank_pattern = string.format("\\s*(\\V%s\\v\\s*\\V%s\\v)?\\s*",
			left:gsub("\\", "\\\\"), right:gsub("\\", "\\\\"))
	end

	-- 3. Construct our two distinct search patterns
	-- boundary_pat: Matches empty lines or empty comment lines
	local boundary_pat = "\\v^" .. blank_pattern .. "$"

	-- text_pat: Uses @! (negative lookahead) to match any line that is NOT a boundary
	-- see :h @!
	local text_pat = "\\v^(" .. blank_pattern .. "$)@!"

	-- 4. Set search flags based on direction
	local flags1 = forward and "cW" or "bcW"
	local flags2 = forward and "W" or "bW"

	-- 5. Execute standard Vim paragraph jump logic
	vim.cmd("normal! 0")
	vim.fn.search(text_pat, flags1)    -- Skip past empty space to find actual text
	vim.fn.search(boundary_pat, flags2) -- Jump to the next empty boundary
end

-- Map globally. The function calculates the commentstring live, per-buffer.
vim.keymap.set({ "n", "v" }, "}", function() smart_paragraph_jump(true) end,
	{ desc = "Next paragraph (ignores comments)" })
vim.keymap.set({ "n", "v" }, "{", function() smart_paragraph_jump(false) end,
	{ desc = "Prev paragraph (ignores comments)" })
