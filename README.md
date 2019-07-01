# Docker image for `goimports`

[![Build Status](https://travis-ci.com/cytopia/docker-goimports.svg?branch=master)](https://travis-ci.com/cytopia/docker-goimports)
[![Tag](https://img.shields.io/github/tag/cytopia/docker-goimports.svg)](https://github.com/cytopia/docker-goimports/releases)
[![](https://images.microbadger.com/badges/version/cytopia/goimports:latest.svg?&kill_cache=1)](https://microbadger.com/images/cytopia/goimports:latest "goimports")
[![](https://images.microbadger.com/badges/image/cytopia/goimports:latest.svg?&kill_cache=1)](https://microbadger.com/images/cytopia/goimports:latest "goimports")
[![](https://img.shields.io/badge/github-cytopia%2Fdocker--goimports-red.svg)](https://github.com/cytopia/docker-goimports "github.com/cytopia/docker-goimports")
[![License](https://img.shields.io/badge/license-MIT-%233DA639.svg)](https://opensource.org/licenses/MIT)

> #### All [#awesome-ci](https://github.com/topics/awesome-ci) Docker images
>
> [ansible](https://github.com/cytopia/docker-ansible) **•**
> [ansible-lint](https://github.com/cytopia/docker-ansible-lint) **•**
> [awesome-ci](https://github.com/cytopia/awesome-ci) **•**
> [black](https://github.com/cytopia/docker-black) **•**
> [checkmake](https://github.com/cytopia/docker-checkmake) **•**
> [eslint](https://github.com/cytopia/docker-eslint) **•**
> [file-lint](https://github.com/cytopia/docker-file-lint) **•**
> [gofmt](https://github.com/cytopia/docker-gofmt) **•**
> [goimports](https://github.com/cytopia/docker-goimports) **•**
> [golint](https://github.com/cytopia/docker-golint) **•**
> [jsonlint](https://github.com/cytopia/docker-jsonlint) **•**
> [phpcbf](https://github.com/cytopia/docker-phpcbf) **•**
> [phpcs](https://github.com/cytopia/docker-phpcs) **•**
> [php-cs-fixer](https://github.com/cytopia/docker-php-cs-fixer) **•**
> [pycodestyle](https://github.com/cytopia/docker-pycodestyle) **•**
> [pylint](https://github.com/cytopia/docker-pylint) **•**
> [terraform-docs](https://github.com/cytopia/docker-terraform-docs) **•**
> [terragrunt](https://github.com/cytopia/docker-terragrunt) **•**
> [yamllint](https://github.com/cytopia/docker-yamllint)


> #### All [#awesome-ci](https://github.com/topics/awesome-ci) Makefiles
>
> Visit **[cytopia/makefiles](https://github.com/cytopia/makefiles)** for seamless project integration, minimum required best-practice code linting and CI.

View **[Dockerfile](https://github.com/cytopia/docker-goimports/blob/master/Dockerfile)** on GitHub.

[![Docker hub](http://dockeri.co/image/cytopia/goimports?&kill_cache=1)](https://hub.docker.com/r/cytopia/goimports)

Tiny Alpine-based multistage-build dockerized version of [goimports](https://godoc.org/golang.org/x/tools/cmd/goimports)<sup>[1]</sup>,
which adds the **additional `--ci` argument<sup>[2]</sup>** via a shell wrapper to ensure to exit > 0 if file diffs occur.
The image is built nightly against multiple stable versions and pushed to Dockerhub.

* <sup>[1] Official project: https://godoc.org/golang.org/x/tools/cmd/goimports</sup>
* <sup>[2] See [Usage](#usage) for help</sup>


## Available Docker image versions

| Docker tag | Build from |
|------------|------------|
| `latest`   | Latest stable goimports version |


## Docker mounts

The working directory inside the Docker container is **`/data/`** and should be mounted locally to
the root of your project.


## Usage

### General

```bash
$ docker run --rm cytopia/goimports --help

Usage: cytopia/goimports [flags] [path...]
       cytopia/goimports [--ci] [-local] [-srcdir] [path...]
       cytopia/goimports --help

Dockerized version of goimports with an addition to fail (exit 1) in case of file changes.

Additional wrapper features:
----------------------------
 --ci   This option will print the diff to stdout (similar to '-d') and if a diff
        exists it will fail with exit 1.
        Can only be combined with '-e', '-local' and '-srcdir'.
        To be used in continuous integration with explicit failing.

Default goimports flages:
----------------------------
 -cpuprofile string
        CPU profile output
 -d     display diffs instead of rewriting files
 -e     report all errors (not just the first 10 on different lines)
 -format-only
        if true, don't fix imports and only format. In this mode, goimports is
        effectively goimports, with the addition that imports are grouped into sections.
 -l     list files whose formatting differs from goimport's
 -local string
        put imports beginning with this string after 3rd-party packages; comma-separated list
 -memprofile string
        memory profile output
 -memrate int
        if > 0, sets runtime.MemProfileRate
 -srcdir dir
        choose imports as if source code is from dir. When operating on a single file,
        dir may instead be the complete file name.
 -trace string
        trace profile output
 -v     verbose logging
 -w     write result to (source) file instead of stdout
```

### Default goimports usage
```bash
# Print diff to stdout and exit 0
$ docker run --rm -v $(pwd):/data cytopia/goimports -d .
```

### CI wrapper usage
```bash
# Print diff to stdout and exit > 0 if diff occurs
$ docker run --rm -v $(pwd):/data cytopia/goimports --ci .
```


## Related [#awesome-ci](https://github.com/topics/awesome-ci) projects

### Docker images

Save yourself from installing lot's of dependencies and pick a dockerized version of your favourite
linter below for reproducible local or remote CI tests:

| Docker image | Type | Description |
|--------------|------|-------------|
| [awesome-ci](https://github.com/cytopia/awesome-ci) | Basic | Tools for git, file and static source code analysis |
| [file-lint](https://github.com/cytopia/docker-file-lint) | Basic | Baisc source code analysis |
| [jsonlint](https://github.com/cytopia/docker-jsonlint) | Basic | Lint JSON files **<sup>[1]</sup>** |
| [yamllint](https://github.com/cytopia/docker-yamllint) | Basic | Lint Yaml files |
| [ansible](https://github.com/cytopia/docker-ansible) | Ansible | Multiple versoins of Ansible |
| [ansible-lint](https://github.com/cytopia/docker-ansible-lint) | Ansible | Lint  Ansible |
| [gofmt](https://github.com/cytopia/docker-gofmt) | Go | Format Go source code **<sup>[1]</sup>** |
| [goimports](https://github.com/cytopia/docker-goimports) | Go | Format Go source code **<sup>[1]</sup>** |
| [golint](https://github.com/cytopia/docker-golint) | Go | Lint Go code |
| [eslint](https://github.com/cytopia/docker-eslint) | Javascript | Lint Javascript code |
| [checkmake](https://github.com/cytopia/docker-checkmake) | Make | Lint Makefiles |
| [phpcbf](https://github.com/cytopia/docker-phpcbf) | PHP | PHP Code Beautifier and Fixer |
| [phpcs](https://github.com/cytopia/docker-phpcs) | PHP | PHP Code Sniffer |
| [php-cs-fixer](https://github.com/cytopia/docker-php-cs-fixer) | PHP | PHP Coding Standards Fixer |
| [black](https://github.com/cytopia/docker-black) | Python | The uncompromising Python code formatter |
| [pycodestyle](https://github.com/cytopia/docker-pycodestyle) | Python | Python style guide checker |
| [pylint](https://github.com/cytopia/docker-pylint) | Python | Python source code, bug and quality checker |
| [terraform-docs](https://github.com/cytopia/docker-terraform-docs) | Terraform | Terraform doc generator (TF 0.12 ready) **<sup>[1]</sup>** |
| [terragrunt](https://github.com/cytopia/docker-terragrunt) | Terraform | Terragrunt and Terraform |

> **<sup>[1]</sup>** Uses a shell wrapper to add **enhanced functionality** not available by original project.


### Makefiles

Visit **[cytopia/makefiles](https://github.com/cytopia/makefiles)** for dependency-less, seamless project integration and minimum required best-practice code linting for CI.
The provided Makefiles will only require GNU Make and Docker itself removing the need to install anything else.


## License

**[MIT License](LICENSE)**

Copyright (c) 2019 [cytopia](https://github.com/cytopia)
