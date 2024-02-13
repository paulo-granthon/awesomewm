local M = {}

function M.os_capture(command)
    local tmpfile = '/tmp/lua_execute_tmp_file'
    local exit = os.execute(command .. ' > ' .. tmpfile .. ' 2> ' .. tmpfile .. '.err')

    local stdout_file = io.open(tmpfile)
    if not stdout_file then
        return nil, nil, "os.capture: stdout_file Error"
    end
    local stdout = stdout_file:read("*all")

    local stderr_file = io.open(tmpfile .. '.err')
    if not stderr_file then
        return nil, nil, "os.capture: stderr_file Error"
    end
    local stderr = stderr_file:read("*all")

    stdout_file:close()
    stderr_file:close()

    return exit, stdout, stderr
end

return M
