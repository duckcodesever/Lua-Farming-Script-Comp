local GridSystem = {}
GridSystem.__index = GridSystem

function GridSystem.new(rows, cols)
    local self = setmetatable({}, GridSystem)
    self.plots = {}
    
    for r = 1, rows do
        self.plots[r] = {}
        for c = 1, cols do
            self.plots[r][c] = {
                State = "Empty", -- Empty, Plowed, Planted
                PlantName = nil,
                GrowthStage = 0,
                IsWatered = false,
                PlantTime = 0
            }
        end
    end
    return self
end

function GridSystem:PlowPlot(r, c)
    local plot = self.plots[r][c]
    if plot.State == "Empty" then
        plot.State = "Plowed"
        print("Plot [" .. r .. "," .. c .. "] plowed.")
        return true
    end
    return false
end

function GridSystem:GetPlot(r, c)
    return self.plots[r][c]
end

return GridSystem
