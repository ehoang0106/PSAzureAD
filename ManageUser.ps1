
function Enter-NewUser {
   

    # Prompt for user input if not provided as arguments
    if (-not $GivenName){
        $GivenName = Read-Host "Enter Firstname"
    }
    if (-not $Surname){
        $Surname = Read-Host "Enter Lastname"
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
    Write-Host "$DisplayName has been added!" -ForegroundColor green 
}




function Enter-DelUser {
    param (
        [string] $ObjectID
    )
    Write-Host "Warning! This function is removing user. Please be careful!!!" -ForegroundColor Red -BackgroundColor White
    Write-Host
    
    while($true){
        $option = $(Write-Host "Please confirm again before removing user (Y/N): " -ForegroundColor Red -BackgroundColor White; Read-Host) 
        $option = $option.ToLower()
        if($option -eq "y"){
            $ObjectID = Read-Host "Enter user's email"

            $user = Get-AzureADUser -ObjectId $ObjectID
            $nameOfUser = $user.DisplayName
            $emailOfUser = $user.UserPrincipalName

            Remove-AzureADUser -ObjectId $ObjectID | Out-Host

            Write-Host "$nameOfuser($emailOfUser) has been removed! The account is still staying in the Deleted User folder" -ForegroundColor Green -BackgroundColor White
            break
        }
        elseif($option -eq "n"){
            break
        }
        else{
            Write-Host "Invalid option. Try again!"
        }
    }
    
    
}


function Grant-365License {

    #M365 SKUID: f245ecc8-75af-4f8e-b61f-27d8114de5f3

    
    $EmailUser = Read-Host "Enter user's email"
    $User = Get-AzureADUser -ObjectId $EmailUser

    #create a AssignedLicense object
    $Sku = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense

    #Set the SKU ID -> This is M365 Office SKUID
    $Sku.SkuId = "f245ecc8-75af-4f8e-b61f-27d8114de5f3"

    #Create the AssignedLicenses object
    $Licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses

    #Add the SKU
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

    $Email = Read-Host "Enter user's email"    
    $User = Get-AzureADUser -ObjectId $Email

    #current assigned licenses of the user
    $CurrentLicenses = $User.AssignedLicenses

    #create object to hold user's licenses
    $Licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses

    $M365License = "f245ecc8-75af-4f8e-b61f-27d8114de5f3" #this is M365 office license SKU ID

    Write-Host
    Write-Host "Enter (1) to remove Microsoft 365 Standard license"
    Write-Host "Enter (2) to remove all the assigned licenses"
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




function Search-365Users {
    $Sku = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense

    #this is SKU ID of Microsoft 365 Business standard
    $Sku.SkuId = "f245ecc8-75af-4f8e-b61f-27d8114de5f3"
    
    Get-AzureADUser -All $true | 
        Where-Object {$_.AssignedLicenses.SkuId -contains $Sku.SkuId} | 
        Select-Object DisplayName, UserPrincipalName |  #only show display name and user's email (userprincipalname)
        Out-Host
}




function Open-OptionMenu {
    while($true){
        Write-Host "`n----------------------" 
        Write-Host "     Menu option  " 
        Write-Host "----------------------" 
        Write-Host "Enter (1) to Add a new user" -ForegroundColor Cyan 
        Write-Host "Enter (2) to Assign M365 Office license to a user" -ForegroundColor Cyan 
        Write-Host "Enter (3) to List out users that assigned M365 Office license" -ForegroundColor Cyan 
        Write-Host "Enter (4) to Remove an existing user" -ForegroundColor Red 
        Write-Host "Enter (5) to Unassigned licenses to a user" -ForegroundColor Red 
        Write-Host "Enter (q) to Exit" -ForegroundColor Red 
        Write-Host "----------------------"

        $option = $(Write-Host "Enter option: " -ForegroundColor DarkCyan -NoNewline; Read-Host) 


        # switch ($option) {
        #     "1" { Enter-NewUser }
        #     "2" { Grant-365License }
        #     "3" { Search-365Users }
        #     "4" { Enter-DelUser  }
        #     "5" { Remove-Licenses }
        #     "q" { break }    
        #     Default {Write-Host "Wrong input. Try again!" -ForegroundColor Red -BackgroundColor White}
        # }

        if ($option -eq "1"){
            Enter-NewUser
        }
        elseif ($option -eq "2"){
            Grant-365License
        }
        elseif ($option -eq "3") {
            Search-365Users
        }
        elseif ($option -eq "4") {
            Enter-DelUser
        }
        elseif ($option -eq "5") {
            Remove-365License
        }
        elseif ($option -eq "q"){
            break
        }
        else {
            Write-Host
            Write-Host "`Invalid input. Try again!" -ForegroundColor Red -BackgroundColor White
        }
    }
    
}

Open-OptionMenu

