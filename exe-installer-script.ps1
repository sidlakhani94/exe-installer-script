#Variables
$computername = Get-Content servers.txt
$username = "my_user"
$password = ConvertTo-SecureString "my_password" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)
$sourcefile = "D:\Powershell Scripts\npp.8.3.3.Installer.x64.exe"
#This section will install the software 
foreach ($computer in $computername) 
{
    $destinationFolder = "\\$computer\C$\Folder"
    #It will copy $sourcefile to the $destinationfolder. If the Folder does not exist it will create it.

    if (!(Test-Path -path "$destinationFolder\Folder-exe"))
    {
        New-PSDrive -Name "S" -Root "$destinationFolder" -PSProvider "FileSystem" -Credential $credential
        New-Item "$destinationFolder\Folder-exe" -Type Directory
    }
    Copy-Item -Path $sourcefile -Destination "$destinationFolder\Folder-exe" -Force
    Invoke-Command -ComputerName $computer -Credential $credential -ScriptBlock {Start-Process powershell -verb runas -ArgumentList 'C:\Folder\Folder-exe\npp.8.3.3.Installer.x64.exe', '/S','/v','/qn' -passthru -Wait}
   
}