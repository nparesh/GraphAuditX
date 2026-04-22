function GraphAuditX {
<#
.SYNOPSIS
Creates a Microsoft Purview audit query using Microsoft Graph

.VERSION
1.2

.SOURCE
https://github.com/nparesh/GraphAuditX-PowerShell-Module
#>

    param(
        [Parameter(Mandatory)]
        [datetime]$StartDate,

        [Parameter(Mandatory)]
        [datetime]$EndDate,

        [string]$Operations,
        [string]$UserIds,
        [string]$RecordType
    )

    # ===== CONNECTION VALIDATION =====
    try {
        $token = Get-GraphAuditXToken
        if (-not $token) { throw "No token" }
    }
    catch {
        throw "❌ Not connected. Run Connect-GraphAuditX first."
    }

    # ===== REQUEST =====
    $uri = "https://graph.microsoft.com/beta/security/auditLog/queries"

    $body = @{
        displayName = "GraphAuditX $(Get-Date -Format s)"
        filterStartDateTime = $StartDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
        filterEndDateTime   = $EndDate.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }

    if ($Operations) { $body.operationFilters = @($Operations) }
    if ($UserIds)    { $body.userPrincipalNameFilters = @($UserIds) }
    if ($RecordType) { $body.recordTypeFilters = @($RecordType) }

    $json = $body | ConvertTo-Json -Depth 5

    $response = Invoke-GraphAuditXRequest -Method POST -Uri $uri -Body $json

    if ($response -and $response.id) {
        Write-Host "✅ Query created" -ForegroundColor Green
        Write-Host "Query ID: $($response.id)" -ForegroundColor Cyan
        return $response.id
    }
    else {
        throw "❌ Failed to create audit query"
    }
}