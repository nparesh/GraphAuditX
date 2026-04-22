function Get-GraphAuditXToken {

    if ($script:GraphAuditXAuth.Token -and (Get-Date) -lt $script:GraphAuditXAuth.Expiry) {
        return $script:GraphAuditXAuth.Token
    }

    $uri = "https://login.microsoftonline.com/$($script:GraphAuditXAuth.TenantId)/oauth2/v2.0/token"

    $body = @{
        client_id     = $script:GraphAuditXAuth.ClientId
        scope         = "https://graph.microsoft.com/.default"
        client_secret = $script:GraphAuditXAuth.ClientSecret
        grant_type    = "client_credentials"
    }

    $response = Invoke-RestMethod -Method POST -Uri $uri -Body $body -ContentType "application/x-www-form-urlencoded"

    $script:GraphAuditXAuth.Token  = $response.access_token
    $script:GraphAuditXAuth.Expiry = (Get-Date).AddSeconds($response.expires_in - 300)

    return $response.access_token
}