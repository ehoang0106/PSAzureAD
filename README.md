# Manager Users and Licenses PowerShell Script
![demo](https://imgur.com/a/gQYORqp)

The `ManageUsers.ps1` script is designed for efficient user creation within Azure Active Directory. 
The script automates task creating users account leveraging AzureAD module capabilities.
This tool is ideal for system administrators creating large users bases in Azure AD.

## Prerequisites

- Internet connection.
- PowerShell 5.0 or higher.
- AzureAD module installed.
- An Azure AD administrator account.

## Features

- **Add new user**: Add a new user to Azure Active Directory. Only need to enter their name, temporary password, and department.

- **Remove an existing user**: Remove user and unassigned all the licenses with just their email address.

- **Assign Microsoft 365 Business License**: Assign Microsoft 365 License to a user.

- **Unassign licenses**: Unassigned all the licenses or M365 license.

- **Search assigned licenses**: Search assigned licenses for a user by using a provided csv file containing licenses SKU ID, part ID, and name of licenses.

- **Reset password**: Quickly reset password for a user.

## Installation

1. **Install AzureAD Module**: 

```PowerShell
Install-Module AzureAD
```
2. **Set Execution Policy**: To enable script execution, set the policy to by pass. 

```PowerShell
Set-ExecutionPolicy bypass -scope process
```
3. **Run as Adminstator**: Ensure to run PowerShell as an Administrator for proper script execution.

## Configuration

- **Connect to AzureAD**: Before running the script, connect to your Azure AD tenant using:
```PowerShell
Connect-AzureAD
```
- **CSV File Setup**: Prepare a CSV file with user details as per your requirements. The basic csv file should be included 4 columns `GivenName,Surname,Department,JobTitle`.



## Usage

To run the script, ensure you are running PowerShell as Administrator. Navigate to the script's directory by using:
```PowerShell
Set-Location -path <Script path>
```

Then run the script:

```PowerShell
.\ManageUser.ps1
```

Ensure the CSV file is correctly configured as the script may depend on it for user data.

## Troubleshooting

- Ensure network connectivity to Azure AD.
- Verify the csv file is accurate and accessible.