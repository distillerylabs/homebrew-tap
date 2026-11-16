class Gage < Formula
  desc "gage command-line tool: git-backed, age-encrypted secrets and notes (installs the `gage` binary; not a library)"
  homepage "https://github.com/distillerylabs/gage-rs"
  version "0.3.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/distillerylabs/gage-rs/releases/download/v0.3.0/gage-cli-aarch64-apple-darwin.tar.xz"
    sha256 "73c697cafd9081ae93f7549f874475450373f75a5819feecb84786e00032259b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/distillerylabs/gage-rs/releases/download/v0.3.0/gage-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3548a28cfec074c0a6eb4fba52a3b20fe7401dc8474dd55de7fe0738207c1c07"
    end
    if Hardware::CPU.intel?
      url "https://github.com/distillerylabs/gage-rs/releases/download/v0.3.0/gage-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "962b3e76065a73fa0f445b2cb50cc4a3f4ea9c4e1737947bf424cd0c2cd0c09a"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "gage"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "gage"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "gage"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
