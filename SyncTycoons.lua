for _, tycoon in pairs(game.Workspace["Ship Tycoon 2"].Tycoons:GetChildren()) do 
	local clone = game.Workspace["Ship Tycoon 2"].Tycoons["Bright blue"]:Clone()
	clone.Parent = game.Workspace["Ship Tycoon 2"].Tycoons
	clone:PivotTo(tycoon:GetPivot())
	clone:WaitForChild("TeamColor").Value = tycoon:WaitForChild("TeamColor").Value
	clone.Name = tycoon.Name
	tycoon:Destroy()
	print("Successfully synced tycoon: "..clone.Name)
end
