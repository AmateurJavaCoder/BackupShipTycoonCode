local offset = Vector3.new(9,0,3)

local root = game.Workspace["Ship Tycoon 2"].Tycoons
local tycoons = {root["Bright blue"]}

local function move(tycoons) 
    for _, purchase in pairs(tycoons.Purchases:GetChildren()) do
        if string.find(string.upper(purchase.Name), "VIP") or string.find(string.upper(purchase.Name), "BEDROCK") or string.find(string.upper(purchase.Name), "AZURITE") or string.find(string.upper(purchase.Name), "ORPIMENT") or string.find(string.upper(purchase.Name), "TURBO") or string.find(string.upper(purchase.Name), "ENHANCED") or string.find(string.upper(purchase.Name), "PREMIUM") then 
            for i, v in pairs(purchase:GetDescendants() ) do
                if v:IsA("BasePart") or v:IsA("UnionOperation") then 
                    v.Position += offset 
                end 
            end 
        end
    end 
    for _, purchase in pairs(tycoons.Buttons:GetChildren()) do 
        if string.find(string.upper(purchase.Name), "VIP") or string.find(string.upper(purchase.Name), "BEDROCK") or string.find(string.upper(purchase.Name), "AZURITE") or string.find(string.upper(purchase.Name), "ORPIMENT") or string.find(string.upper(purchase.Name), "TURBO") or string.find(string.upper(purchase.Name), "ENHANCED") or string.find(string.upper(purchase.Name), "PREMIUM") then 
            purchase.Head.Position += offset
        end 
    end 

    local extra = {"OrpimentCon", "BedrockCon", "AzuriteCon", "PremiumCon"}
    for i, v in pairs(extra) do
        tycoons.Purchases:FindFirstChild(v).Position += offset
    end
end

if #tycoons > 0 then
    for _, tycoon in pairs(tycoons) do
       move(tycoon) 
    end
else
  for _, tycoon in pairs(game.Workspace["Ship Tycoon 2"].Tycoons:GetChildren()) do 
        move(tycoon)
  end  
end
