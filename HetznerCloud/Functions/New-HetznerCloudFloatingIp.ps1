function New-HetznerCloudFloatingIp {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('IPv4', 'IPv6')]
        [string]
        $Type
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Server
        ,
        [Parameter(ParameterSetName='ByLocation')]
        [ValidateSet('fsn1', 'nbg1')]
        [string]
        $Location
        ,
        [Parameter(ParameterSetName='ByLocation')]
        [ValidateNotNullOrEmpty()]
        [string]
        $Description
    )
    
    begin {
        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }
    }

    process {
        $Payload = @{
            type = $Type.ToLower()
        }
        if ($PSBoundParameters.ContainsKey('Server')) {
            $Payload.Add('server', $Server)
        }
        if ($PSBoundParameters.ContainsKey('Location')) {
            $Payload.Add('home_location', $Location)
        }
        if ($PSBoundParameters.ContainsKey('Description')) {
            $Payload.Add('description', $Description)
        }

        if ($Force -or $PSCmdlet.ShouldProcess("Add new floating IP?")) {
            Invoke-HetznerCloudApi -Api 'floating_ips' -Method 'Post' -Payload $Payload
        }
    }
}