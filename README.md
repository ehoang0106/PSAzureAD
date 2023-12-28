
# ManageUser PowerShell Script

## Introduction
The `ManageUser.ps1` script is designed for efficient user management within Azure Active Directory (Azure AD). It automates tasks such as creating, updating, and removing users, leveraging AzureAD module capabilities. This tool is ideal for system administrators managing large user bases in Azure AD.

## Prerequisites
- PowerShell 5.0 or higher.
- AzureAD module installed.
- An Azure AD administrator account.

## Installation
1. **Install AzureAD Module**: Run `Install-Module AzureAD` in your PowerShell console.
2. **Set Execution Policy**: To enable script execution, set the policy to bypass: `Set-ExecutionPolicy bypass -scope process`.
3. **Run as Administrator**: Ensure to run PowerShell as an Administrator for proper script execution.

## Configuration
- **Connect to Azure AD**: Before running the script, connect to your Azure AD tenant using `Connect-AzureAD`.
- **CSV File Setup**: Prepare a CSV file with user details as per your requirements. Set the `$CsvPath` variable in the script to the location of your CSV file.

## Usage
To run the script, navigate to the script's directory and execute:
```
.\ManageUser.ps1
```
Ensure the CSV file is correctly configured as the script may depend on it for user data.

## Features
- **User Creation**: Batch create users based on CSV file inputs.
- **User Update**: Modify existing user details.
- **User Removal**: Remove users from Azure AD.
- Additional functionalities as per the script's capabilities.

## License
[Specify the license here, if applicable]

## Contributing
Contributions to improve `ManageUser.ps1` are welcome. Please feel free to fork the repository, make your changes, and submit a pull request.

## Contact
For support or queries, please reach out to [Your Contact Information].
