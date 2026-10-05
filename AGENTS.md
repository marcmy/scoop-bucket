# Agent instructions

Before adding or modifying anything under `bucket/`, read:

- `bucket/.README_BEFORE_ADDING_MANIFEST.md`

For GitHub API checks:

- Use `checkver.github` for `api.github.com/repos/...` endpoints. Plain
  `checkver.url` does not automatically enter Scoop's authenticated GitHub
  checkver path.
- Use `checkver.script` only to parse the authenticated `$page` response
  whenever practical.
- If a raw-response regex must be preserved, add `"script": "$page"` so
  GitHub mode does not apply its default `$.tag_name` JSONPath.
- Do not call `Invoke-RestMethod`, `Invoke-WebRequest`, `curl`, `wget`, or
  another HTTP client against GitHub from a manifest script unless the request
  genuinely cannot be expressed through `checkver.github`.
- If a custom GitHub HTTP request is unavoidable, use `Get-GitHubToken` and add
  Authorization only when a token is available.

Run the repository test suite before committing.
