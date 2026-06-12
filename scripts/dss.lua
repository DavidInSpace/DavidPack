--
-- Generic and very straightforward data storage system used in the MenuProvider functions below
-- Use your own mod's functions for this if it has them! If not, however, feel free to copy this and
-- change the mod name.
--
local mod = david_pack
local SaveManager = mod.SaveManager

mod.menusavedata = nil
-- SaveManager.AddCallback(mod.SaveManager.Utility.CustomCallback.POST_DATA_LOAD, function(_)
--     mod.menusavedata = (SaveManager.GetDeadSeaScrollsSave() and SaveManager.GetDeadSeaScrollsSave().savedata) or {}
-- end)


function mod.GetSaveData()
    if not mod.menusavedata then
        local dssSave = SaveManager.GetDeadSeaScrollsSave()
        if dssSave and dssSave.menusavedata then
            mod.menusavedata = dssSave.menusavedata
        else
            mod.menusavedata = {}
        end
    end

    return mod.menusavedata
end

function mod.StoreSaveData()
    SaveManager.GetDeadSeaScrollsSave().menusavedata = mod.menusavedata
end

--
-- End of generic data storage manager
--

--
-- MenuProvider
--

-- Change this variable to match your mod. The standard is "Dead Sea Scrolls (Mod Name)"
local DSSModName = "David Pack"

-- Every MenuProvider function below must have its own implementation in your mod, in order to
-- handle menu save data.
local MenuProvider = {}

function MenuProvider.SaveSaveData()
    mod.StoreSaveData()
end

function MenuProvider.GetPaletteSetting()
    return mod.GetSaveData().MenuPalette
end

function MenuProvider.SavePaletteSetting(var)
    mod.GetSaveData().MenuPalette = var
end

function MenuProvider.GetHudOffsetSetting()
    if not REPENTANCE then
        return mod.GetSaveData().HudOffset
    else
        return Options.HUDOffset * 10
    end
end

function MenuProvider.SaveHudOffsetSetting(var)
    if not REPENTANCE then
        mod.GetSaveData().HudOffset = var
    end
end

function MenuProvider.GetGamepadToggleSetting()
    return mod.GetSaveData().GamepadToggle
end

function MenuProvider.SaveGamepadToggleSetting(var)
    mod.GetSaveData().GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
    return mod.GetSaveData().MenuKeybind
end

function MenuProvider.SaveMenuKeybindSetting(var)
    mod.GetSaveData().MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    return mod.GetSaveData().MenuHint
end

function MenuProvider.SaveMenuHintSetting(var)
    mod.GetSaveData().MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
    return mod.GetSaveData().MenuBuzzer
end

function MenuProvider.SaveMenuBuzzerSetting(var)
    mod.GetSaveData().MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
    return mod.GetSaveData().MenusNotified
end

function MenuProvider.SaveMenusNotified(var)
    mod.GetSaveData().MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
    return mod.GetSaveData().MenusPoppedUp
end

function MenuProvider.SaveMenusPoppedUp(var)
    mod.GetSaveData().MenusPoppedUp = var
end

local dssmenucore = include("scripts.dssmenucore")

-- This function returns a table that some useful functions and defaults are stored on.
local dssmod = dssmenucore.init(DSSModName, MenuProvider)


-- Adding a Menu

-- Creating a menu like any other DSS menu is a simple process. You need a "Directory", which
-- defines all of the pages ("items") that can be accessed on your menu, and a "DirectoryKey", which
-- defines the state of the menu.

mod.SettingsDirectory = {
    main = {
        title = 'david pack',
        buttons = {
            { str = 'resume game', action = 'resume' },
            { str = 'settings',    dest = 'settings' },

            dssmod.changelogsButton,
        },
        tooltip = dssmod.menuOpenToolTip
    },
    settings = {
        title = 'settings',
        buttons = {
            --{ str = 'accessibility', dest = 'accessibility_menu' },
            { str = 'gameplay', dest = 'gameplay_menu' },
            --{ str = 'items', dest = 'items_menu' },
        }
    },
    accessibility_menu = {
        title = 'accessibility',
        buttons = {
                        {
                str = 'shake',
                choices = {"enabled", "disabled"},
                setting = 1,
                variable = 'shake',
                load = function()
                    return mod.SaveManager.GetSettingsSave().shake or 1
                end,
                store = function(var)
                    mod.SaveManager.GetSettingsSave().shake = var
                end,
                tooltip = { strset = {"toggles", "whether", "david pack", "items can", "make the", "screen shake"} }
            },
        }
    },
    gameplay_menu = {
        title = 'gameplay',
        buttons = {
            dssmod.gamepadToggleButton,
            dssmod.menuKeybindButton,
            dssmod.paletteButton,
            dssmod.menuHintButton,
            dssmod.menuBuzzerButton,


            {
                str = 'super curses',
                choices = {"enabled", "disabled"},
                setting = 1,
                variable = 'super_curses',
                load = function()
                    return mod.SaveManager.GetSettingsSave().super_curses or 1
                end,
                store = function(var)
                    mod.SaveManager.GetSettingsSave().super_curses = var
                end,
                tooltip = { strset = {"toggles", "whether", "super curses", "can show up"} }
            },
            {
                str = 'super curses chance',
                fsize = 3,

                min = 0,
                max = 100,
                increment = 1,
                suf = "%",

                setting = 10,
                variable = 'super_curses_chance',
                load = function()
                    return mod.SaveManager.GetSettingsSave().super_curses_chance or 10
                end,
                store = function(var)
                    mod.SaveManager.GetSettingsSave().super_curses_chance = var
                end,
                tooltip = { strset = {"chance that", "a normal", "will get curse", "replaced by", "a super curse"} }
            },
        }
    },
    items_menu = {
        title = 'items',
        buttons = {
        }
    }
}

local settingsDirectoryKey = {
    Item = mod.SettingsDirectory.main,
    Main = 'main',
    Idle = false,
    MaskAlpha = 1,
    Settings = {},
    SettingsChanged = false,
    Path = {},
}

DeadSeaScrollsMenu.AddMenu("david pack", {
    Run = dssmod.runMenu,
    Open = dssmod.openMenu,
    Close = dssmod.closeMenu,
    UseSubMenu = false,
    Directory = mod.SettingsDirectory,
    DirectoryKey = settingsDirectoryKey
})
