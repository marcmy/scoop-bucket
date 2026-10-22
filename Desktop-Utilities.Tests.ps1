Describe 'RTX Video Tuner source snapshot selection' {
    BeforeAll {
        $manifest = Get-Content "$PSScriptRoot/bucket/rtx-video-tuner.json" -Raw | ConvertFrom-Json
        $checkScript = [scriptblock]::Create(@($manifest.checkver.script) -join "`n")
    }
    It 'uses the immutable SHA and normalizes the timestamp to UTC' {
        $page = '{"sha":"0123456789012345678901234567890123456789","commit":{"committer":{"date":"2026-10-14T17:18:45-04:00"}}}'
        & $checkScript | Should -Be '20261014.211845 0123456789012345678901234567890123456789'
    }
    It 'rejects a missing or malformed commit identity' {
        $page = '{"sha":"main","commit":{"committer":{"date":"2026-10-14T21:18:45Z"}}}'
        { & $checkScript } | Should -Throw '*Invalid commit SHA*'
    }
}

Describe 'Resolution Toggle data survives package replacement' {
    BeforeAll {
        $manifest = Get-Content "$PSScriptRoot/bucket/resolution-toggle.json" -Raw | ConvertFrom-Json
        $backup = [scriptblock]::Create(@($manifest.uninstaller.script) -join "`n")
        $restore = [scriptblock]::Create(@($manifest.installer.script) -join "`n")
        $launcher = [scriptblock]::Create(@($manifest.pre_install) -join "`n")
    }
    It 'preserves the newest settings after an atomic file replacement' {
        $dir = Join-Path $TestDrive 'old-version'
        $persist_dir = Join-Path $TestDrive 'persist'
        New-Item $dir -ItemType Directory | Out-Null
        $settings = Join-Path $dir 'settings.json'
        Set-Content $settings '{"Custom":{"Width":1440}}'
        $temp = Join-Path $dir 'settings.tmp'
        Set-Content $temp '{"Custom":{"Width":1280}}'
        [System.IO.File]::Replace($temp, $settings, (Join-Path $dir 'settings.bak'))
        Set-Content (Join-Path $dir 'ResolutionToggle.log') 'saved log'
        & $backup

        $dir = Join-Path $TestDrive 'new-version'
        New-Item $dir -ItemType Directory | Out-Null
        & $restore
        (Get-Content (Join-Path $dir 'settings.json') -Raw | ConvertFrom-Json).Custom.Width | Should -Be 1280
        (Get-Content (Join-Path $dir 'ResolutionToggle.log') -Raw).Trim() | Should -Be 'saved log'
    }
    It 'allows first installation without existing settings' {
        $dir = Join-Path $TestDrive 'first-install'
        $persist_dir = Join-Path $TestDrive 'no-backup'
        New-Item $dir -ItemType Directory | Out-Null
        { & $restore } | Should -Not -Throw
        Test-Path (Join-Path $dir 'settings.json') | Should -BeFalse
        & $launcher
        $text = Get-Content (Join-Path $dir 'resolution-toggle.cmd') -Raw
        $text | Should -Match '-File "%~dp0Toggle-Resolution.ps1" %\*'
        $text | Should -Match '-WindowStyle Hidden'
    }
}
