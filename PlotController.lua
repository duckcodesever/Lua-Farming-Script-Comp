local PlotController = {}
PlotController.__index = PlotController

-- Plot States Enum
PlotController.States = {
    DIRT = "Dirt",
    TILLED = "Tilled",
    WATERED = "Watered"
}

-- Initialize a new garden plot
function PlotController.new(plotId)
    local self = setmetatable({}, PlotController)
    
    self.id = plotId
    self.state = PlotController.States.DIRT
    self.currentPlant = nil      -- Holds the Plant object instance
    self.lastWateredTime = 0     -- Timestamp of last watering
    self.weedInfested = false
    
    return self
end

-- Till the soil (Preparation stage)
function PlotController:till()
    if self.state == PlotController.States.DIRT then
        self.state = PlotController.States.TILLED
        self:updateVisuals()
        return true
    end
    return false
end

-- Water the soil
function PlotController:water()
    if self.state == PlotController.States.TILLED then
        self.state = PlotController.States.WATERED
        self.lastWateredTime = os.time()
        
        -- Boost growth if a plant is already there
        if self.currentPlant and self.currentPlant.onWatered then
            self.currentPlant:onWatered()
        end
        
        self:updateVisuals()
        return true
    end
    return false
end

-- Plant a seed
function PlotController:plantSeed(seedData)
    if self.state == PlotController.States.WATERED and not self.currentPlant then
        -- Assumes a global or required PlantBehavior module exists
        if _G.PlantBehavior then 
            self.currentPlant = _G.PlantBehavior.new(seedData)
            self:updateVisuals()
            return true
        end
    end
    return false
end

-- Harvest the mature crop
function PlotController:harvest()
    if self.currentPlant and self.currentPlant.isMature then
        local reward = self.currentPlant:getHarvestDrop()
        self.currentPlant = nil
        self.state = PlotController.States.DIRT -- Reset plot back to basic dirt
        self:updateVisuals()
        return reward
    end
    return nil
end

-- Clear dead crops or weeds
function PlotController:clearPlot()
    if self.weedInfested or (self.currentPlant and self.currentPlant.isDead) then
        self.currentPlant = nil
        self.weedInfested = false
        self.state = PlotController.States.DIRT
        self:updateVisuals()
        return true
    end
    return false
end

-- Update plot logic on game ticks (called by GameManager)
function PlotController:update(deltaTime)
    -- Handle plant growth updates
    if self.currentPlant then
        self.currentPlant:update(deltaTime, self.state == PlotController.States.WATERED)
    end
    
    -- Dry out the soil over time (e.g., dries after 60 real seconds)
    if self.state == PlotController.States.WATERED then
        if os.time() - self.lastWateredTime > 60 then
            self.state = PlotController.States.TILLED
            self:updateVisuals()
        end
    end
end

-- Placeholder for linking logic to 3D models or 2D sprites
function PlotController:updateVisuals()
    -- Connect this to your engine (e.g., change texture or color)
    -- If self.state == "Watered" then change color to dark brown
    -- If self.currentPlant then render plant mesh/sprite stage
end

return PlotController
