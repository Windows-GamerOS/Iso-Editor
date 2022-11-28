# Created by Txmmy
# GamerOS ISO Editor (WIP)
# Use Example #
# Remove Use: "Function", 
# Enabled Use: #"Function",

$tweaks = @(
### Require Administrator ###
"RequireAdmin",
"CustomWindow",

### File Structure ###
"SetupFileStructure",
"Windows10MediaTool",

### Dism Prepare ISO ###
"AskUserIsoExtract",
"RemoveWindowsImages",
"PrepareWindowsImage",
"OptimizeFileStruct",
"CreateAutoUnattend",
"MountWindowsImage",

### Dism Reduce ISO ###
"RemoveWinAppxPkgs",
"RemoveCapability",
"RemoveFeatures",

### Dism Create ISO ###
"UnMountWindowsImage",
"ReCompressMadeIso",

### Auxiliary Functions ###
"WaitForKey",
"Restart"
)

##########
# Require Administrator
##########

# Relaunch the Script with Administrator Privileges.
Function RequireAdmin {
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
Exit
cls
}
}

# Launch the Script with A Custom Windows Size.
Function CustomWindow {
powershell -command "[console]::windowwidth=75; [console]::windowheight=25; [console]::bufferwidth=[console]::windowwidth"
}

##########
# File Structure
##########

Function SetupFileStructure {
If (!(Test-Path 'C:\ISO_Editor\')) {
New-Item -Path 'C:\ISO_Editor\' -ItemType Directory | Out-Null
}
If (!(Test-Path 'C:\ISO_Editor\WindowsImage\')) {
New-Item -Path 'C:\ISO_Editor\WindowsImage\' -ItemType Directory | Out-Null
}
If (!(Test-Path 'C:\ISO_Editor\MountPoint\')) {
New-Item -Path 'C:\ISO_Editor\MountPoint\' -ItemType Directory | Out-Null
}
}

Function Windows10MediaTool {
# Source file location
$source = 'https://go.microsoft.com/fwlink/?LinkId=691209'

# Destination to save the file
$destination = 'C:\ISO_Editor\Win10MediaCreationTool.exe'

# Download the source file and save it to destination
Invoke-WebRequest -Uri $source -OutFile $destination
}

##########
# Dism Prepare ISO
##########

Function AskUserIsoExtract {
	
do
 {
cls
Write-Host "                                                                           " -ForegroundColor DarkCyan
Write-Host "                                                                           " -ForegroundColor DarkCyan
Write-Host "       ██████╗  █████╗ ███╗   ███╗███████╗██████╗  ██████╗ ███████╗        " -ForegroundColor DarkCyan
Write-Host "      ██╔════╝ ██╔══██╗████╗ ████║██╔════╝██╔══██╗██╔═══██╗██╔════╝        " -ForegroundColor DarkCyan
Write-Host "      ██║  ███╗███████║██╔████╔██║█████╗  ██████╔╝██║   ██║███████╗        " -ForegroundColor DarkCyan
Write-Host "      ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  ██╔══██╗██║   ██║╚════██║        " -ForegroundColor DarkCyan
Write-Host "      ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗██║  ██║╚██████╔╝███████║        " -ForegroundColor DarkCyan
Write-Host "       ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝        " -ForegroundColor DarkCyan
Write-Host "  ██╗███████╗ ██████╗       ███████╗██████╗ ██╗████████╗ ██████╗ ██████╗   " -ForegroundColor DarkCyan
Write-Host "  ██║██╔════╝██╔═══██╗      ██╔════╝██╔══██╗██║╚══██╔══╝██╔═══██╗██╔══██╗  " -ForegroundColor DarkCyan
Write-Host "  ██║███████╗██║   ██║█████╗█████╗  ██║  ██║██║   ██║   ██║   ██║██████╔╝  " -ForegroundColor DarkCyan
Write-Host "  ██║╚════██║██║   ██║╚════╝██╔══╝  ██║  ██║██║   ██║   ██║   ██║██╔══██╗  " -ForegroundColor DarkCyan
Write-Host "  ██║███████║╚██████╔╝      ███████╗██████╔╝██║   ██║   ╚██████╔╝██║  ██║  " -ForegroundColor DarkCyan
Write-Host "  ╚═╝╚══════╝ ╚═════╝       ╚══════╝╚═════╝ ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝  " -ForegroundColor DarkCyan
Write-Host "                                                                           " -ForegroundColor DarkCyan
Write-Host "                                                                           " -ForegroundColor DarkCyan
Write-Host "Have You Used The Win Media Tool To Download The Windows Iso??" -ForegroundColor White
Write-Host "Extracted The Iso Contents To C:\ISO_Editor\WindowsImage\??" -ForegroundColor White
Write-Host "Warning: If Iso Found Optimization Will Be Done" -ForegroundColor Green
Write-Host "Warning: If No Iso Found Nothing Will Be Done" -ForegroundColor Red
Write-Host "=============================================" -ForegroundColor White
Write-Host "Y: Press 'Y' to Cont" -ForegroundColor Green
Write-Host "N: Press 'N' to Exit" -ForegroundColor Red
$selection = Read-Host "Make a Selection"
switch ($selection)
{
'y' { 
Cls
Write-Host "Running Iso Optimization" -ForegroundColor Cyan
}
'n' {
Write-Host "Skipping Iso Optimization" -ForegroundColor Cyan
Write-Host "Nothing Done... Exiting" -ForegroundColor Cyan
Start-Sleep 5
Exit
}
}
}
until ($selection -match "y" -or $selection -match "n")
}

Function RemoveWindowsImages {
Write-Host "Preparing Windows Iso Image For Editing" -ForegroundColor Cyan
#Get-WindowsImage -ImagePath "C:\ISO_Editor\WindowsImage\Sources\Install.esd"
$errpref = $ErrorActionPreference
$ErrorActionPreference = "silentlycontinue" #restore previous preference #save actual preference
Remove-WindowsImage -ImagePath "C:\ISO_Editor\WindowsImage\Sources\Install.esd" -Name "Windows 10 Home" -CheckIntegrity | Out-Null
Remove-WindowsImage -ImagePath "C:\ISO_Editor\WindowsImage\Sources\Install.esd" -Name "Windows 10 Home N" -CheckIntegrity | Out-Null
Remove-WindowsImage -ImagePath "C:\ISO_Editor\WindowsImage\Sources\Install.esd" -Name "Windows 10 Home Single Language" -CheckIntegrity | Out-Null
Remove-WindowsImage -ImagePath "C:\ISO_Editor\WindowsImage\Sources\Install.esd" -Name "Windows 10 Education" -CheckIntegrity | Out-Null
Remove-WindowsImage -ImagePath "C:\ISO_Editor\WindowsImage\Sources\Install.esd" -Name "Windows 10 Education N" -CheckIntegrity | Out-Null
#Remove-WindowsImage -ImagePath "C:\ISO_Editor\WindowsImage\Sources\Install.esd" -Name "Windows 10 Pro" -CheckIntegrity | Out-Null
Remove-WindowsImage -ImagePath "C:\ISO_Editor\WindowsImage\Sources\Install.esd" -Name "Windows 10 Pro N" -CheckIntegrity | Out-Null
$ErrorActionPreference = $errpref
}

Function PrepareWindowsImage {
Write-Host "Converting Iso Image Esd to Wim" -ForegroundColor Cyan
$errpref = $ErrorActionPreference
$ErrorActionPreference = "silentlycontinue" #restore previous preference #save actual preference
Dism /Export-Image /SourceImageFile:"C:\ISO_Editor\WindowsImage\Sources\install.esd" /SourceIndex:1 /DestinationImageFile:"C:\ISO_Editor\WindowsImage\Sources\install.wim" /Compress:maximum /CheckIntegrity
$ErrorActionPreference = $errpref
}

Function OptimizeFileStruct {
Write-Host "Optimizing Iso File Structure" -ForegroundColor Cyan
$errpref = $ErrorActionPreference
$ErrorActionPreference = "silentlycontinue" #restore previous preference #save actual preference
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\dlmanifests" -Recurse
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\en-us" -Recurse
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\etwproviders" -Recurse
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\inf" -Recurse
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\migration" -Recurse
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\replacementmanifests" -Recurse
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sxs" -Recurse
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\uup" -Recurse
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\vista" -Recurse
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\xp" -Recurse
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\acmigration.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\acres.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\actionqueue.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\adfscomp.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\admtv3check.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\aeinv.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\alert.gif"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appcompat.xsl"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appcompatservicing.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appcompat_bidi.xsl"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appcompat_detailed.xsl"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appcompat_detailed_bidi.xsl"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appcompat_detailed_bidi_txt.xsl"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appcompat_detailed_txt.xsl"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appraiser.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appraiser.sdb"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appraiserdatasha1.cat"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appraiserres.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appraiserwc.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\arunimg.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\arunres.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\autorun.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\background_cli.bmp"
#Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\boot.wim"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\cdplib.mof"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\cdplibuninstall.mof"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\clustercompliance.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\cmi2migxml.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\cmisetup.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\compatctrl.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\compatresources.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\compres.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\cryptosetup.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\csiagent.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\cversion.ini"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\db_msftproductionwindowssigningca.cer"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\devinv.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\diager.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\diagnostic.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\diagtrack.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\diagtrackrunner.exe"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\dism.exe"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\dismapi.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\dismcore.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\dismcoreps.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\dismprov.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\du.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\facilitator.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\folderprovider.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\gatherosstate.exe"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\generaltel.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\hwcompat.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\hwcompat.txt"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\hwcompatPE.txt"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\hwexclude.txt"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\hwexcludePE.txt"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\hypervcomplcheck.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\iasmigplugin.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\idwbinfo.txt"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\iiscomp.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\imagingprovider.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\input.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\install.esd"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\itgtupg.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\lang.ini"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\locale.nls"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\logprovider.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\mediasetupuimgr.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\migapp.xml"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\migcore.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\mighost.exe"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\migisol.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\migres.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\migstore.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\migsys.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\migtestplugin.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\mitigation.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\mxeagent.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\nlsbres.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\ntdsupg.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\ntfrsupg.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\nxquery.inf"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\nxquery.sys"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\offline.xml"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\offlineprofileutils.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\oscomps.woa.xml"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\oscomps.xml"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\osfilter.inf"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\outofbox_windows_db.bin"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\pnpibs.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\pnppropmig.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\product.ini"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\rdsupgcheck.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\reagent.admx"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\reagent.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\reagent.xml"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\reportgen.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\reservemanager.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\rmsupg.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\rollback.exe"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\schema.dat"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sdbapiu.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\segoeui.ttf"
#Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setup.exe"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setupcompat.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setupcore.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setupdiag.exe"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\SetupDU_159931.spdx.json"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\SetupDU_159931.spdx.json.sha256"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setuperror.exe"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setuphost.exe"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setupmgr.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setupplatform.cfg"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setupplatform.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setupplatform.exe"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setupprep.exe"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sfcn.dat"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflcid.dat"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflistrs1.dat"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflistw7.dat"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflistw8.dat"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflistw8.woa.dat"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflistwb.dat"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflistwb.woa.dat"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflistwt.dat"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflistwt.woa.dat"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sfpat.inf"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sfpatrs1.inf"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sfpatw7.inf"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sfpatw8.inf"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sfpatwb.inf"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sfpatwt.inf"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\smiengine.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\spflvrnt.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\spprgrss.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\spwizeng.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\spwizimg.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\spwizres.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sqmapi.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\uddicomp.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\unattend.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\unbcl.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\uninstall.xml"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\uninstall_data.xml"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\updateagent.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\upgloader.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\upgradeagent.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\upgradeagent.xml"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\upgrade_bulk.xml"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\upgrade_comp.xml"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\upgrade_data.xml"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\upgrade_frmwrk.xml"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\upgwow_bulk.xml"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\uxlib.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\uxlibres.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\vhdprovider.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\w32uiimg.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\w32uires.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\warning.gif"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdsclient.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdsclientapi.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdscore.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdscsl.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdsimage.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdstptc.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdsupgcompl.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdsutil.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wicadevicefilters.xml"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wimprovider.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\win32ui.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\windlp.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\winsetup.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\winsetupboot.hiv"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\winsetupboot.sys"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wpx.dll"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\ws.dat"
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Support" -Recurse -Force -Confirm:$false
$ErrorActionPreference = $errpref
}

Function MountWindowsImage {
Write-Host "Mounting Windows Iso" -ForegroundColor Cyan
Dism /Mount-Image /ImageFile:C:\ISO_Editor\WindowsImage\Sources\Install.wim /Index:1  /MountDir:C:\ISO_Editor\MountPoint\
}

##########
# Dism Reduce ISO
##########

Function RemoveWinAppxPkgs {
Write-Host "Removing Win Appx Pkgs" -ForegroundColor Cyan
#Dism /Image:C:\ISO_Editor\MountPoint\ /Get-ProvisionedAppxPackages
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:
$errpref = $ErrorActionPreference
$ErrorActionPreference = "silentlycontinue" #restore previous preference #save actual preference
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.549981C3F5F10_1.1911.21713.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.BingWeather_4.25.20211.0_neutral_~_8wekyb3d8bbwe | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.DesktopAppInstaller_2019.125.2243.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.GetHelp_10.1706.13331.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Getstarted_8.2.22942.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.HEIFImageExtension_1.0.22742.0_x64__8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Microsoft3DViewer_6.1908.2042.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftOfficeHub_18.1903.1152.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftSolitaireCollection_4.4.8204.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftStickyNotes_3.6.73.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MixedReality.Portal_2000.19081.1301.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MSPaint_2019.729.2301.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Office.OneNote_16001.12026.20112.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.People_2019.305.632.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.ScreenSketch_2019.904.1644.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.SkypeApp_14.53.77.0_neutral_~_kzf8qxf38zg5c | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.StorePurchaseApp_11811.1001.1813.0_neutral_~_8wekyb3d8bbwe | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.VCLibs.140.00_14.0.27323.0_x64__8wekyb3d8bbwe | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.VP9VideoExtensions_1.0.22681.0_x64__8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Wallet_2.4.18324.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WebMediaExtensions_1.0.20875.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WebpImageExtension_1.0.22753.0_x64__8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Windows.Photos_2019.19071.12548.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsAlarms_2019.807.41.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsCalculator_2020.1906.55.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsCamera_2018.826.98.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:microsoft.windowscommunicationsapps_16005.11629.20316.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsFeedbackHub_2019.1111.2029.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsMaps_2019.716.2316.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsSoundRecorder_2019.716.2313.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsStore_11910.1002.513.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Xbox.TCUI_1.23.28002.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxApp_48.49.31001.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxGameOverlay_1.46.11001.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxGamingOverlay_2.34.28001.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxIdentityProvider_12.50.6001.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxSpeechToTextOverlay_1.17.29001.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.YourPhone_2019.430.2026.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.ZuneMusic_2019.19071.19011.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.ZuneVideo_2019.19071.19011.0_neutral_~_8wekyb3d8bbwe | Out-Null
$ErrorActionPreference = $errpref
}

Function RemoveCapability {
Write-Host "Removing Capabilities" -ForegroundColor Cyan
#DISM /image:C:\ISO_Editor\MountPoint\ /Get-Capabilities
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:
$errpref = $ErrorActionPreference
$ErrorActionPreference = "silentlycontinue" #restore previous preference #save actual preference
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Accessibility.Braille~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Analog.Holographic.Desktop~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:App.StepsRecorder~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:App.Support.QuickAssist~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:App.WirelessDisplay.Connect~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Browser.InternetExplorer~~~~0.0.11.0 | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:DirectX.Configuration.Database~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Hello.Face.18967~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Hello.Face.Migration.18967~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~af-ZA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ar-SA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~as-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~az-LATN-AZ~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ba-RU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~be-BY~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~bg-BG~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~bn-BD~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~bn-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~bs-LATN-BA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ca-ES~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~cs-CZ~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~cy-GB~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~da-DK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~de-CH~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~de-DE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~el-GR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~en-AU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~en-CA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~en-GB~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~en-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~en-US~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~es-ES~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~es-MX~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~es-US~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~et-EE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~eu-ES~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~fa-IR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~fi-FI~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~fil-PH~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~fr-BE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~fr-CA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~fr-CH~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~fr-FR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ga-IE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~gd-GB~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~gl-ES~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~gu-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ha-LATN-NG~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~haw-US~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~he-IL~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~hi-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~hr-HR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~hu-HU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~hy-AM~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~id-ID~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ig-NG~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~is-IS~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~it-IT~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ja-JP~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ka-GE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~kk-KZ~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~kl-GL~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~kn-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ko-KR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~kok-DEVA-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ky-KG~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~lb-LU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~lt-LT~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~lv-LV~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~mi-NZ~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~mk-MK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ml-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~mn-MN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~mr-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ms-BN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ms-MY~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~mt-MT~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~nb-NO~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ne-NP~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~nl-NL~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~nn-NO~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~nso-ZA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~or-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~pa-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~pl-PL~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ps-AF~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~pt-BR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~pt-PT~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~rm-CH~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ro-RO~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ru-RU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~rw-RW~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~sah-RU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~si-LK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~sk-SK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~sl-SI~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~sq-AL~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~sr-CYRL-RS~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~sr-LATN-RS~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~sv-SE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~sw-KE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ta-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~te-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~tg-CYRL-TJ~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~th-TH~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~tk-TM~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~tn-ZA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~tr-TR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~tt-RU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ug-CN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~uk-UA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~ur-PK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~uz-LATN-UZ~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~vi-VN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~wo-SN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~xh-ZA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~yo-NG~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~zh-CN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~zh-HK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~zh-TW~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~zu-ZA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Arab~~~und-ARAB~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Beng~~~und-BENG~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Cans~~~und-CANS~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Cher~~~und-CHER~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Deva~~~und-DEVA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Ethi~~~und-ETHI~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Gujr~~~und-GUJR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Guru~~~und-GURU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Hans~~~und-HANS~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Hant~~~und-HANT~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Hebr~~~und-HEBR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Jpan~~~und-JPAN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Khmr~~~und-KHMR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Knda~~~und-KNDA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Kore~~~und-KORE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Laoo~~~und-LAOO~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Mlym~~~und-MLYM~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Orya~~~und-ORYA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.PanEuropeanSupplementalFonts~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Sinh~~~und-SINH~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Syrc~~~und-SYRC~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Taml~~~und-TAML~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Telu~~~und-TELU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Fonts.Thai~~~und-THAI~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~af-ZA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~bs-LATN-BA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~ca-ES~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~cs-CZ~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~cy-GB~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~da-DK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~de-DE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~el-GR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~en-GB~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~en-US~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~es-ES~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~es-MX~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~eu-ES~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~fi-FI~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~fr-FR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~ga-IE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~gd-GB~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~gl-ES~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~hi-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~hr-HR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~id-ID~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~it-IT~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~ja-JP~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~ko-KR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~lb-LU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~mi-NZ~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~ms-BN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~ms-MY~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~nb-NO~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~nl-NL~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~nn-NO~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~nso-ZA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~pl-PL~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~pt-BR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~pt-PT~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~rm-CH~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~ro-RO~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~ru-RU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~rw-RW~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~sk-SK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~sl-SI~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~sq-AL~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~sr-CYRL-RS~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~sr-LATN-RS~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~sv-SE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~sw-KE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~tn-ZA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~tr-TR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~wo-SN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~xh-ZA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~zh-CN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~zh-HK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~zh-TW~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~zu-ZA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~ar-SA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~bg-BG~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~bs-LATN-BA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~cs-CZ~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~da-DK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~de-DE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~el-GR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~en-GB~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~en-US~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~es-ES~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~es-MX~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~fi-FI~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~fr-CA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~fr-FR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~hr-HR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~hu-HU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~it-IT~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~ja-JP~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~ko-KR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~nb-NO~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~nl-NL~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~pl-PL~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~pt-BR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~pt-PT~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~ro-RO~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~ru-RU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~sk-SK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~sl-SI~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~sr-CYRL-RS~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~sr-LATN-RS~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~sv-SE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~tr-TR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~zh-CN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~zh-HK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~zh-TW~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~da-DK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~de-DE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~en-AU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~en-CA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~en-GB~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~en-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~en-US~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~es-ES~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~es-MX~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~fr-CA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~fr-FR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~it-IT~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~ja-JP~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~pt-BR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~zh-CN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~zh-HK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~zh-TW~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~ar-EG~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~ar-SA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~bg-BG~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~ca-ES~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~cs-CZ~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~da-DK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~de-AT~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~de-CH~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~de-DE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~el-GR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~en-AU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~en-CA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~en-GB~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~en-IE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~en-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~en-US~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~es-ES~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~es-MX~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~fi-FI~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~fr-CA~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~fr-CH~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~fr-FR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~he-IL~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~hi-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~hr-HR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~hu-HU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~id-ID~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~it-IT~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~ja-JP~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~ko-KR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~ms-MY~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~nb-NO~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~nl-BE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~nl-NL~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~pl-PL~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~pt-BR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~pt-PT~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~ro-RO~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~ru-RU~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~sk-SK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~sl-SI~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~sv-SE~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~ta-IN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~th-TH~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~tr-TR~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~vi-VN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~zh-CN~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~zh-HK~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~zh-TW~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:MathRecognizer~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Media.WindowsMediaPlayer~~~~0.0.12.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Onecore.StorageManagement~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.WebDriver~~~~0.0.1.0 | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.MSPaint~~~~0.0.1.0 | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Notepad~~~~0.0.1.0 | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.StorageManagement~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.WordPad~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Msix.PackagingTool.Driver~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:NetFX3~~~~ | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Network.Irda~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:OneCoreUAP.OneSync~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:OpenSSH.Client~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:OpenSSH.Server~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Print.Fax.Scan~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Print.Management.Console~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:RasCMAK.Client~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:RIP.Listener~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.CertificateServices.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.DHCP.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.Dns.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.FileServices.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.IPAM.Client.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.LLDP.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.NetworkController.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.ServerManager.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.Shielded.VM.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.StorageReplica.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.SystemInsights.Management.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.VolumeActivation.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.WSUS.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:SNMP.Client~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Tools.DeveloperMode.Core~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Tools.Graphics.DirectX~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Windows.Client.ShellComponents~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Windows.Desktop.EMS-SAC.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:WMI-SNMP-Provider.Client~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:XPS.Viewer~~~~0.0.1.0 | Out-Null
$ErrorActionPreference = $errpref
}

Function RemoveFeatures {
Write-Host "Removing Features" -ForegroundColor Cyan
#Dism /Image:C:\ISO_Editor\MountPoint\ /Get-Features
#Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:
$errpref = $ErrorActionPreference
$ErrorActionPreference = "silentlycontinue" #restore previous preference #save actual preference
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:TFTP | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:LegacyComponents | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:DirectPlay | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SimpleTCP | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Windows-Identity-Foundation | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:NetFx3 | Out-Null with Payload Removed
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-HTTP-Activation | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-NonHTTP-Activation | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WebServerRole | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WebServer | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-CommonHttpFeatures | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpErrors | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpRedirect | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ApplicationDevelopment | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-Security | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-RequestFiltering | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-NetFxExtensibility | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-NetFxExtensibility45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HealthAndDiagnostics | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpLogging | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-LoggingLibraries | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-RequestMonitor | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpTracing | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-URLAuthorization | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-IPSecurity | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-Performance | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpCompressionDynamic | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WebServerManagementTools | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ManagementScriptingTools | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-IIS6ManagementCompatibility | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-Metabase | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WAS-WindowsActivationService | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WAS-ProcessModel | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WAS-NetFxEnvironment | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WAS-ConfigurationAPI | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HostableWebCore | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-Services45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-HTTP-Activation45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-TCP-Activation45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-Pipe-Activation45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-MSMQ-Activation45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-TCP-PortSharing45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-StaticContent | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-DefaultDocument | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-DirectoryBrowsing | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WebDAV | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WebSockets | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ApplicationInit | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ASPNET | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ASPNET45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ASP | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-CGI | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ISAPIExtensions | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ISAPIFilter | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ServerSideIncludes | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-CustomLogging | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-BasicAuthentication | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpCompressionStatic | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ManagementConsole | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ManagementService | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WMICompatibility | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-LegacyScripts | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-LegacySnapIn | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-FTPServer | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-FTPSvc | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-FTPExtensibility | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-Container | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-DCOMProxy | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-Server | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-ADIntegration | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-HTTP | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-Multicast | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-Triggers | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-CertProvider | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WindowsAuthentication | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-DigestAuthentication | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ClientCertificateMappingAuthentication | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-IISCertificateMappingAuthentication | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ODBCLogging | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MediaPlayback | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WindowsMediaPlayer | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:DataCenterBridging | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SmbDirect | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:AppServerClient | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-PrintToPDFServices-Features | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Windows-Defender-Default-Definitions | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-XPSServices-Features | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SearchEngine-Client-Package | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSRDC-Infrastructure | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:TelnetClient | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:TIFFIFilter | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WorkFolders-Client | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-Foundation-Features | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-Foundation-InternetPrinting-Client | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-Foundation-LPDPrintService | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-Foundation-LPRPortMonitor | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MicrosoftWindowsPowerShellV2Root | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MicrosoftWindowsPowerShellV2 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:HypervisorPlatform | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:VirtualMachinePlatform | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-ProjFS | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Containers-DisposableClientVM | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-All | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-Tools-All | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-Management-PowerShell | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-Hypervisor | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-Services | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-Management-Clients | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:HostGuardian | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-DeviceLockdown | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-EmbeddedShellLauncher | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-EmbeddedBootExp | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-EmbeddedLogon | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-KeyboardFilter | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-UnifiedWriteFilter | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:DirectoryServices-ADAM-Client | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Windows-Defender-ApplicationGuard | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:NetFx4-AdvSrvs | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:NetFx4Extended-ASPNET45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:ServicesForNFS-ClientOnly | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:ClientForNFS-Infrastructure | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:NFS-Administration | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Containers | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SMB1Protocol | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SMB1Protocol-Client | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SMB1Protocol-Server | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SMB1Protocol-Deprecation | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MultiPoint-Connector | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MultiPoint-Connector-Services | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MultiPoint-Tools | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Internet-Explorer-Optional-amd64 | Out-Null
$ErrorActionPreference = $errpref
}

Function CreateAutoUnattend {
Write-Host "Creating Auto Unattended File" -ForegroundColor Cyan
New-Item -Path "C:\ISO_Editor\WindowsImage\" -Name "autounattend.xml" -ItemType File -Value {<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
	<settings pass="oobeSystem">
		<component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<InputLocale>0409:00000409</InputLocale>
			<SystemLocale>en-US</SystemLocale>
			<UILanguage>en-US</UILanguage>
			<UILanguageFallback>en-US</UILanguageFallback>
			<UserLocale>en-US</UserLocale>
		</component>
		<component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<TimeZone>Eastern Standard Time</TimeZone>
			<AutoLogon>
				<Enabled>true</Enabled>
				<LogonCount>9999999</LogonCount>
				<Username>Administrator</Username>
				<Password>
					<PlainText>true</PlainText>
					<Value></Value>
				</Password>
			</AutoLogon>
			<OOBE>
				<HideEULAPage>true</HideEULAPage>
				<HideLocalAccountScreen>true</HideLocalAccountScreen>
				<HideOnlineAccountScreens>true</HideOnlineAccountScreens>
				<HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
				<NetworkLocation>Other</NetworkLocation>
				<ProtectYourPC>3</ProtectYourPC>
				<SkipMachineOOBE>true</SkipMachineOOBE>
				<SkipUserOOBE>true</SkipUserOOBE>
			</OOBE>
			<UserAccounts>
				<AdministratorPassword>
					<PlainText>true</PlainText>
					<Value></Value>
				</AdministratorPassword>
				<LocalAccounts>
					<LocalAccount wcm:action="add">
						<DisplayName>User</DisplayName>
						<Group>Administrators</Group>
						<Name>Administrator</Name>
						<Password>
							<PlainText>true</PlainText>
							<Value></Value>
						</Password>
					</LocalAccount>
				</LocalAccounts>
			</UserAccounts>
		</component>
	</settings>
	<settings pass="specialize">
		<component name="Microsoft-Windows-Deployment" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<RunSynchronous>
				<RunSynchronousCommand wcm:action="add">
					<Order>2</Order>
					<Path>net user Administrator /fullname:"User"</Path>
					<WillReboot>Never</WillReboot>
				</RunSynchronousCommand>
				<RunSynchronousCommand wcm:action="add">
					<Order>1</Order>
					<Path>net user Administrator /active:Yes</Path>
					<WillReboot>Never</WillReboot>
				</RunSynchronousCommand>
			</RunSynchronous>
		</component>
		<component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<ComputerName>*</ComputerName>
		</component>
	</settings>
	<settings pass="windowsPE">
		<component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<InputLocale>0409:00000409</InputLocale>
			<SystemLocale>en-US</SystemLocale>
			<UILanguage>en-US</UILanguage>
			<UILanguageFallback>en-US</UILanguageFallback>
			<UserLocale>en-US</UserLocale>
		</component>
		<component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<Diagnostics>
				<OptIn>false</OptIn>
			</Diagnostics>
			<DynamicUpdate>
				<Enable>false</Enable>
				<WillShowUI>OnError</WillShowUI>
			</DynamicUpdate>
			<ImageInstall>
				<OSImage>
					<Compact>true</Compact>
					<WillShowUI>OnError</WillShowUI>
					<InstallFrom>
						<MetaData wcm:action="add">
							<Key>/IMAGE/INDEX</Key>
							<Value>1</Value>
						</MetaData>
					</InstallFrom>
				</OSImage>
			</ImageInstall>
			<UserData>
				<AcceptEula>true</AcceptEula>
				<FullName>GAMEROS</FullName>
				<ProductKey>
					<Key></Key>
				</ProductKey>
			</UserData>
		</component>
	</settings>
</unattend>
} | Out-Null
}

##########
# Dism Create ISO
##########

Function UnMountWindowsImage {
Write-Host "UnMounting Iso" -ForegroundColor Cyan
Dism /Unmount-Image /MountDir:C:\ISO_Editor\MountPoint\ /Commit
Rename-Item C:\ISO_Editor\WindowsImage\Sources\install.wim installorg.wim
}

Function ReCompressMadeIso {
Write-Host "Compress Wim" -ForegroundColor Cyan
dism /Export-Image /SourceImageFile:"C:\ISO_Editor\WindowsImage\Sources\installorg.wim" /SourceIndex:1 /DestinationImageFile:"C:\ISO_Editor\WindowsImage\Sources\install.wim" /compress:maximum
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\installorg.wim"
}

##########
# Auxiliary Functions
##########

# Wait for Key Press
Function WaitForKey {
Write-Host "Press Any Key to Continue..." -ForegroundColor White
[Console]::ReadKey($true) | Out-Null
}

# Restart Computer
Function Restart {
Write-Host "Exiting" -ForegroundColor Cyan
Start-Sleep 5
Exit
}

##########
# Parse Parameters and Apply Tweaks
##########

# Call the Desired Tweak Functions
$tweaks | ForEach { Invoke-Expression $_ }