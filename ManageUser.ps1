# param(
#         [string]$DisplayName,
#         [string]$GivenName,
#         [string]$Surname,
#         [SecureString]$Password,
#         [string]$UserPrincipalName,
#         [string]$Department,
#         [string]$UsageLocation = "US",
#         [string]$MailNickName,
#         [Bool]$AccountEnabled = $true
#     )

function Adding-NewUser {
   

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
    New-AzureADUser -DisplayName $DisplayName -GivenName $GivenName -Surname $Surname -PasswordProfile $PasswordProfile -UserPrincipalName $UserPrincipalName -Department $Department -UsageLocation "US" -AccountEnabled $true -MailNickName $MailNickName 
    Write-Host "$DisplayName has been added!" -ForegroundColor green 
}



# PSAZ-CreateNewUser -Displayname $DisplayName -PasswordProfile $PasswordProfile -UserPrincipalName $UserPrincipalName -UsageLocation $UsageLocation -AccountEnabled $true
# $LicensedUser = Get-AzureADUser -ObjectId "pngo@awakenservices.net"  
# $User = Get-AzureADUser -ObjectId "newuser@awakenservices.net"  
# $License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense 
# $License.SkuId = $LicensedUser.AssignedLicenses.SkuId 
# $Licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses 
# $Licenses.AddLicenses = $License 
# Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $Licenses

function Removing-User {
    param (
        [string] $ObjectID
    )
    Write-Host "Warning! This function is removing user. Please be careful!!!" -ForegroundColor Red -BackgroundColor White
    $ObjectID = Read-Host "Enter user's email"

    $user = Get-AzureADUser -ObjectId $ObjectID
    $nameOfUser = $user.DisplayName

    Remove-AzureADUser -ObjectId $ObjectID

    Write-Host "$nameOfuser has been removed! The account is still staying at the Deleted User folder" -ForegroundColor Green -BackgroundColor White
}

function Menu-Option {
    while($true){
        Write-Host "`n----------------------"
        Write-Host "Enter (1) to Add a new user"
        Write-Host "Enter (2) to Remove an existing user"
        Write-Host "Enter (3) to Exit"
        Write-Host "----------------------"

        $option = Read-Host "Enter option"


        if ($option -eq "1"){
            Adding-NewUser
        }
        elseif ($option -eq "2"){
            Removing-User
        }
        elseif ($option -eq "3") {
            break
        }
        else {
            Write-Host "Invalid input. Try again!"
        }
    }
    
}

Menu-Option