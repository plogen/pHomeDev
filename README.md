# pHomeDev

Personal development environment configuration and setup scripts.

## Tools

### GitHub CLI (`gh`)

Installed via [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/):

```powershell
winget install --id GitHub.cli --silent --accept-source-agreements --accept-package-agreements
```

Authenticate after install:

```powershell
gh auth login
```

Or with an existing token:

```powershell
"<your-token>" | gh auth login --with-token
```

Official docs: https://cli.github.com/manual/
