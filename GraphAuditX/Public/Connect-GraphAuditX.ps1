function Connect-GraphAuditX {
    param(
        [Parameter(Mandatory)]
        [string]$TenantId,

        [Parameter(Mandatory)]
        [string]$ClientId,

        [Parameter(Mandatory)]
        [securestring]$ClientSecret
    )

    # Convert secure string safely (in-memory only)
    $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($ClientSecret)
    $plainSecret = [Runtime.InteropServices.Marshal]::PtrToStringAuto($ptr)

    # Store config in script scope
    $script:GraphAuditXAuth = @{
        TenantId     = $TenantId
        ClientId     = $ClientId
        ClientSecret = $plainSecret
        Token        = $null
        Expiry       = Get-Date
    }

    # Get initial token
    Get-GraphAuditXToken | Out-Null

    Write-Host "✅ Connected to Microsoft Graph" -ForegroundColor Green
}