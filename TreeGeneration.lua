function PrimaryTree()
	for i, v in pairs(game.Workspace.Trees:GetChildren()) do 
		for _, part in pairs(v:GetChildren()) do
			if part.Orientation.X == 0 and part.Orientation.Z == 0 then 
				v.PrimaryPart = part
				part.Name = "Stem" 
			end 
		end 
	end
end

function GenerateTrees(amount)
	for i = 1, amount or 100 do 
		local Table = game.Workspace.Trees:GetChildren() 
		local Tree = Table[math.random(1, #Table)]:Clone() 
		Tree.Parent = game.Workspace.GeneratedTrees 
		Tree:SetPrimaryPartCFrame(CFrame.new(math.random(-1115, 1115) + 189, 195.31 + Tree.Stem.Size.Y / 2, math.random(-1115, 1115) - 1204.16)) 
	end
end

function PruneTrees()
	for _, tree in pairs(game.Workspace.GeneratedTrees:GetChildren()) do local rayOrigin = tree.Stem.Position
		local rayDirection = Vector3.new(0, -90, 0)


		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = {tree.Parent}
		raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
		local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
		if not raycastResult then
			print("Hovering Tree Detected - Removing Tree")
			tree:Destroy()
		elseif raycastResult.Material ~= Enum.Material.Grass then
			print("Out Of Bounds Tree Detected - Removing Tree")
			tree:Destroy()
		end
	end
end
