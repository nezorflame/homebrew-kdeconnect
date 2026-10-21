cask "kdeconnect" do
  arch arm: "arm64", intel: "x86_64"

  version_arm = "6826"
  sha256_arm = "9af3ca309931f9ea6db7635f0f2ce66f0a9cbeeaa7636ae3348232f6739aeb88"
  version_intel = "6589"
  sha256_intel = "7a9319a9e1426321b7cc4fe155467a34e698a9766f62fb8c5d1a1387e55bdb19"

  on_arm do
    version version_arm
    sha256 sha256_arm
  end
  on_intel do
    version version_intel
    sha256 sha256_intel
  end

  url "https://origin.cdn.kde.org/ci-builds/network/kdeconnect-kde/master/macos-#{arch}/kdeconnect-kde-master-#{version}-macos-clang-#{arch}.dmg"
  name "KDE Connect"
  desc "Multi-platform device integration: file sharing, notifications, remote input"
  homepage "https://kdeconnect.kde.org/"

  livecheck do
    url "https://origin.cdn.kde.org/ci-builds/network/kdeconnect-kde/master/macos-#{arch}/"
    regex(/kdeconnect-kde-master[._-](\d+)-macos-clang-#{arch}\.dmg/i)
  end

  depends_on macos: :ventura

  app "KDE Connect.app"

  zap trash: [
    "~/Library/Application Support/kdeconnect",
    "~/Library/Caches/KDE/kdeconnect",
    "~/Library/Logs/KDE/kdeconnect",
    "~/Library/Preferences/kdeconnectrc",
    "~/Library/Preferences/org.kde.kdeconnect.plist",
    "~/Library/Saved Application State/org.kde.kdeconnect.savedState",
  ]
end
