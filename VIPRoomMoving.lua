local offset = Vector3.new(0,100,0)

local root = game.Workspace["Ship Tycoon 2"].Tycoons
local selective = false
local tycoons = {root["Bright blue"]}

local searchTerms = {"VIP", "Bedrock", "Azurite", "Orpiment", "Turbo", "Enhanced", "Premium", "Elite"}
local extra = {"OrpimentCon", "BedrockCon", "AzuriteCon", "PremiumCon"}
    
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
  for _, tycoon in pairs(game.Workspace["Ship Tycoon 2"].Tycoons:GetChildren()) do 
        move(tycoon)
        print(tycoon.Name)
  end  
end
