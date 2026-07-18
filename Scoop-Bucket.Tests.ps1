if (!$env:SCOOP_HOME) { $env:SCOOP_HOME = Resolve-Path (scoop prefix scoop) }
. "$env:SCOOP_HOME\test\Import-Bucket-Tests.ps1"

Describe 'Repository manifest policy' {
    It 'keeps GitHub API requests in checkver.url' {
        $violations = foreach ($file in Get-ChildItem "$PSScriptRoot\bucket\*.json") {
            $manifest = Get-Content $file.FullName -Raw | ConvertFrom-Json
            $scriptText = @($manifest.checkver.script) -join "`n"

            if ($scriptText -match 'api\.github\.com') {
                $file.Name
            }
        }

        $violations | Should -BeNullOrEmpty -Because 'GitHub API endpoints belong in checkver.url; checkver.script should only parse $page.'
    }
}
