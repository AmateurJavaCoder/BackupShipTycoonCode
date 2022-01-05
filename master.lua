--[[Basically just has all the different macros in function form for easy execution!]]
local DataStoreService = game:GetService("DataStoreService")
local DSS = DataStoreService
local PhysicsService = game:GetService("PhysicsService")


local Updated = "29/12/2021 14:28 UTC+10"

function clearFeedback()
  local BugReports = DSS:GetDataStore("BugReports")
  local Feedback = DSS:GetDataStore("Feedback")
  Feedback:RemoveAsync("Value")
  print("Cleared Feedback")
  BugReports:RemoveAsync("Value")
  print("Cleared Bug Reports")
end

function clear(userInfo)
	local userId
	if tonumber(userInfo) then
		userId = tonumber(userInfo)
	else
		userId = game:GetService("Players"):GetUserIdFromNameAsync(userInfo)
	end
	local orderedDataStore = DataStoreService:GetOrderedDataStore("Money" .. "/" .. userId)
	local dataStore = DataStoreService:GetDataStore("Money" .. "/" .. userId)

	repeat 
		local pages = orderedDataStore:GetSortedAsync(false, 100)
		local data = pages:GetCurrentPage()
		for _, pair in pairs(data) do
			print(("key: %d"):format(pair.key))
			dataStore:RemoveAsync(pair.key)
			orderedDataStore:RemoveAsync(pair.key)
		end
	until pages.IsFinished
	print(("finished (%d: %s)"):format(userId, "Money"))

	orderedDataStore = DataStoreService:GetOrderedDataStore("Purchases" .. "/" .. userId)
	dataStore = DataStoreService:GetDataStore("Purchases" .. "/" .. userId)

	repeat 
		local pages = orderedDataStore:GetSortedAsync(false, 100)
		local data = pages:GetCurrentPage()
		for _, pair in pairs(data) do
			print(("key: %d"):format(pair.key))
			dataStore:RemoveAsync(pair.key)
			orderedDataStore:RemoveAsync(pair.key)
		end
	until pages.IsFinished
	print(("finished (%d: %s)"):format(userId, "Purchases"))
	
	orderedDataStore = DataStoreService:GetOrderedDataStore("Collector" .. "/" .. userId)
	dataStore = DataStoreService:GetDataStore("Collector" .. "/" .. userId)

	repeat 
		local pages = orderedDataStore:GetSortedAsync(false, 100)
		local data = pages:GetCurrentPage()
		for _, pair in pairs(data) do
			print(("key: %d"):format(pair.key))
			dataStore:RemoveAsync(pair.key)
			orderedDataStore:RemoveAsync(pair.key)
		end
	until pages.IsFinished
	print(("finished (%d: %s)"):format(userId, "CurrencyToCollect"))
	
	orderedDataStore = DataStoreService:GetOrderedDataStore("Rebirths" .. "/" .. userId)
	dataStore = DataStoreService:GetDataStore("Rebirths" .. "/" .. userId)

	repeat 
		local pages = orderedDataStore:GetSortedAsync(false, 100)
		local data = pages:GetCurrentPage()
		for _, pair in pairs(data) do
			print(("key: %d"):format(pair.key))
			dataStore:RemoveAsync(pair.key)
			orderedDataStore:RemoveAsync(pair.key)
		end
	until pages.IsFinished
	print(("finished (%d: %s)"):format(userId, "Rebirths"))
end

function syncTycoons()
	for _, tycoon in pairs(game.Workspace.ShipTycoon.Tycoons:GetChildren()) do
		if tycoon.Name ~= "Bright blue" then
			local clone = game.Workspace.ShipTycoon.Tycoons["Bright blue"]:Clone()
			clone.Parent = game.Workspace.ShipTycoon.Tycoons
			clone:PivotTo(tycoon:GetPivot())
			clone:WaitForChild("TeamColor").Value = tycoon:WaitForChild("TeamColor").Value
			clone.Essentials.Spawn.BrickColor = tycoon.TeamColor.Value
			clone.Purchases.VIPRoom.Color.BrickColor = tycoon.TeamColor.Value
			clone.Entrance.Part1.BrickColor = tycoon.TeamColor.Value
			clone.Entrance.Part2.BrickColor = tycoon.TeamColor.Value
			clone.Name = tycoon.Name
			tycoon:Destroy()
			print("Successfully synced tycoon: "..clone.Name)
		end
	end
end

function syncTycoonScript()
	for _, tycoon in pairs(game.Workspace.ShipTycoon.Tycoons:GetChildren()) do
		if tycoon.Name ~= "Bright blue" then
			tycoon.PurchaseHandler.Source = game.Workspace.ShipTycoon.Tycoons["Bright blue"].PurchaseHandler.Source	
			print("Updated PurchaseHandler in: "..tycoon.Name)
		end
	end
end

function moveVIPRooms(offset1, offset2, offset3)
	local offset = Vector3.New(offset1 or 0, offset2 or 0, offset3 or 0) 


	local root = game.Workspace.ShipTycoon.Tycoons
	local selective = false
	local tycoons = {root["Bright blue"]}

	local searchTerms = {"VIP", "Bedrock", "Azurite", "Orpiment", "Turbo", "Premium", "Enhanced", "Elite"}
	local extra = {"OrpimentCon", "BedrockCon", "AzuriteCon", "PremiumCon", "EliteCon"}

	local function search(object)
		for _, term in pairs(searchTerms) do 
			if string.find(string.upper(object.Name), string.upper(term)) then
				return true
			end
		end
		return false
	end

	local function move(tycoons) 
		for _, purchase in pairs(tycoons.Purchases:GetChildren()) do
			if search(purchase) then 
				for i, v in pairs(purchase:GetDescendants() ) do
					if v:IsA("BasePart") or v:IsA("UnionOperation") then 
						v.Position += offset 
					end 
				end 
			end
		end 
		for _, purchase in pairs(tycoons.Buttons:GetChildren()) do 
			if search(purchase) then 
				purchase.Head.Position += offset
			end 
		end 


		for i, v in pairs(extra) do
			tycoons.Purchases:FindFirstChild(v).Position += offset
		end
	end

	if selective and #tycoons > 0 then
		for _, tycoon in pairs(tycoons) do
			move(tycoon) 
			print(tycoon.Name)
		end
	else
		for _, tycoon in pairs(game.Workspace.ShipTycoon.Tycoons:GetChildren()) do 
			move(tycoon)
			print(tycoon.Name)
		end  
	end
end


function syncOldTycoons()
	for _, tycoon in pairs(game.Workspace.ShipTycoon.Tycoons:GetChildren()) do
		if tycoon.Name ~= "Bright red" then
			local clone = game.Workspace.ShipTycoon.Tycoons["Bright red"]:Clone()
			clone.Parent = game.Workspace.ShipTycoon.Tycoons
			clone:SetPrimaryPartCFrame(tycoon.PrimaryPart.CFrame)
			clone:WaitForChild("TeamColor").Value = tycoon:WaitForChild("TeamColor").Value
			clone.Name = tycoon.Name
			tycoon:Destroy()
			print("Successfully synced tycoon: "..clone.Name)
		end
	end	
end

function updateCollisions()
	for _, part in pairs(game.Workspace:GetDescendants()) do
		if part.Name == "ShipBarrier" then
			PhysicsService:SetPartCollisionGroup(part, "ShipBarriers")
			print("Set collision group")
		end
	end
end

function help()
	warn("\n\nThis is a macro script designed and maintained by PoppyandNeivaarecute, for use in the Ship Tycoon Restoration Project\nThe commands are: \nclear(user)\n\nsyncTycoons() [Syncs from Bright Blue]\nsyncTycoonScript() [Syncs purchaseHandler from Bright Blue]\nsyncOldTycoons() [Syncs from Bright Red (middle)]\n\nmoveVIPRooms(offset1, offset2, offset3)\nCameraWarp() [Teleports the camera to Bright Blue]\nclearFeedback()\nupdateColisions()\n\n\nLast updated: "..Updated.."\n")
end

function CameraWarp()
	game.Workspace.CurrentCamera.CFrame = game.Workspace.ShipTycoon.Tycoons["Bright blue"].Entrance["Touch to claim ownership!"].Head.CFrame + Vector3.new(5,0,-1)	
end

help()
