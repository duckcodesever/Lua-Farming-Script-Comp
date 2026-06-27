local GameManager = {}

-- System References
local TimeSystem = nil
local WeatherSystem = nil
local PlayerDataManager = nil

-- Game State Arrays
local activePlots = {}
local isGameRunning = false
local autosaveInterval = 300 -- 5 minutes
local lastAutosaveTime = os.time()

-- Initialize the global game state
function GameManager.initialize()
    -- Load dependent modules (adjust paths based on your engine structure)
    TimeSystem = require("TimeSystem")
    PlayerDataManager = require("PlayerDataManager")
    
    -- Initialize standalone core systems
    TimeSystem.initialize()
    PlayerDataManager.loadData()
    
    isGameRunning = true
    print("[GameManager] Core systems initialized successfully.")
end

-- Register a garden plot into the tracking loop
function GameManager.registerPlot(plotInstance)
    if plotInstance and plotInstance.id then
        activePlots[plotInstance.id] = plotInstance
    end
end

-- Main update loop (Call this inside your engine's tick/render frame event)
function GameManager.update(deltaTime)
    if not isGameRunning then return end

    -- 1. Update Core Global Systems
    TimeSystem.update(deltaTime)
    if WeatherSystem then
        WeatherSystem.update(deltaTime)
    end

    -- 2. Update All Registered Gardening Plots
    for _, plot in pairs(activePlots) do
        plot:update(deltaTime)
    end

    -- 3. Handle Periodic Background Tasks (Autosave)
    if os.time() - lastAutosaveTime >= autosaveInterval then
        GameManager.triggerAutosave()
    end
end

-- Save player progress securely
function GameManager.triggerAutosave()
    print("[GameManager] Running background autosave...")
    PlayerDataManager.saveData()
    lastAutosaveTime = os.time()
end

-- Gracefully shut down systems on exit
function GameManager.shutdown()
    isGameRunning = false
    print("[GameManager] Shutting down game safely...")
    PlayerDataManager.saveData() -- Force final save
end

return GameManager
