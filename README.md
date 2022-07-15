# tao-extension-ci-action
GitHub action executing a CI pipeline for TAO extensions

This action produces a TAO Extension name as an output.

## Inputs

> Specify using `with` keyword

### `php` (required)

a version of PHP to power the CI

### `coverage` (optional)

a boolean flag, controls whether a coverage report is needed

### `extension-name-config` (optional)

a composer package extra configuration field name to look up the TAO extension name

### `test-suites-path` (optional)

path to the extension's test suites

## Usage

This action expects to run on a git repo of a TAO extension.

The Action will take care of codebase checkout and PHP installation,
as well as of optionally generating and pushing coverage reports

```yaml
on:
  pull_request:
    branches: [ develop ]

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
          extension-name-config: tao-extension-name
          test-suites-path: test/unit

```

## Publishing

Actions are released as tags:
- one tag that reflects the exact version
- a major version tag that points to the last tag of that version

For example, when releasing the version `v1.2.3`, ensure the tag `v1` points to that version as well.
