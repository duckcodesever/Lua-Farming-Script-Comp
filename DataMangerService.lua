local DataStoreService = game:GetService("DataStoreService")
local FarmDataStore = DataStoreService:GetDataStore("FarmGameData_v1") -- Change "_v1" to reset data later if needed

-- Default values for new players
local DEFAULT_COINS = 100
local DEFAULT_SEEDS = 5

-- Function to load data when a player joins
local function onPlayerAdded(player)
	-- Create leaderstats folder (visible in-game player list)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = DEFAULT_COINS
	coins.Parent = leaderstats

	-- Create a hidden folder for inventory data
	local inventory = Instance.new("Folder")
	inventory.Name = "Inventory"
	inventory.Parent = player

	local wheatSeeds = Instance.new("IntValue")
	wheatSeeds.Name = "WheatSeeds"
	wheatSeeds.Value = DEFAULT_SEEDS
	wheatSeeds.Parent = inventory

	-- Attempt to load saved data from the DataStore
	local playerKey = "Player_" .. player.UserId
	local success, savedData = pcall(function()
		return FarmDataStore:GetAsync(playerKey)
	end)

	if success and savedData then
		-- Apply saved data if it exists
		if savedData.Coins then coins.Value = savedData.Coins end
		if savedData.WheatSeeds then wheatSeeds.Value = savedData.WheatSeeds end
		print("Data successfully loaded for: " .. player.Name)
	else
		if not success then
			warn("Failed to load data for " .. player.Name .. ": " .. tostring(savedData))
		else
			print("New player detected. Loaded default values for: " .. player.Name)
		end
	end
end

-- Function to save data
local function savePlayerData(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	local inventory = player:FindFirstChild("Inventory")
	
	-- Ensure the player actually has data folders before saving
	if not leaderstats or not inventory then return end

	local playerKey = "Player_" .. player.UserId
	
	-- Compile data into a single table
	local dataToSave = {
		Coins = leaderstats.Coins.Value,
		WheatSeeds = inventory.WheatSeeds.Value
	}

	-- Attempt to save to the DataStore
	local success, err = pcall(function()
		FarmDataStore:SetAsync(playerKey, dataToSave)
	end)

	if success then
		print("Data successfully saved for: " .. player.Name)
	else
		warn("Failed to save data for " .. player.Name .. ": " .. tostring(err))
	end
end

-- Function to handle player leaving
local function onPlayerRemoving(player)
	savePlayerData(player)
end

-- Function to save everyone's data if the server crashes/shuts down
local function onBindToClose()
	print("Server shutting down! Saving all player data...")
	for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
		savePlayerData(player)
	end
end

-- Connect the functions to Roblox game events
game:GetService("Players").PlayerAdded:Connect(onPlayerAdded)
game:GetService("Players").PlayerRemoving:Connect(onPlayerRemoving)
game:BindToClose:Connect(onBindToClose)
