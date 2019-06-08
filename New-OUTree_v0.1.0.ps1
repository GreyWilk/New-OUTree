function New-OUTree
{

param(
    [Parameter(Mandatory=$true)]$Domain,
    [Parameter(Mandatory=$true)]$OUNames
    )
## Check if AD module is installed
if (Get-Module -ListAvailable -Name ActiveDirectory) { Write-Host -ForegroundColor Green "ActiveDirectory module exists" } else { Write-Warning "ActiveDirectory module does not exist. Exiting."; break }

## Validate domain name
if( !($Domain -match "(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$)") -eq $true) { Write-Warning "Domain name not acceptable."; break }

## Change $Domain string to "DC=subdomain,DC=domain,DC=suffix" (formatting)
$DomainRootString = $null
$DomainRootStringFinal = $null
$DomainSplit = $Domain.Split('.')
$DomainSplit | foreach { $DomainRootString += "DC=$_" }
$DomainRootStringFinal = ($DomainRootString.Replace("DC=",",DC=")).substring(1)

try{ cd AD:\$DomainRootStringFinal -ErrorAction Stop }
catch{ Write-Warning "Unable to connect to $Domain ($DomainRootStringFinal) with AD PSDrive. Check domain name.  Exiting"; break }

foreach($OUName in $OUNames){

    Write-Host -ForegroundColor Cyan "  Creating OU: $OUName"
    mkdir ( '.\OU=' + $OUName ) | Out-Null
    Start-Sleep -m 500
    cd ( '.\OU=' + $OUName )  | Out-Null

    }

cd C:\
}

New-OUTree -Domain one.mydomain.local -OUNames OUOne,OUTwo,OUThree


