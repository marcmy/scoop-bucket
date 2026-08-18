Describe 'qBittorrent custom associations' {
    It 'routes torrent and magnet opens through the stable Scoop shim' {
        $manifest = Get-Content "$PSScriptRoot\bucket\qbittorrent-custom.json" -Raw | ConvertFrom-Json
        $postInstall = @($manifest.post_install) -join "`n"

        $expectedReplacement = ".Replace('`$qbitlauncher', `$qbitLauncher).Replace('`$qbit', `$qbitPath)"
        $postInstall | Should -Match ([regex]::Escape($expectedReplacement))
        $postInstall | Should -Match 'shimdir\s+\$global'

        $template = Get-Content "$PSScriptRoot\scripts\qbittorrent-custom\install-associations.reg" -Raw
        $qbitPath = 'C:\Users\marcm\scoop\apps\qbittorrent-custom\current'.Replace('\', '\\')
        $launcherPath = 'C:\Users\marcm\scoop\shims\qbittorrent-custom.exe'.Replace('\', '\\')
        $expanded = $template.Replace('$qbitlauncher', $launcherPath).Replace('$qbit', $qbitPath)

        $expanded | Should -Not -Match '\$qbitlauncher'
        $expanded | Should -Not -Match '\$qbit'

        # Three shell-open commands exist: torrent ProgID, magnet ProgID, and
        # the direct magnet class. All three must invoke the stable shim.
        ([regex]::Matches($expanded, [regex]::Escape($launcherPath))).Count | Should -Be 3

        # The real qBittorrent executable remains only in the two DefaultIcon
        # entries. If an open command regresses to $dir, this count rises.
        $realExecutable = "$qbitPath\\qbittorrent.exe"
        ([regex]::Matches($expanded, [regex]::Escape($realExecutable))).Count | Should -Be 2
    }
}
