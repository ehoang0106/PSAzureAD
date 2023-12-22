

function ThemUser {
    param (
        [string]$DisplayName,
        [string]$GivenName,
        [string]$Surname,
        [SecureString]$Password,
        [string]$UserPrincipalName,
        [string]$Department,
        [string]$UsageLocation = "US",
        [string]$MailNickName,
        [Bool]$AccountEnabled = $true
    )

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
        # $MailNickName = Read-Host "Enter Mail Nick Name"
        # $MailNickName = $MailNickName.replace(' ', '').ToLower()

        $MailNickName = $GivenName[0], $Surname -join ""
    }
    # Create PasswordProfile object
    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = $Password

    # Create new Azure AD user
    New-AzureADUser -DisplayName $DisplayName -GivenName $GivenName -Surname $Surname -PasswordProfile $PasswordProfile -UserPrincipalName $UserPrincipalName -Department $Department -UsageLocation $UsageLocation -AccountEnabled $AccountEnabled -MailNickName $MailNickName 
}


ThemUser

# PSAZ-CreateNewUser -Displayname $DisplayName -PasswordProfile $PasswordProfile -UserPrincipalName $UserPrincipalName -UsageLocation $UsageLocation -AccountEnabled $true
# $LicensedUser = Get-AzureADUser -ObjectId "pngo@awakenservices.net"  
# $User = Get-AzureADUser -ObjectId "newuser@awakenservices.net"  
# $License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense 
# $License.SkuId = $LicensedUser.AssignedLicenses.SkuId 
# $Licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses 
# $Licenses.AddLicenses = $License 
# Set-AzureADUserLicense -ObjectId $User.ObjectId -AssignedLicenses $Licenses
