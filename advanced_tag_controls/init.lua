local M = {}

local awful = require("awful")

-- tags that were selected before the current one
-- every time a tag is selected, this is updated with the selected tags before the selection
M.previous_tags = {}

-- update the previous_tags table with the currently selected tags
M.update = function(s)
    M.previous_tags = awful.tag.selectedlist(s)
end

-- view the tag and update the previous_tags table
-- overwrite calls to tag:view_only() with this function
M.view_only = function(t)
    M.update()
    t:view_only()
end

-- toggle the tag and update the previous_tags table
-- overwrite calls to awful.tag.viewtoggle() with this function
M.view_toggle = function(t)
    M.update()
    awful.tag.viewtoggle(t)
end

-- move the currently focused client to the previously selected tags
M.move_client_to_previous_tags = function(client)

    -- if there are no previous tags or no focused client, do nothing
    if not M.previous_tags then return end
    if not client.focus then return end

    -- get the first tag in the previous_tags table
    local tag = M.previous_tags[1]

    -- if there is no tag, do nothing
    if not tag then return end

    -- get the currently focused client and move it to the first tag
    local focused_client = client.focus
    focused_client:move_to_tag(tag)

    -- toggle the remaining tags in the previous_tags table
    for i = 2, #M.previous_tags do
        focused_client:toggle_tag(M.previous_tags[i])
    end
end

-- close all clients that are only on the given tag
M.close_active_clients_on_tags = function(tags)

    -- if there is no tag, do nothing
    if not tags then return end

    if type(tags) ~= "table" then
        tags = {tags}
    end

    if #tags < 1 then return end

    -- get all clients on all tags
    local clients = {}
    for _, tag in pairs(tags) do
        for _, client in pairs(tag:clients()) do
            if not clients[client] then
                clients[client] = client
            end
        end
    end

    -- if there are no clients, do nothing
    if not clients then return end

    -- loop through all clients on the tag
    -- if the client is only on the tag, close it
    for _, c in pairs(clients) do

        -- skip if client c is minimized
        if c.minimized then goto continue end

        -- check each tag the client is on
        -- if the client is on a tag that is not visible, do skip
        -- otherwise, close the client
        for _, client_tag in pairs(c:tags()) do

            local client_tag_is_selected = false

            for _, selected_tag in pairs(awful.screen.focused().selected_tags) do
                if client_tag.index == selected_tag.index then
                    client_tag_is_selected = true
                    break
                end
            end

            if not client_tag_is_selected then
                goto continue
            end
        end

        c:kill()

        ::continue::
    end
end

return M
