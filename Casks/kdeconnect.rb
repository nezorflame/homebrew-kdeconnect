cask "kdeconnect" do
  arch arm: "arm64", intel: "x86_64"

  version "6461"
  sha256 arm:   "9282cd9317298b1a7794f5f56181ed1fd11f7792663f9a4ef82d94f5299f63e2",
         intel: "f34ae6cf5b6a0a44dafddbc4f2990be3b09cece9e41a08622b118a6db2337afa"

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
