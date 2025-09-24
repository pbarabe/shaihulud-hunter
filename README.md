# Shai-Hulud Hunter #

## About ##

Uses [jq](https://jqlang.org/) to parse the [JSON file](./affected-packages.json) and then recursively `grep` each package name in the parent directory.

The `affected-packages.json` file was created from the list of known, affected packages published by [reversinglabs.com](https://www.reversinglabs.com/blog/shai-hulud-worm-npm).

A [CSV version](./affected-packages.csv) of affected packages is also provided.


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

23 Sep 2025 - Initial creation
24 Sep 2025 - Refine logic to evaluate only package-lock.json, yarn.lock, and pnpm-lock.yaml files


## Additional Resources ##

- <https://www.cisa.gov/news-events/alerts/2025/09/23/widespread-supply-chain-compromise-impacting-npm-ecosystem>
- <https://unit42.paloaltonetworks.com/npm-supply-chain-attack/>
- <https://socket.dev/blog/ongoing-supply-chain-attack-targets-crowdstrike-npm-packages>
- <https://www.reversinglabs.com/blog/shai-hulud-worm-npm>

