# AnyTogether Homebrew tap

Homebrew casks for [AnyPS5](https://github.com/AnyTogether/AnyPS5-ARM), the PS5 game launcher for Apple silicon Macs.

```sh
brew install --cask anytogether/tap/anyps5
```

Needs an Apple silicon Mac with macOS 14 or newer. Games run through Rosetta 2, which the launcher can install from its settings.

AnyPS5 is not signed with an Apple Developer ID or notarized. After installing, the cask removes the quarantine flag from `AnyPS5.app`, the same way the release's `install.sh` does, so macOS opens it without a warning.

The launcher updates itself. To remove it together with its settings, profiles, downloaded engines, logs and caches (your games, their saves and your captures stay where they are):

```sh
brew uninstall --zap --cask anyps5
```

The cask follows the latest stable release. A scheduled workflow (`.github/workflows/update-cask.yml`) checks every 6 hours and moves the version and checksum when a new one is out.
