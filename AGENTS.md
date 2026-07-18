# Agent instructions

Before adding or modifying anything under `bucket/`, read:

- `bucket/.README_BEFORE_ADDING_MANIFEST.md`

For GitHub API checks:

- Put the API endpoint in `checkver.url`.
- Let Scoop perform and authenticate the request.
- Use `checkver.script` only to parse `$page`.
- Do not call `Invoke-RestMethod`, `Invoke-WebRequest`, `curl`, `wget`, or another HTTP client against GitHub from a manifest script.

Run the repository test suite before committing.
