# Description: Boxstarter Script  
# Author: Laurent Kempé
# Dev settings for my app development

Disable-UAC

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
    iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

#--- Setting up Windows ---
executeScript "SystemConfiguration.ps1";
executeScript "FileExplorerSettings.ps1";
executeScript "RemoveDefaultApps.ps1";
executeScript "CommonDevTools.ps1";
executeScript "Browsers.ps1";
#executeScript "WindowsTools.ps1";

executeScript "HyperV.ps1";
RefreshEnv
executeScript "WSL.ps1";
RefreshEnv
executeScript "Docker.ps1";
executeScript "AzureDevops.ps1";

#--- Visual Studio ---
choco install visualstudio2019professional -y --package-parameters "--add Microsoft.VisualStudio.Component.Git" 
Update-SessionEnvironment #refreshing env due to Git install

choco install -y visualstudio2019-workload-manageddesktop
choco install -y visualstudio2019-workload-netcoretools
choco install -y visualstudio2019-workload-azure 
choco install -y visualstudio2019-workload-visualstudioextension 

#--- Visual Studio extensions ---
#choco install -y gitdiffmargin
#choco install -y resharper-ultimate-all --package-parameters="'/NoCpp'"

#--- Tools ---
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension msjsdiag.debugger-for-edge

#--- Tools ---
choco install -y nodejs-lts # Node.js LTS, Recommended for most users
# choco install -y nodejs # Node.js Current, Latest features
choco install visualstudio2019buildtools
choco install -y visualstudio2019-workload-vctools
choco install -y python2 # Node.js requires Python 2 to build native modules

#--- Configure Windows environment .gitconfig, PowerShell ---
executeScript "ConfigureWindowsEnvironment.ps1";

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
