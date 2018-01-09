# https://go.microsoft.com/fwlink/?LinkId=708343&clcid=0x409

Function Get-RedirectedUrl
{
    Param (
        [Parameter(Mandatory=$true)]
        [String]$URL
    )
 
    $request = [System.Net.WebRequest]::Create($url)
    $request.AllowAutoRedirect=$false
    $response=$request.GetResponse()
 
    If ($response.StatusCode -eq "Found")
    {
        $response.GetResponseHeader("Location")
    }
}

$url = 'https://go.microsoft.com/fwlink/?LinkId=708343&clcid=0x409'
$codeSetupUrl = Get-RedirectedUrl -URL $url

$infPath = $PSScriptRoot + "\storageexp.inf"
$storageExpSetup = "${env:Temp}\StorageExplorer.exe"

try
{
    (New-Object System.Net.WebClient).DownloadFile($codeSetupUrl, $storageExpSetup)
}
catch
{
    Write-Error "Failed to download Azure Storage Explorer Setup"
}

try
{
    Start-Process -FilePath $storageExpSetup -ArgumentList "/VERYSILENT /MERGETASKS=!runcode /LOADINF=$infPath"
}
catch
{
    Write-Error 'Failed to install Storage Explorer'
}