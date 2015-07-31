--- Init GUI and add Logistics View main button
function initGUI(player)
    if not player.gui.top["logistics-view-button"] then
        player.gui.top.add({type = "button", name = "logistics-view-button", style = "lv_button_main_icon"})
        -- player.gui.top.add({type = "button", name = "logistics-view-button", caption = {"logistics-view-button"}, style = "lv_button_main"})
    end
end

--- Create the GUI
function createGUI(player, index)
    local guiPos = glob.settings[index].guiPos
    if glob.guiVisible[index] == 0 and player.gui[guiPos].logisticsFrame == nil then
        local currentTab = glob.currentTab[index] or "logistics"
        local buttonStyle = currentTab == 'logistics' and "_selected" or ""

        -- main frame
        local logisticsFrame = player.gui[guiPos].add({type = "frame", name = "logisticsFrame", direction = "vertical", style = "lv_frame"})
        local titleFlow = logisticsFrame.add({type = "flow", name = "titleFlow", direction = "horizontal"})
        titleFlow.add({type = "label", name="titleLabel", style = "lv_title_label", caption = {"logistics-view"}})
        titleFlow.add({type = "button", name = "logistics-view-close", caption = {"logistics-view-close"}, style = "lv_button_close"})

        -- menu flow
        local menuFlow = logisticsFrame.add({type = "flow", name = "menuFlow", direction = "horizontal"})
        menuFlow.add({type = "button", name = "logisticsMenuBtn", caption = {"logistics-items-button"}, style = "lv_button" .. buttonStyle})
        buttonStyle = currentTab == 'normal' and "_selected" or ""
        menuFlow.add({type = "button", name = "normalMenuBtn", caption = {"normal-items-button"}, style = "lv_button" .. buttonStyle})
        buttonStyle = currentTab == 'settings' and "_selected" or ""
        menuFlow.add({type = "button", name = "settingsMenuBtn", caption = {"settings-button"}, style = "lv_button" .. buttonStyle})

        -- content frame
        local contentFrame = logisticsFrame.add({type = "frame", name = "contentFrame", style = "lv_items_frame", direction = "vertical"})
        local infoFlow = contentFrame.add({type = "flow", name = "infoFlow", style = "lv_info_flow", direction = "horizontal"})
        updateGUI(player, index, currentTab)
    end
end

--- Show the GUI
function showGUI(player, index)
    if glob.guiVisible[index] == 0 then
        local guiPos = glob.settings[index].guiPos
        local logisticsFrame = player.gui[guiPos].logisticsFrame
        local currentTab = glob.currentTab[index] == "settings" and "logistics" or glob.currentTab[index]
        glob.currentTab[index] = currentTab

        if logisticsFrame == nil then
            createGUI(player, index)
        else
            logisticsFrame.style = "lv_frame"
        end

        -- hide settings gui and reset menu
        resetMenu(player, index)
        hideSettings(player, index)

        glob.guiVisible[index] = 1
    end
end

--- Hide the GUI
function hideGUI(player, index)
    local guiPos = glob.settings[index].guiPos
    if player.gui[guiPos].logisticsFrame ~= nil then
        player.gui[guiPos].logisticsFrame.style = "lv_frame_hidden"
        glob.guiVisible[index] = 0
    end
end

--- Destroy the GUI
function destroyGUI(player, index)
    local guiPos = glob.settings[index].guiPos
    if player.gui.top["logistics-view-button"] ~= nil then
        player.gui.top["logistics-view-button"].destroy()
    end   
    -- if player.gui[guiPos].logisticsFrame ~= nil then
        -- player.gui[guiPos].logisticsFrame.style = "lv_frame_hidden"
        -- glob.guiVisible[index] = 0
    -- end
end

--- Update main gui content
function updateGUI(player, index, tab)
    local currentTab = tab or glob.currentTab[index]
    local force = player.force

    if currentTab == "logistics" then
        local items = getLogisticsItems(force)
        updateItemsTable(items, player, index)
    elseif currentTab == "normal" then
        local items = getNormalItems(force)
        updateItemsTable(items, player, index)    
    elseif currentTab == "disconnected" then
        showDisconnectedInfo(player, index)
    end
end

--- Clear main content gui
function clearGUI(player, index)
    local guiPos = glob.settings[index].guiPos
    local contentFrame = player.gui[guiPos].logisticsFrame.contentFrame

    for _,child in pairs(contentFrame.childrennames) do
        if contentFrame[child] ~= nil then
            contentFrame[child].destroy()
        end
    end

end

--- Clear menu selection
function clearMenu(player, index)
    local guiPos = glob.settings[index].guiPos
    local menuFlow = player.gui[guiPos].logisticsFrame.menuFlow
    if menuFlow ~= nil then
        for _,btnName in pairs(menuFlow.childrennames) do
            if menuFlow[btnName] ~= nil then
                local btn = menuFlow[btnName]
                btn.style = "lv_button"
            end
        end
    end
end

--- Reset menu selection to the specified tab or the current global tab
function resetMenu(player, index, tab)
    local tab = tab or glob.currentTab[index]
    local guiPos = glob.settings[index].guiPos
    local menuFlow = player.gui[guiPos].logisticsFrame.menuFlow
    if menuFlow ~= nil then
        for _,btnName in pairs(menuFlow.childrennames) do
            if menuFlow[btnName] ~= nil then
                local btn = menuFlow[btnName]
                local btnTab = string.gsub(btnName, "MenuBtn", "")
                if btnTab == tab then
                    btn.style = "lv_button_selected"
                else
                    btn.style = "lv_button"
                end
            end
        end
    end
end