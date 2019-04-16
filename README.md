# Concourse RubyGems Resource

A [Concourse CI](https://concourse-ci.org) resource for manipulating RubyGems.

## Resource Type Configuration

```yaml
resource_types:
- name: rubygem
  type: docker-image
  source:
    repository: troykinsella/concourse-rubygems-resource
    tag: latest
```

## Source Configuration

* `credentials`: Optional. The contents of the `~/.gem/credentials` file.
* `gem_name`: Required. The name of the RubyGem.
* `prerelease`: Optional. Default: `false`. `true` to include prerelease versions in checks and gets.
* `source_url`: Optional. The URL of the RubyGem host. Unless specified, 
  this resource operates on the default RubyGem host: `https://rubygems.org`.
* `apt_keys`: Optional. During `get`s, add this list of apt keys. Each entry is a URL at which the apt key can be fetched. 
* `apt_sources`: Optional. During `get`s, configure this list of apt sources. Each entry is a line in the `/etc/apt/sources.list` file.
* `deb_packages`: Optional. During `get`s, install this list of deb packages prior to installing the gem.
  Useful for when the gem requires native extensions.

### Example

```yaml
resources:
- name: gem
  type: rubygem
  source:
    source_url: https://artifactory.example.com/api/gems/gems-local
    gem_name: wickedizer
    credentials: |
      :rubygems_api_key: Basic fKtpr1kRTNBdn...V3aVdZTTlhFUmpTdno=
```

## Behaviour

### `check`: Check for new RubyGems

The latest version of the RubyGem is queried from the configured source.

### `in`: Install the RubyGem

Performs a `gem install` of the RubyGem name. 

### Parameters

* `install_options`: Optional. Additional command line arguments to pass to the
  `gem install` command. The following options are managed and should not be 
  supplied in repeat through this parameter:
  * `--install-dir`
  * `--[no-]prerelease`
  * `--remote`
  * `--source`
  * `--version`
* `skip_download`: Optional. Default: `false`. `true` to skip installing the RubyGem.

### Example

```yaml
jobs:
- name: gem-integration
  plan:
  - get: gem
  - task: integration test
    file: ...
```

### `out`: Push a RubyGem

Publishes a RubyGem file to a repository using `gem push`.

### Parameters

* `gem_dir`: Required. The directory in which the built RubyGem file is located.
* `gem_regex`: Optional. A RegEx that can match the RubyGem file name to publish.
* `key_name`: Optional. The name of the API key in `~/.gem/credentials` to use.

### Example

```yaml
jobs:
- name: install gem
  plan:
  - get: gem
    params:
      deb_packages:
      - whacky-dev
- name: publish-gem
  plan:
  - task: build gem
    file: ...
  - put: gem
    params:
      gem_dir: built-gem
    get_params:
      skip_download: true
```

## License

MIT © Troy Kinsella
