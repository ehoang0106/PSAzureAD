





# function Open-OptionMenu1 {
#     while($true){
#         Write-Host "`n----------------------" 
#         Write-Host "     Menu option  " 
#         Write-Host "----------------------" 
#         Write-Host "Enter (1) to Add a new user" -ForegroundColor Cyan 
#         Write-Host "Enter (2) to Assign M365 Office license to a user" -ForegroundColor Cyan 
#         Write-Host "Enter (3) to List out users that assigned M365 Office license" -ForegroundColor Cyan 
#         Write-Host "Enter (4) to Search assigned licenses to a user" -ForegroundColor Cyan 
#         Write-Host "Enter (n) to Skip to the next page" -ForegroundColor Yellow 
#         Write-Host "Enter (q) to Exit" -ForegroundColor DarkYellow 
#         Write-Host "----------------------"

#         $option = $(Write-Host "Enter option: " -ForegroundColor DarkCyan -NoNewline; Read-Host) 


#         if ($option -eq "1"){
#             Enter-NewUser
#         }
#         elseif ($option -eq "2"){
#             Grant-365License
#         }
#         elseif ($option -eq "3") {
#             Search-365Users
#         }
#         elseif ($option -eq "4") {
#             Search-LicenseName
#         }
#         elseif ($option -eq "n"){
#             Clear-Host
#             Open-OptionMenu2
#         }
#         elseif ($option -eq "q"){
#             break
#         }
#         else {
#             Write-Host
#             Write-Host "`nInvalid input. Try again!" -ForegroundColor Red -BackgroundColor White
#         }
#     }
    
# }

# function Open-OptionMenu2 {
#     while($true){
#         Write-Host "`n----------------------" 
#         Write-Host "     Menu option  " 
#         Write-Host "----------------------" 
    
#         Write-Host "Enter (1) to Remove an existing user" -ForegroundColor Red 
#         Write-Host "Enter (2) to Unassigned licenses to a user" -ForegroundColor Red
#         Write-Host "Enter (p) to Return to the previous page" -ForegroundColor Yellow 
#         Write-Host "----------------------"

#         $option = $(Write-Host "Enter option: " -ForegroundColor DarkCyan -NoNewline; Read-Host) 


#         if ($option -eq "1"){
#             Enter-DelUser
#         }
#         elseif ($option -eq "2"){
#             Search-LicenseName
#         }
#         elseif ($option -eq "p"){
#             break
#         }
#         else {
#             Write-Host
#             Write-Host "`nInvalid input. Try again!" -ForegroundColor Red -BackgroundColor White
#         }
#     }
    
# }

# Open-OptionMenu1





# function Open-OptionMenu1 {
    
#     Clear-Host
#     while($true){
#         Write-Host "`n----------------------" 
#         Write-Host "     Menu option  " 
#         Write-Host "----------------------" 
#         Write-Host "Enter (1) to Add a new user" -ForegroundColor Cyan 
#         Write-Host "Enter (2) to Assign M365 Office license to a user" -ForegroundColor Cyan 
#         Write-Host "Enter (3) to List out users that assigned M365 Office license" -ForegroundColor Cyan 
#         Write-Host "Enter (4) to Search assigned licenses to a user" -ForegroundColor Cyan 
#         Write-Host
#         Write-Host "Enter (n) to Skip to the next page" -ForegroundColor Yellow 
#         Write-Host "Enter (q) to Exit" -ForegroundColor DarkYellow 
#         Write-Host "----------------------"

#         $option = $(Write-Host "Enter option: " -ForegroundColor DarkCyan -NoNewline; Read-Host) 


#         if ($option -eq "1"){
#             Enter-NewUser
#         }
#         elseif ($option -eq "2"){
#             Grant-365License
#         }
#         elseif ($option -eq "3") {
#             Search-365Users
#         }
#         elseif ($option -eq "4") {
#             Search-LicenseName
#         }
#         elseif ($option -eq "n"){
            
#             Clear-Host
#             Open-OptionMenu2
#             Clear-Host


#         }
#         elseif ($option -eq "q"){
#             break
#         }
#         else {
#             Write-Host
#             Write-Host "`nInvalid input. Try again!" -ForegroundColor Red -BackgroundColor White
#         }
#     }
    
# }

# function Open-OptionMenu2 {
#     while($true){
#         Write-Host "`n----------------------" 
#         Write-Host "     Menu option  " 
#         Write-Host "----------------------" 
    
#         Write-Host "Enter (1) to Remove an existing user" -ForegroundColor Red 
#         Write-Host "Enter (2) to Unassigned licenses to a user" -ForegroundColor Red
#         Write-Host
#         Write-Host "Enter (p) to Return to the previous page" -ForegroundColor Yellow 
#         Write-Host "Enter (q) to Exit" -ForegroundColor DarkYellow 
#         Write-Host "----------------------"

#         $option = $(Write-Host "Enter option: " -ForegroundColor DarkCyan -NoNewline; Read-Host) 


#         if ($option -eq "1"){
#             Enter-DelUser
#         }
#         elseif ($option -eq "2"){
#             Search-LicenseName
#         }
#         elseif ($option -eq "p"){
#             break
#         }
#         elseif ($option -eq "q"){
            
#             exit
#         }
#         else {
#             Write-Host
#             Write-Host "`nInvalid input. Try again!" -ForegroundColor Red -BackgroundColor White
#         }
#     }
    
# }

