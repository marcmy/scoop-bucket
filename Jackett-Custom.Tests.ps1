Describe 'Jackett custom artifact selection' {
    BeforeAll {
        $manifest = Get-Content "$PSScriptRoot\bucket\jackett-custom.json" -Raw | ConvertFrom-Json
        $checkScript = [scriptblock]::Create(@($manifest.checkver.script) -join "`n")

        function New-JackettArtifact {
            param([long]$RunId, [string]$CreatedAt, [string]$Commit)
            [pscustomobject]@{
                name = "Jackett-Custom_Windows-x86-$Commit"
                created_at = $CreatedAt
                expired = $false
                workflow_run = [pscustomobject]@{
                    id = $RunId
                    head_repository_id = 1366580145
                    head_branch = 'master'
                }
            }
        }

        function Invoke-JackettArtifactCheck {
            param([object[]]$Artifacts)
            $page = @{ artifacts = $Artifacts } | ConvertTo-Json -Depth 5
            & $checkScript
        }
    }

    It 'keeps the newest build when an older build uploads afterward' {
        # Replay the two builds from the failed publication check.
        $newer = New-JackettArtifact 38503262748 '2026-10-14T02:54:50Z' '746902f601e8'
        $older = New-JackettArtifact 38503242487 '2026-10-14T02:55:11Z' '3afec5c2aa30'
        Invoke-JackettArtifactCheck @($older, $newer) |
            Should -Be '38503262748 Jackett-Custom_Windows-x86-746902f601e8'
    }

    It 'ignores newer pull request, foreign repository, and expired artifacts' {
        $valid = New-JackettArtifact 38503262748 '2026-10-14T02:54:50Z' '746902f601e8'
        $pullRequest = New-JackettArtifact 38503262749 '2026-10-14T02:55:00Z' 'aaaaaaaaaaaa'
        $pullRequest.workflow_run.head_branch = 'codex/test'
        $foreign = New-JackettArtifact 38503262750 '2026-10-14T02:55:01Z' 'bbbbbbbbbbbb'
        $foreign.workflow_run.head_repository_id = 1
        $expired = New-JackettArtifact 38503262751 '2026-10-14T02:55:02Z' 'cccccccccccc'
        $expired.expired = $true
        Invoke-JackettArtifactCheck @($valid, $pullRequest, $foreign, $expired) |
            Should -Be '38503262748 Jackett-Custom_Windows-x86-746902f601e8'
    }

    It 'fails when no usable master artifact exists' {
        { Invoke-JackettArtifactCheck @() } | Should -Throw '*No matching non-expired*'
    }
}
