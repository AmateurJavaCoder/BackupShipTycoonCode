--[[Basically just has all the different macros in function form for easy execution!]]
local DataStoreService = game:GetService("DataStoreService")
local DSS = DataStoreService
local PhysicsService = game:GetService("PhysicsService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local Updated = "11/04/2022 10:56pm UTC+11"

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
			clone.Entrance["Touch to claim ownership!"].Part1.BrickColor = tycoon.TeamColor.Value
			clone.Entrance["Touch to claim ownership!"].Part2.BrickColor = tycoon.TeamColor.Value
			clone.Name = tycoon.Name
			tycoon:Destroy()
			print("Successfully synced tycoon: "..clone.Name)
		end
	end
	ChangeHistoryService:SetWaypoint("Post Tycoon Sync")
	warn("3 undo waypoints have been set as a buffer")
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

function getAnalytics()
	local Table = game:GetService("HTTPService"):JSONDecode(DatastoreService:GetDataStore("AnalyticsLeaveTime"):GetAsync(1))
	print("\n\nThe following data was recorded for time before players left (time (in minutes) - amount of people)\n"
	for index, amount in pairs(Table) do
		print(index.." - "..amount\n)	
	end
	print("\n\nAn error was recorded: "..DatastoreService:GetDataStore("AnalyticsError"):GetAsync(1).." times)	
end


function help()
	warn("\n\nThis is a macro script designed and maintained by PoppyandNeivaarecute, for use in the Ship Tycoon Restoration Project\nThe commands are: \nclear(user)\n\nsyncTycoons() [Syncs from Bright Blue]\nsyncTycoonScript() [Syncs purchaseHandler from Bright Blue]\nsyncOldTycoons() [Syncs from Bright Red (middle)]\n\nmoveVIPRooms(offset1, offset2, offset3)\nCameraWarp() [Teleports the camera to Bright Blue]\nclearFeedback\ngetFeedback()\nupdateColisions()\ngetAnalytics()\n\n\nLast updated: "..Updated.."\n")
end

function CameraWarp()
	game.Workspace.CurrentCamera.CFrame = game.Workspace.ShipTycoon.Tycoons["Bright blue"].Entrance["Touch to claim ownership!"].Head.CFrame + Vector3.new(5,0,-1)	
end

function getFeedback()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local BugEvent = ReplicatedStorage.RemoteEvents:WaitForChild("GiveBugReport")
	local FeedbackEvent = ReplicatedStorage.RemoteEvents:WaitForChild("GiveFeedback")
	local DS2 = require(1936396537)
	local DSS = game:GetService("DataStoreService")
	local HTTPService = game:GetService("HttpService")

	local BugReports = DSS:GetDataStore("BugReports")
	local Feedback = DSS:GetDataStore("Feedback")
	local BugReportsNumber = DSS:GetDataStore("BugReportsNumber")
	local FeedbackNumber = DSS:GetDataStore("FeedbackNumber")
	
	local numberF
	local numberB

	local pagesF = nil
	local pagesB = nil
	local rawF
	local rawB


	local success, err = pcall(function()
		rawF = Feedback:GetAsync("Value")
		rawB = BugReports:GetAsync("Value")
	end)

	if err then
		warn(err)
		return
	end

	repeat wait() until success 
	
	print("\n\n\n\n\n\n\n\n\n\n")
	
	if game.Players:FindFirstChild(game:GetService("Players"):GetNameFromUserIdAsync(84828376)) then
		if rawF then
			pagesF = HTTPService:JSONDecode(rawF) or {}
		end

		if rawB then
			pagesB = HTTPService:JSONDecode(rawB) 
		end

		warn("Player Feedback: ")
		if pagesF then

			for key, value in ipairs(pagesF) do
				print(value)
			end
		end

		warn("Player Bug Reports: ")
		if pagesB then
			for key, value in ipairs(pagesB) do
				print(value)
			end
		end

		local FeedbackOutput = ""
		if pagesF then
			for key, value in ipairs(pagesF) do
				--print(value["Text"])
				FeedbackOutput = FeedbackOutput.."\n \n"..value["Player"].."\n"..value["Text"]
			end			
		end

		print(FeedbackOutput)
		print()
		print()
		warn("Bug Reports")
		print()
		print()
		local BugOutput = ""
		if pagesB then
			for key, value in ipairs(pagesB) do
				BugOutput = BugOutput.."\n \n"..value["Player"].."\n"..value["Text"]
			end
		end
		print(BugOutput)
	end	
end
help()
