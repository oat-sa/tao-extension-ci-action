# tao-extension-ci-action
GitHub action executing a CI pipeline for TAO extensions

This action produces a TAO Extension name as an output.

## Inputs

> Specify using `with` keyword

### `php` (required)

a version of PHP to power the CI

### `coverage` (optional)

a boolean flag, controls whether a coverage report is needed

### `test-suites-path` (optional)

path to the extension's test suites

## Usage

This action expects to run on a git repo of a TAO extension.

The Action will take care of codebase checkout and PHP installation,
as well as of optionally generating and pushing coverage reports.

Should your extension rely on any of the `oat-sa` organization's private repositories,
kindly make sure to specify [`COMPOSER_AUTH`](https://getcomposer.org/doc/03-cli.md#composer-auth) environment variable.

```yaml
on:
  push:
    branches: [ master, develop ]
  pull_request:
    branches: [ develop ]

env:
  COMPOSER_AUTH: '{"github-oauth":{"github.com":"${{ secrets.CI_GITHUB_TOKEN }}"}}'

jobs:
  ci:
    runs-on: ${{ matrix.operating-system }}

    strategy:
      matrix:
        operating-system: [ ubuntu-latest ]
        php-version: [ '7.2', '7.3', '7.4', '8.0', '8.1' ]
        include:
          - php-version: '7.2'
            coverage: true

    steps:
      - name: CI
        uses: oat-sa/tao-extension-ci-action@v1
        with:
          php: ${{ matrix.php-version }}
          coverage: ${{ matrix.coverage }}
          test-suites-path: test/unit

```

## Publishing

Actions are released as tags:
- one tag that reflects the exact version
- a major version tag that points to the last tag of that version

For example, when releasing the version `v1.2.3`, ensure the tag `v1` points to that version as well. 
Check the code example bellow:  

```shell
git fetch
git checkout main
git pull
git tag -d v1
git tag v1
git push origin :v1
git push origin v1
```
