--[[ Original Code from https://devforum.roblox.com/t/how-to-use-datastore2-data-store-caching-and-data-loss-prevention/136317/187, credit to Kampfkarren
Modifications to make it better for Ship Tycoon Remastered by PoppyandNeivaarecute
To use, run the below script then run:  Clear({userId}) or Clear({Username}) ]]

local DataStoreService = game:GetService("DataStoreService")

function clear(userInfo, name)
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
end
