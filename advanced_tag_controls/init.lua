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

return M
