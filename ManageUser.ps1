#--------------------------------------------------------------------------------------#

#Install AzureAD module

#Install-Module AzureAD

#Need to Set-ExecutionPolicy to bypass to ensure the script can run

#Set-ExecutionPolicy bypass -scope process

#Run the script as Administrator

#Type Connect-AzureAD to connect Azure AD and run the script

#$CsvPath = C:\Users\KhoaHoang\Downloads\VSCode\Powershell-Project\ManagerUser\sku.csv

#--------------------------------------------------------------------------------------#





function Enter-NewUser {
   
    # Prompt for user input if not provided as arguments
    if (-not $GivenName){
        $GivenName = Read-Host "Enter Firstname"
        $GivenName = (Get-Culture).TextInfo.ToTitleCase($GivenName)
    }
    if (-not $Surname){
        $Surname = Read-Host "Enter Lastname"
        $Surname = (Get-Culture).TextInfo.ToTitleCase($Surname)
    }
    if (-not $DisplayName) {
        $DisplayName = "$GivenName $Surname"
    }

    if (-not $Password) {
        $Password = Read-Host "Enter Temporary Password" -AsSecureString
    }

    if (-not $UserPrincipalName) {
        $domain = "@awakenservices.net"
        
        $UserPrincipalName = $GivenName[0], $Surname, $domain -join ""
        $UserPrincipalName = $UserPrincipalName.ToLower()
    }

    if (-not $Department) {
        $Department = Read-Host "Enter Department"
    }

    if(-not $MailNickName){

        $MailNickName = $GivenName[0], $Surname -join ""
    }
    # Create PasswordProfile object
    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = $Password

    # Create new Azure AD user
    New-AzureADUser -DisplayName $DisplayName -GivenName $GivenName -Surname $Surname -PasswordProfile $PasswordProfile -UserPrincipalName $UserPrincipalName -Department $Department -UsageLocation "US" -AccountEnabled $true -MailNickName $MailNickName | Out-Host
    Write-Host "`n$DisplayName ($UserPrincipalName) has been added!" -ForegroundColor green 
}



function Enter-DelUser {
    param (
        [string] $ObjectID
    )
    Write-Host "Warning! This function is removing user. Please be careful!!!" -ForegroundColor Red -BackgroundColor White
    Write-Host
    
    
    $ObjectID = Read-Host "Enter user's email"

    $user = Get-AzureADUser -ObjectId $ObjectID
    $nameOfUser = $user.DisplayName
    $emailOfUser = $user.UserPrincipalName

    Remove-AzureADUser -ObjectId $ObjectID | Out-Host
    Write-Host
    Write-Host "$nameOfuser($emailOfUser) has been removed! The account is still staying in the Deleted User folder" -ForegroundColor Green
            
        
        
        
}

function Enter-NewUserPW {
    param (
        [string] $Email,
        [SecureString] $Password
    )
    try {
        $Email = Read-Host "Enter email"
        $Password = Read-Host "Enter Temporary Password" -AsSecureString
        $User = Get-AzureADUser -ObjectId $Email
        $NameOfUser = $User.DisplayName

        Set-AzureADUserPassword -ObjectId $Email -Password $Password
        Write-Host
        Write-Host "Successfully reset password for $NameOfUser($Email)" -ForegroundColor Green
    }
    catch {
        Write-Host "`nUser not found or Password does not comply with password complexity requirements." -ForegroundColor Red -BackgroundColor White
    }

}

function Grant-365License {

    # M365 SKUID: f245ecc8-75af-4f8e-b61f-27d8114de5f3
    
    $EmailUser = Read-Host "Enter user's email"
    $User = Get-AzureADUser -ObjectId $EmailUser

    #create a AssignedLicense object to hold SkuId
    $Sku = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense

    #Set the SKU ID to the Sku object -> This is M365 Office SKUID
    $Sku.SkuId = "f245ecc8-75af-4f8e-b61f-27d8114de5f3"

    #Create the AssignedLicenses object to add a SkuId to assign license(s)
    $Licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses

    #Add the SkuId (which is a m365 license to $Linceses object)
    $Licenses.AddLicenses = $Sku

    #Assign the license to the user
    Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $Licenses | Out-Host

    $nameOfUser = $User.DisplayName
    $email = $User.UserPrincipalName


    Write-Host "`nMicrosoft 365 License for $nameOfUser($email) has been added!" -ForegroundColor green 

}


function Remove-Licenses {
    param(
        [string]$Email
    )
    try {
        $Email = Read-Host "Enter user's email"    
        $User = Get-AzureADUser -ObjectId $Email
        $name = $user.DisplayName

        #current assigned licenses of the user
        $CurrentLicenses = $User.AssignedLicenses

        #create object to hold user's licenses
        $Licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses

        $M365License = "f245ecc8-75af-4f8e-b61f-27d8114de5f3" #this is M365 office license SKU ID

        Write-Host
        Write-Host "Enter (1) to remove Microsoft 365 Standard license" -ForegroundColor Cyan
        Write-Host "Enter (2) to remove all the assigned licenses" -ForegroundColor Red
        $option = Read-Host "Option"

        if($option -eq "1"){
            foreach($li in $CurrentLicenses.SkuId){
                if($li -eq $M365License){
                    $Licenses.RemoveLicenses = $li
                }
            }
            #remove 365 license
            Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $Licenses
        
            Write-Host "`nMicrosoft 365 license for $($User.DisplayName)($Email) has been removed!" -ForegroundColor Green 
        }
        elseif($option -eq "2"){
            foreach($li in $CurrentLicenses.SkuId){
                $Licenses.RemoveLicenses += $li
            }

            Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $Licenses

            Write-Host "`nAll the assigned licenses for $($User.DisplayName)($Email) has been removed!" -ForegroundColor Green
        }
        else{
            Write-Host "Wrong input!" -ForegroundColor Red -BackgroundColor White
        }
    }
    catch {
            if ($_.Exception.Response.StatusCode -eq 'NotFound') {
                Write-Host "`nResource not found: $($_.Exception.Message)"
            }
            elseif ($_.Exception.Message -match 'Resource.*not exist') {
                Write-Host "`nUser not found" -ForegroundColor Red -BackgroundColor White
            }
            elseif ($_.Exception.Response.StatusCode -eq 'BadRequest') {
                Write-Host "`nBad request error: $($_.Exception.Message)"
            }
            elseif ($_.Exception.Message -match 'No license changes provided') {
                Write-Host "`n$name($Email) has not been assigned any licenses." -ForegroundColor DarkYellow
            }
            else {
                throw $_
            }
    }
}



function Search-365Users {
    $Sku = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense

    #this is SKU ID of Microsoft 365 Business standard
    $Sku.SkuId = "f245ecc8-75af-4f8e-b61f-27d8114de5f3"
    
    Get-AzureADUser -All $true | 
        Where-Object {$_.AssignedLicenses.SkuId -contains $Sku.SkuId} | 
        Select-Object DisplayName, UserPrincipalName |  #only show display name and user's email (userprincipalname)
        Out-Host
}

function Search-LicenseName {
    # import csv file
    $csv = Import-Csv -path C:\Users\KhoaHoang\Downloads\VSCode\Powershell-Project\ManagerUser\sku.csv

    try {
        $email = Read-Host "Enter user's email"
        Write-Host
        $user = Get-AzureADUser -ObjectId $email
        $name = $user.DisplayName

        #Create a variable to hold the SKUs ID of the assigned licenses
        $UserLicenseSKUs = $user.AssignedLicenses.SkuId
        
        $MatchFound = $false
        
        for ($i = 0; $i -lt $csv.licenseSKUID.Count; $i++) {
        
            foreach ($li in $UserLicenseSKUs) {
                if ($li -eq $csv.licenseSKUID[$i]) {
                    Write-Host $csv.ProductName[$i] -ForegroundColor Green
                    $MatchFound = $true # set the flag to true if a match is found
                }
            }
        }
        
        # Check if no match was found after going through all UserLicenseSKUs
        if (-not $MatchFound) {
            Write-Host "`n$name($email) has not been assigned any licenses." -ForegroundColor DarkYellow
        }
        
    }
    catch {
        Write-Host "User not found!" -ForegroundColor red -BackgroundColor White
    }
    
}
function Open-OptionMenu {
    while($true){
        Write-Host "`n----------------------" 
        Write-Host "     Menu option  " 
        Write-Host "----------------------" 
        Write-Host "Enter (1) to Add a new user" -ForegroundColor Cyan 
        Write-Host "Enter (2) to Assign M365 Office license to a user" -ForegroundColor Cyan 
        Write-Host "Enter (3) to Remove an existing user" -ForegroundColor Red 
        Write-Host "Enter (4) to Unassigned licenses to a user" -ForegroundColor Red
        Write-Host "Enter (5) to Search assigned licenses to a user" -ForegroundColor Cyan
        Write-Host "Enter (6) to Reset password for a user" -ForegroundColor Cyan
        Write-Host "Enter (7) to List users has been assigned M365 Standard license" -ForegroundColor Cyan 
        Write-Host "Enter (q) to Exit" -ForegroundColor Red 
        Write-Host "----------------------"

        $option = $(Write-Host "Enter option: " -ForegroundColor DarkCyan -NoNewline; Read-Host) 

        if ($option -eq "1"){
            Enter-NewUser
        }
        elseif ($option -eq "2"){
            Grant-365License
        }
        elseif ($option -eq "3") {
            Enter-DelUser
        }
        elseif ($option -eq "4") {
            Remove-Licenses
        }
        elseif ($option -eq "5") {
            Search-LicenseName
        }
        elseif ($option -eq "6") {
            Enter-NewUserPW
        }
        elseif ($option -eq "7") {
            Search-365Users
        }
        elseif ($option -eq "q"){
            break
        }
        else {
            Write-Host
            Write-Host "`nInvalid input. Try again!" -ForegroundColor Red -BackgroundColor White
        }
    }
    
}


Open-OptionMenu

