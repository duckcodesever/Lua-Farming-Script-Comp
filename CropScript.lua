--=========================================================
-- CropData.lua
-- Place inside ReplicatedStorage > Modules
--=========================================================

local CropData = {

	---------------------------------------------------------
	-- Beginner Crops
	---------------------------------------------------------

	Wheat = {
		DisplayName = "Wheat",
		SeedName = "Wheat Seed",

		GrowTime = 60,

		HarvestAmount = {
			Min = 2,
			Max = 5
		},

		SellPrice = 10,

		Stages = {
			"Stage1",
			"Stage2",
			"Stage3",
			"Ready"
		},

		XP = 5,

		Color = Color3.fromRGB(255,220,90)
	},

	Carrot = {
		DisplayName = "Carrot",
		SeedName = "Carrot Seed",

		GrowTime = 90,

		HarvestAmount = {
			Min = 2,
			Max = 4
		},

		SellPrice = 25,

		Stages = {
			"Stage1",
			"Stage2",
			"Stage3",
			"Ready"
		},

		XP = 8,

		Color = Color3.fromRGB(255,120,0)
	},

	Potato = {
		DisplayName = "Potato",
		SeedName = "Potato Seed",

		GrowTime = 120,

		HarvestAmount = {
			Min = 3,
			Max = 6
		},

		SellPrice = 40,

		Stages = {
			"Stage1",
			"Stage2",
			"Stage3",
			"Ready"
		},

		XP = 12,

		Color = Color3.fromRGB(170,120,70)
	},

	Corn = {
		DisplayName = "Corn",
		SeedName = "Corn Seed",

		GrowTime = 180,

		HarvestAmount = {
			Min = 4,
			Max = 8
		},

		SellPrice = 75,

		Stages = {
			"Stage1",
			"Stage2",
			"Stage3",
			"Ready"
		},

		XP = 20,

		Color = Color3.fromRGB(255,255,0)
	},

	---------------------------------------------------------
	-- Rare Crops
	---------------------------------------------------------

	Tomato = {
		DisplayName = "Tomato",
		SeedName = "Tomato Seed",

		GrowTime = 240,

		HarvestAmount = {
			Min = 3,
			Max = 5
		},

		SellPrice = 120,

		Stages = {
			"Stage1",
			"Stage2",
			"Stage3",
			"Ready"
		},

		XP = 35,

		Color = Color3.fromRGB(255,50,50)
	},

	Pumpkin = {
		DisplayName = "Pumpkin",
		SeedName = "Pumpkin Seed",

		GrowTime = 360,

		HarvestAmount = {
			Min = 1,
			Max = 2
		},

		SellPrice = 250,

		Stages = {
			"Stage1",
			"Stage2",
			"Stage3",
			"Ready"
		},

		XP = 50,

		Color = Color3.fromRGB(255,130,0)
	},

	Watermelon = {
		DisplayName = "Watermelon",
		SeedName = "Watermelon Seed",

		GrowTime = 480,

		HarvestAmount = {
			Min = 1,
			Max = 3
		},

		SellPrice = 500,

		Stages = {
			"Stage1",
			"Stage2",
			"Stage3",
			"Ready"
		},

		XP = 75,

		Color = Color3.fromRGB(0,200,70)
	}

}

-------------------------------------------------------------
-- Helper Functions
-------------------------------------------------------------

function CropData:GetCrop(Name)
	return self[Name]
end

function CropData:GetSellPrice(Name)
	if self[Name] then
		return self[Name].SellPrice
	end

	return 0
end

function CropData:GetGrowTime(Name)
	if self[Name] then
		return self[Name].GrowTime
	end

	return 0
end

function CropData:GetHarvest(Name)
	if self[Name] then
		local Data = self[Name]

		return math.random(
			Data.HarvestAmount.Min,
			Data.HarvestAmount.Max
		)
	end

	return 0
end

function CropData:GetXP(Name)
	if self[Name] then
		return self[Name].XP
	end

	return 0
end

return CropData