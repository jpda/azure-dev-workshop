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

$url = 'https://go.microsoft.com/fwlink/?linkid=865305&clcid=0x409'
$codeSetupUrl = Get-RedirectedUrl -URL $url

$infPath = $PSScriptRoot + "\storageexp.inf"
$sqlOpsSetup = "${env:Temp}\SqlOps.exe"

try
{
    (New-Object System.Net.WebClient).DownloadFile($codeSetupUrl, $sqlOpsSetup)
}
catch
{
    Write-Error "Failed to download SQL Operations Setup"
}

try
{
    Start-Process -FilePath $sqlOpsSetup -ArgumentList "/VERYSILENT /MERGETASKS=!runcode /LOADINF=$infPath"
}
catch
{
    Write-Error 'Failed to install SQL Operations Studio'
}