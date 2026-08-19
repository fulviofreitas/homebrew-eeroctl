<div align="center">

# 🍺 Homebrew eeroctl

**Homebrew tap for the eeroctl CLI**

[![Homebrew](https://img.shields.io/badge/homebrew-eeroctl-FBB040?logo=homebrew&logoColor=white)](https://github.com/fulviofreitas/homebrew-eeroctl)
[![License](https://img.shields.io/badge/license-MIT-22c55e)](LICENSE)
[![Update Formula](https://github.com/fulviofreitas/homebrew-eeroctl/actions/workflows/update-formula.yml/badge.svg?branch=master)](https://github.com/fulviofreitas/homebrew-eeroctl/actions/workflows/update-formula.yml)

---

_Homebrew formulae for [eeroctl](https://github.com/fulviofreitas/eeroctl)._  
_The command-line interface for managing Eero mesh Wi-Fi networks._

[Install](#installation) · [Usage](#usage) · [eeroctl Repo](https://github.com/fulviofreitas/eeroctl)

</div>

---

## Installation

```bash
brew install fulviofreitas/eeroctl/eeroctl
```

## Upgrade

```bash
brew upgrade eeroctl
```

## Usage

```bash
eero --help
eero auth login
eero network list
eero device list
```

## Links

- [eeroctl Repository](https://github.com/fulviofreitas/eeroctl)
- [PyPI Package](https://pypi.org/project/eeroctl/)
- [Documentation](https://github.com/fulviofreitas/eeroctl/wiki)

## License

MIT

---

<div align="center">

## 📊 Repository Metrics

![Repository Metrics](./metrics.repository.svg)

</div>

## Graphify

This repo is wired to auto-warm a [graphify](https://github.com/Graphify-Labs/graphify) knowledge graph on Claude Code `SessionStart`. Outputs land in local `graphify-out/` (git-ignored). Requires `pipx install "graphifyy[terraform]==0.9.46"` on the host.
