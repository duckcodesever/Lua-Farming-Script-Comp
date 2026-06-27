local json = require("json") -- Requires a standard Lua JSON library

local PlayerDataManager = {}

-- File path configuration
local SAVE_FILE_PATH = "player_save.json"

-- Live in-memory player data cache
PlayerDataManager.CurrentData = nil

-- Default template for new players
local DEFAULT_DATA_TEMPLATE = {
    currency = 500,
    unlockedLandSize = 4,
    inventory = {
        seeds = {
            ["tomato_seed"] = 5,
            ["carrot_seed"] = 3
        },
        crops = {},
        tools = {
            ["watering_can"] = 1,
            ["old_hoe"] = 1
        }
    },
    questsCompleted = 0
}

-- Create deep copy of the template to avoid reference issues
local function deepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = deepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

-- Load profile from disk or assign a fresh template
function PlayerDataManager.loadData()
    local file = io.open(SAVE_FILE_PATH, "r")
    
    if file then
        local content = file:read("*all")
        file:close()
        
        local success, decodedData = pcall(json.decode, content)
        if success and decodedData then
            PlayerDataManager.CurrentData = decodedData
            print("[PlayerDataManager] Save file loaded successfully.")
            return
        end
    end
    
    -- Fallback if file does not exist or is corrupted
    print("[PlayerDataManager] No valid save file found. Creating profile template.")
    PlayerDataManager.CurrentData = deepCopy(DEFAULT_DATA_TEMPLATE)
end

-- Save live cache data directly onto disk
function PlayerDataManager.saveData()
    if not PlayerDataManager.CurrentData then return end
    
    local file = io.open(SAVE_FILE_PATH, "w")
    if file then
        local success, encodedData = pcall(json.encode, PlayerDataManager.CurrentData)
        if success and encodedData then
            file:write(encodedData)
            file:close()
            print("[PlayerDataManager] Game data autosaved to disk.")
        else
            print("[PlayerDataManager] Error: Serialization failed.")
        end
    else
        print("[PlayerDataManager] Error: Unable to open save file write-path.")
    end
end

-- Helper: Safely modify player currency balance
function PlayerDataManager.adjustCurrency(amount)
    if not PlayerDataManager.CurrentData then return false end
    
    local newBalance = PlayerDataManager.CurrentData.currency + amount
    if newBalance >= 0 then
        PlayerDataManager.CurrentData.currency = newBalance
        return true
    end
    return false -- Insufficient funds
end

-- Helper: Safely add or remove inventory items
function PlayerDataManager.adjustInventoryItem(category, itemKey, quantity)
    if not PlayerDataManager.CurrentData then return false end
    local inv = PlayerDataManager.CurrentData.inventory[category]
    if not inv then return false end
    
    local currentCount = inv[itemKey] or 0
    local newCount = currentCount + quantity
    
    if newCount > 0 then
        inv[itemKey] = newCount
        return true
    elseif newCount == 0 then
        inv[itemKey] = nil -- Clean up key from table
        return true
    end
    return false -- Cannot have negative inventory items
end

return PlayerDataManager
