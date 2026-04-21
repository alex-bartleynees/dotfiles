-- Preserve editorconfig-set fileformat through LSP formatting on save.
-- Roslyn (and other LSP formatters) can reset fileformat to unix during
-- format_on_save; this restores whatever editorconfig resolved on open.
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*.cs",
	callback = function(args)
		vim.b[args.buf].resolved_fileformat = vim.bo[args.buf].fileformat
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.cs",
	callback = function(args)
		local fmt = vim.b[args.buf].resolved_fileformat
		if fmt and vim.bo[args.buf].fileformat ~= fmt then
			vim.bo[args.buf].fileformat = fmt
		end
	end,
})
