cask "anyps5" do
  version "0.2.35"
  sha256 "413571c473e1349e5805685f6b355df6121698b4648e3c3ffea592d774789847"

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
  depends_on macos: ">= :sonoma"

  app "AnyPS5.app"

  # The app is not notarized: clear the download flags the way the release's install.sh does,
  # so macOS opens it without the "cannot be opened" warning.
  postflight do
    %w[com.apple.quarantine com.apple.provenance].each do |attribute|
      system_command "/usr/bin/xattr",
                     args:         ["-dr", attribute, "#{appdir}/AnyPS5.app"],
                     print_stderr: false
    end
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
