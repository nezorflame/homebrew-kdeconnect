cask "kdeconnect" do
  arch arm: "arm64", intel: "x86_64"

  version "6191"
  sha256 arm:   "237293209176c68f3b5e4462686bcc77e7172958e8b2c326d281c2e4c987dc7b",
         intel: "2a75185579776a6e1feb7bac2fabcca2251481b5ea84f8be542ec6fa62c204c5"

  url "https://origin.cdn.kde.org/ci-builds/network/kdeconnect-kde/master/macos-#{arch}/kdeconnect-kde-master-#{version}-macos-clang-#{arch}.dmg"
  name "KDE Connect"
  desc "Multi-platform device integration: file sharing, notifications, remote input"
  homepage "https://kdeconnect.kde.org/"

  livecheck do
    url "https://origin.cdn.kde.org/ci-builds/network/kdeconnect-kde/master/macos-#{arch}/"
    regex(/kdeconnect-kde-master[._-](\d+)-macos-clang-#{arch}\.dmg/i)
  end

  depends_on macos: ">= :ventura"

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
