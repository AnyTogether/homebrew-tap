cask "anyps5" do
  version "0.2.36"
  sha256 "15ebece1e2dd44a67350b8e293d3714e3160611432e036b9655720362330e6fa"

  url "https://github.com/AnyTogether/AnyPS5-ARM/releases/download/v#{version}-arm/AnyPS5-macOS.zip"
  name "AnyPS5"
  desc "Launcher that turns PS5 game dumps into native programs"
  homepage "https://github.com/AnyTogether/AnyPS5-ARM"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)-arm$/i)
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "AnyPS5.app"

  # The app is not notarized: clear the download flags the way the release's install.sh does,
  # so macOS opens it without the "cannot be opened" warning.
  postflight_steps do
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.quarantine", "{{appdir}}/AnyPS5.app"],
        must_succeed: false,
        print_stderr: false
    run "/usr/bin/xattr",
        args:         ["-dr", "com.apple.provenance", "{{appdir}}/AnyPS5.app"],
        must_succeed: false,
        print_stderr: false
  end

  zap trash: [
    "~/Library/Application Support/AnyPS5",
    "~/Library/Caches/AnyPS5",
    "~/Library/Caches/org.anyps5.*",
    "~/Library/Logs/AnyPS5",
    "~/Library/Preferences/org.anyps5.launcher.plist",
  ]

  caveats <<~EOS
    AnyPS5 is not signed with an Apple Developer ID or notarized. After installing,
    this cask removes the quarantine flag from AnyPS5.app, as the release's install.sh
    does, so macOS opens it without a warning.

    AnyPS5 checks for its own updates and installs them itself.

    Games run through Rosetta 2. If it is missing, install it from the launcher's
    settings, or run:
      softwareupdate --install-rosetta --agree-to-license
  EOS
end
