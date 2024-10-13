
local socket = require("socket")
local lfs = require("lfs")

-- Utility functions
local function clearConsole()
    if package.config:sub(1, 1) == '\\' then -- Windows
        os.execute("cls")
    else -- Unix-based
        os.execute("clear")
    end
end

local function isDebuggerAttached()
    -- Not directly applicable in Lua
    return false
end

local function isRemoteDebuggerAttached()
    -- Not directly applicable in Lua
    return false
end

local function checkVMRegistryKeys()
   
    local keys = {
        "HARDWARE\\ACPI\\DSDT\\VBOX__",
        "HARDWARE\\ACPI\\FADT\\VBOX__",
        "HARDWARE\\ACPI\\RSDT\\VBOX__",
        "SYSTEM\\ControlSet001\\Services\\VBoxGuest",
        "SYSTEM\\ControlSet001\\Services\\VBoxService",
        "SYSTEM\\ControlSet001\\Services\\VBoxSF",
        "SYSTEM\\ControlSet001\\Services\\VBoxVideo"
    }
    for _, key in ipairs(keys) do
        -- In Lua, there's no direct registry access unless using external libraries
        -- This would require a custom Windows binding.
    end
    return false
end

local function calculateChecksum(data)
    local checksum = 0
    for i = 1, #data do
        checksum = checksum + string.byte(data, i)
    end
    return checksum
end

local function timedMessage(text, caption, timeout)
    print(text, " - ", caption)
    socket.sleep(timeout / 1000)
end

local function getAppDataPath()
    local home = os.getenv("APPDATA")
    return home or ""
end



local function performAntiDebugChecks()
    if isDebuggerAttached() then
        print("Debugger detected: IsDebuggerPresentCustom")
        return true
    end



    return false
end

local function isUACEnabled()
  
    --  require an external library for UAC check
    return false
end

local function isConnectedToWiFi()
    -- LuaSocket can be used to check network state but not WiFi specifically
    local client = socket.tcp()
    client:settimeout(0.1)
    local res = client:connect("www.google.com", 80)
    if res then
        client:close()
        return true
    else
        return false
    end
end

local function s_token(token)
    -- Placeholder for token authentication
    return token == "valid_token"
end

local function WDHWAOsawiHDA()
    -- Placeholder for function logic
    print("Load function executed.")
end

local function main()
    performAntiDebugChecks()

    local success = "success"
    local intialize = "intialize"
    local version = "1.0"
    local program_key = "YourProgramKey"
    local api_key = "YourApiKey"

    if isUACEnabled() then
        timedMessage("UAC Is Enabled Please Disable It May Mess With The Cheat.", "athenis - Security", 1500)
        os.execute("taskkill /f /im robloxplayerbeta.exe")
        os.exit()
    end

    if checkVMRegistryKeys() then
        timedMessage("Oh No I Got Caught Trying To Crack!", "athenis - Security", 1500)
        os.execute("taskkill /f /im robloxplayerbeta.exe")
        os.exit()
    end

    if isDebuggerAttached() or isRemoteDebuggerAttached() then
        print("Debugger detected, exiting...")
        os.exit()
    end

    -- Initialize directory for authentication
    local folder_path = getAppDataPath() .. "\\athenis-V2"
    local login_path = folder_path .. "\\athenis.login"
    local authenticated = false

    if lfs.attributes(login_path) then
        local file = io.open(login_path, "r")
        local token = file:read("*l")
        file:close()
        
        print("[GAMENAME::Security] do you want to continue with the saved token? (y/n): ")
        local response = io.read()
        if response == "y" then
            if s_token(token) then
                print("[GAMENAME::Security] successfully logged in")
                socket.sleep(1.25)
                clearConsole()
                authenticated = true
                WDHWAOsawiHDA()
            else
                print("[GAMENAME::Security] the saved token isn't valid")
                os.remove(login_path)
            end
        end
    end

    if not authenticated then
        print("[GAMENAME::Security] token: ")
        local token = io.read()
        if s_token(token) then
            print("[GAMENAME::Security] successfully logged in")
            lfs.mkdir(folder_path)
            local file = io.open(login_path, "w")
            file:write(token)
            file:close()
            authenticated = true
            WDHWAOsawiHDA()
        else
            print("[GAMENAME::Security] the token you tried to use isn't valid")
            socket.sleep(1.25)
            clearConsole()
        end
    end

    if authenticated then
        clearConsole()
        WDHWAOsawiHDA()
    else
        print("[GAMENAME::Security] failed to authenticate. exiting...")
        os.exit()
    end
end

main()
