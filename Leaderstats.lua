local function onPlayerAdded(player)
	-- 1. Create the main leaderstats folder (must be named exactly "leaderstats" in lowercase)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	-- 2. Create the Coins/Cash tracker
	local coins = Instance.new("IntValue")
	coins.Name = "Coins" -- This text shows up at the top of the player list in-game
	coins.Value = 100    -- Starting money for new players
	coins.Parent = leaderstats

	-- 3. Optional: Create a Level tracker
	local level = Instance.new("IntValue")
	level.Name = "Level" -- This adds a second column next to Coins
	level.Value = 1      -- Starting level
	level.Parent = leaderstats
end

-- Connect the function to the player joining event
game:GetService("Players").PlayerAdded:Connect(onPlayerAdded)
