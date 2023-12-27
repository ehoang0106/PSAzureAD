

function Enter-Users {
    # Importing the CSV file
    $csvFile = Import-Csv -path C:\Users\KhoaHoang\Downloads\VSCode\Powershell-Project\ManagerUser\users.csv

    # Domain and password setup
    $domain = "@awakenservices.net"
    $Password = "Welcome123#!"
    $PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password = $Password

    
    foreach ($row in $csvFile) {
        $DisplayName = $row.GivenName + " " + $row.Surname
        $UserPrincipalName = $row.GivenName.Substring(0,1) + $row.Surname + $domain
        $UserPrincipalName = $UserPrincipalName.ToLower()
        $MailNickName = $row.GivenName.Substring(0,1) + $row.Surname
        $MailNickName = $UserPrincipalName.ToLower()

        
        New-AzureADUser -DisplayName $DisplayName -GivenName $row.GivenName -Surname $row.Surname -PasswordProfile $PasswordProfile -UserPrincipalName $UserPrincipalName -Department $row.Department -UsageLocation "US" -AccountEnabled $true -MailNickName $MailNickName
    }
}

Enter-Users
