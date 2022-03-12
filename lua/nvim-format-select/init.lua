local M = {}

---get an lsp client attached to the current buffer that supports the method
---@param client_name string
---@param method string
---@returns lsp client or nil
local function get_client(client_name, method)
  local clients = vim.tbl_values(vim.lsp.buf_get_clients())
  clients = vim.tbl_filter(function(client)
    return client.name == client_name
  end, clients)

  if
    vim.tbl_count(clients) == 1
    and clients[1].supports_method(method)
  then
    return clients[1]
  end

  return nil
end

---format sync with a specific lsp client
---@param client_name string
---@param options any formatting options
---@param timeout_ms number delay time
function M.formatting_sync_select(client_name, options, timeout_ms)
  local method = "textDocument/formatting"
  local client = get_client(client_name, method)
  if client == nil then
    return
  end

  local params = vim.lsp.util.make_formatting_params(options)
  local bufnr = vim.api.nvim_get_current_buf()

  local result, err = client.request_sync(method, params, timeout_ms, bufnr)
  if result and result.result then
    vim.lsp.util.apply_text_edits(result.result, bufnr, client.offset_encoding)
  elseif err then
    vim.notify("vim.lsp.buf.formatting_sync: " .. err, vim.log.levels.WARN)
  end
end

---format async with a specific lsp client
---@param client_name string
---@param options any formatting options
function M.formatting_select(client_name, options)
  local method = "textDocument/formatting"
  local client = get_client(client_name, method)
  if client == nil then
    return
  end

  local params = vim.lsp.util.make_formatting_params(options)
  local bufnr = vim.api.nvim_get_current_buf()

  return client.request('textDocument/formatting', params, nil, bufnr)
end


return M
