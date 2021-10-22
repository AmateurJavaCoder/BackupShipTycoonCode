local rate = {1, 2, 3, 5, 10, 20, 5, 40}
for num, term in ipairs({"MVIP", "BVIP", "TVIP", "Premium", "Enhanced", "Elite"}) do 
for i, v in pairs(game.Workspace["Ship Tycoon 2"].Tycoons["Bright blue"].Purchases:GetChildren()) do 
    if string.find(v.Name, term) and not string.find(v.Name, "Con") then 
      local number, quantity = string.gsub(v.Name, term.."Dropper", "")
      print(number)
      print(tonumber(number))
      local source, quantitay = string.gsub(v.DropperScript.Source, "cash.Value = ", "cash.Value = "..rate[num] * number .."--")  
       v.DropperScript.Source = source
    end 
  end 
  end
