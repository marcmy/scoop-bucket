# marcmy's scoop bucket
Just a little scoop (https://github.com/ScoopInstaller/Scoop) bucket I made to keep up with some projects as conveniently as possible.

[![Tests](https://github.com/marcmy/scoop-bucket/actions/workflows/ci.yml/badge.svg)](https://github.com/marcmy/scoop-bucket/actions/workflows/ci.yml) [![Excavator](https://github.com/marcmy/scoop-bucket/actions/workflows/excavator.yml/badge.svg)](https://github.com/marcmy/scoop-bucket/actions/workflows/excavator.yml)
## How to install these apps
```pwsh
scoop bucket add marcmy https://github.com/marcmy/scoop-bucket
scoop install marcmy/<appname>

e.g.
scoop install marcmy/quake3e
```

## Desktop utilities

| Package | Distribution |
| --- | --- |
| `cleartune` | Portable Windows x64 release ZIP |
| `dwmborderremover` | Windows 11 x64; extracts the Inno installer without running it |
| `rtx-video-tuner` | Dated, immutable source snapshots from `main`; the app requests elevation on launch |
| `micvolumeguard` | Tagged PowerShell sources; start with `micvolumeguard -TargetPercent 100` |
| `resolution-toggle` | Tagged v1.0.0 sources matching the published installer; configure with `resolution-toggle -Configure` |
| `book-resale-finder` | Portable Windows x64 release; preserves config, input CSV and output folder |
| `book-resale-calculator` | Portable Windows x64 EXE; currently an alpha release |

Installation does not launch these apps or change display/audio settings. MicVolumeGuard's
optional scheduled-task setup remains a separate manual action. Resolution Toggle backs
up settings and logs on updates/uninstalls instead of using file hard links, because its
atomic settings replacement would detach a hard link. `scoop uninstall -p` purges that backup.

ClearTune, RTX Video Tuner and Resolution Toggle publish MIT licenses. The other four
projects do not currently declare a source license, so their manifests use Scoop's
`Proprietary` classification to reflect the missing license declarations.

Resolution Toggle's `main` branch contains configuration recovery and display-switch
verification changes that have not been released yet. Its package follows the latest
release and will update when a new release is published.
