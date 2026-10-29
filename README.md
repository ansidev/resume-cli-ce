# Resume CLI (Community Edition)

[![Downloads](https://img.shields.io/github/downloads/ansidev/resume-cli-ce/total)](https://github.com/ansidev/resume-cli-ce/releases)

This repository contains releases of resume-cli.

`resume-cli` generates a resume (PDF or HTML) from a config file and a theme. It is inspired by
[JSON Resume](https://jsonresume.org/).

## Installation

### Homebrew (macOS and Linux)

```sh
brew tap ansidev/resume-cli-ce https://github.com/ansidev/resume-cli-ce
brew trust --formula ansidev/resume-cli-ce/resume-cli
brew install resume-cli
```

The formula installs the prebuilt binary from the matching GitHub release. Upgrade with `brew upgrade resume-cli`.

### Download binary

Download the archive for your platform from the [releases page](https://github.com/ansidev/resume-cli-ce/releases), verify it against `checksums.txt`, and put `resume-cli` on your `PATH`.

## Manual

### Quick start

Create a `resume.config.yaml` (see [`sample_config.yaml`](sample_config.yaml)) with your resume data and a theme,
then run:

```sh
resume-cli generate --format pdf --output generated
```

The config file is read from `resume.config.yaml` in the current directory unless you pass `--config`. Use
`resume-cli dev` to preview the resume in the browser while you edit.

### Commands

#### `resume-cli dev`

Start a development server.

```
OPTIONS:
   --config value, -c value  Override config filename
   --theme value, -t value   Override theme location
   --allow-remote-helpers    Allow running Go helper code from a remote theme (executes untrusted code)
   --port value, -p value    Override server port (default: 0)
   --help, -h                show help
```

#### `resume-cli generate`

Generate the resume.

```
OPTIONS:
   --config value, -c value  Override config filename
   --theme value, -t value   Override theme location
   --allow-remote-helpers    Allow running Go helper code from a remote theme (executes untrusted code)
   --format value, -f value  Output format for the generated resume (pdf, html) (default: "pdf")
   --output value, -o value  Output path for the generated resume (default: "generated")
   --minify, -m              Minify the generated html (ignored for pdf) (default: false)
   --help, -h                show help
```

#### `resume-cli version`

Print the CLI version and the git commit it was built from, e.g. `0.1.0 (commit: 73d78f7...)`.

### PDF print defaults

The `generate:` block of the config file controls PDF printing. Every key is optional; omitted keys fall back to the
same settings as the Chrome print dialog, and values you set always win.

| Key                           | Default | Chrome print dialog      |
|-------------------------------|---------|--------------------------|
| `pageRanges`                  | `''`    | Pages: all               |
| `landscape`                   | `false` | Layout: portrait         |
| `paperWidth`                  | `8.27`  | Paper size: A4 (inches)  |
| `paperHeight`                 | `11.69` | Paper size: A4 (inches)  |
| `marginTop/Bottom/Left/Right` | `0.4`   | Margins: Default (~1cm)  |
| `scale`                       | `1`     | Scale: Default (100%)    |
| `displayHeaderFooter`         | `false` | Headers and footers: off |
| `printBackground`             | `true`  | Background graphics: on  |

### Themes

Configure the theme in `resume.config.yaml`:

```yaml
theme:
  type: local # local | remote
  location: ./themes/my-theme # local: absolute or relative path to the theme folder; remote: git URL
```

- `local`: `location` is the path to the theme folder.
- `remote`: `location` is a git URL. The repository is shallow-cloned into the user cache dir
  (`<user cache dir>/resume-cli/themes/`) and updated on later runs. `git` must be available on `PATH`.
- `--theme` overrides `theme.location`.
- A theme is required. `sample_config.yaml` uses the remote
  [resume-theme-default](https://github.com/ansidev/resume-theme-default.git) theme.

Every theme must contain a `theme.yaml` at its root:

```yaml
name: theme-name
templateEngine: html # html | handlebars
```

The command fails fast on an invalid `type`, an empty `location`, a missing `theme.yaml`, or a missing/unsupported
`name`/`templateEngine`.

#### Theme structure

```
|-- theme.yaml: theme manifest (name, templateEngine, optional helpers)
|-- resources: view files
|   |-- assets
|   |   |-- css
|   |   |   |-- styles.css
|   |   |-- js
|   |       |-- scripts.js
|   |-- partials: partial files
|   |-- resume.{template_extension}: file extension depends on the used template engine
|-- helpers.go: optional helper functions
```

`assets/css/styles.css` and `assets/js/scripts.js` are injected by default. If a file is missing you will see a
warning log, which you can ignore.

#### Helper functions

A theme can provide template functions (e.g. `year`, `markdown`) by declaring a helpers file in `theme.yaml`:

```yaml
name: theme-name
templateEngine: html
helpers: helpers.go # optional, .go file relative to the theme folder
```

The file is interpreted at runtime and must declare
`func Funcs() map[string]interface{}`; the returned functions are added to the template engine:

```go
package helpers

import "strings"

func Funcs() map[string]interface{} {
	return map[string]interface{}{"lower": strings.ToLower}
}
```

The Go standard library can be imported. `helpers` must be a relative `.go` path inside the theme folder.

> **Security:** helper code runs with the full privileges of the CLI process (it is not sandboxed). It runs
> automatically for `local` themes. For `remote` themes it is refused unless you review the theme and pass
> `--allow-remote-helpers`.

## Contact

Le Minh Tri [@ansidev](https://ansidev.xyz/about).

## License

This source code is available under the [AGPL-3.0 LICENSE](/LICENSE).
