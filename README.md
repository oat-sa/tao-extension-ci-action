# tao-extension-ci-action
GitHub action executing a CI pipeline for TAO extensions

This action produces a TAO Extension name as an output.

## Inputs

> Specify using `with` keyword

### `extension-name-config` (optional)

a composer package extra configuration field name to look up the TAO extension name

### `test-suites-path` (optional)

path to the extension's test suites

## Usage

This action expects to run on a git repo of a TAO extension with `manifest` file available.
The Action context must also have `php` installed
To ensure it, you should run `actions/checkout` (or similar) and `shivammathur/setup-php` actions first:

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
        php-versions: [ '7.2', '7.3', '7.4', '8.0', '8.1' ]

    steps:
    - uses: actions/checkout@v3
    - uses: shivammathur/setup-php@v2
      with:
        php-version: ${{ matrix.php-versions }}
    - name: Fetch Extension name
      id: name
      uses: oat-sa/tao-extension-ci-action@v0
      with:
        extension-name-config: tao-extension-name
        test-suites-path: test/unit
```

## Publishing

Actions are released as tags:
- one tag that reflects the exact version
- a major version tag that points to the last tag of that version

For example, when releasing the version `v1.2.3`, ensure the tag `v1` points to that version as well.
