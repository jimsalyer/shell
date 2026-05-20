function refreshenv {
    foreach ($scope in 'Machine','User') {
        [Environment]::GetEnvironmentVariables($scope).GetEnumerator() | ForEach-Object {
            if ($_.Name -ne 'Path') {
                Set-Item -Path "Env:$($_.Name)" -Value $_.Value
            }
        }
    }
    $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' +
                [Environment]::GetEnvironmentVariable('Path','User')
}
