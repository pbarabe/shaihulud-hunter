# Shai-Hulud Hunter #

## About ##

Searches for projects with dependencies that may have been compromised by:
- [Shai-Hulud](https://www.cisa.gov/news-events/alerts/2025/09/23/widespread-supply-chain-compromise-impacting-npm-ecosystem), and
- [Mini Shai-Hulud](https://snyk.io/blog/tanstack-npm-packages-compromised/).

Uses [jq](https://jqlang.org/) to parse [affected-packages.json](./affected-packages.json) and then recursively `grep` each package name in lock files found in the named directory.

The `affected-packages.json` file was created from the list of known, affected packages published by [socket.dev](https://socket.dev/):
- [Shai-Hulud](https://socket.dev/blog/ongoing-supply-chain-attack-targets-crowdstrike-npm-packages)
- [Mini Shai-Hulid](https://socket.dev/supply-chain-attacks/mini-shai-hulud)


## Prerequites ##

- `bash`
- `jq`


## Usage ##

```sh
# Scan a named directory with package names extracted from affected-packages.json
shaihulud-hunter.sh <directory> {affected-packages.json}

# Test scan on files in the ./test/ folder
shailulud-hunter.sh -t
```


## Modification log ##

23 Sep 2025
- Initial creation  

24 Sep 2025
- Refine logic to evaluate only package-lock.json, yarn.lock, and pnpm-lock.yaml files  
- Replace affected-packages.json contents with more up-to-date list grabbed from https://socket.dev/

12 May 2026
- Modified to also check for Mini Shai Hulud compromised packages


## Additional Resources ##

### Shai-Hulud ###
- <https://www.cisa.gov/news-events/alerts/2025/09/23/widespread-supply-chain-compromise-impacting-npm-ecosystem>
- <https://unit42.paloaltonetworks.com/npm-supply-chain-attack/>
- <https://socket.dev/blog/ongoing-supply-chain-attack-targets-crowdstrike-npm-packages>
- <https://www.reversinglabs.com/blog/shai-hulud-worm-npm>

### Mini Shai-Hulud ###
- <https://socket.dev/supply-chain-attacks/mini-shai-hulud>
- <https://www.stepsecurity.io/blog/mini-shai-hulud-is-back-a-self-spreading-supply-chain-attack-hits-the-npm-ecosystem>

