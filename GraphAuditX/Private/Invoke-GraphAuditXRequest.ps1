function Invoke-GraphAuditXRequest {

    param(
        [Parameter(Mandatory)]
        [ValidateSet("GET","POST")]
        [string]$Method,

        [Parameter(Mandatory)]
        [string]$Uri,

        [object]$Body
    )

    $token = Get-GraphAuditXToken

    $headers = @{
        Authorization = "Bearer $token"
    }

    try {
        if ($Body) {
            return Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers -Body $Body -ContentType "application/json"
        }
        else {
            return Invoke-RestMethod -Method $Method -Uri $Uri -Headers $headers
        }
    }
    catch {
        Write-Host "❌ Graph API error" -ForegroundColor Red

        if ($_.ErrorDetails.Message) {
            Write-Host $_.ErrorDetails.Message
        }
        else {
            $_
        }

        return $null
    }
}