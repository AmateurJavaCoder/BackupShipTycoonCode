local function clearFeedback()
  local DSS = game:GetService("DataStoreService")
  local BugReports = DSS:GetDataStore("BugReports")
  local Feedback = DSS:GetDataStore("Feedback")
  
  Feedback:RemoveAsync("Value")
  print("Cleared Feedback")
  BugReports:RemoveAsync("Value")
  print("Cleared Bug Reports")
  
end
