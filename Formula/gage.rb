class Gage < Formula
  desc "gage command-line tool: git-backed, age-encrypted secrets and notes (installs the `gage` binary; not a library)"
  homepage "https://github.com/distillerylabs/gage-rs"
  version "0.3.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/distillerylabs/gage-rs/releases/download/v0.3.1/gage-cli-aarch64-apple-darwin.tar.xz"
    sha256 "74441a9f98ccb48f9fe950be5d94d9117168846fee4dbbd7256c0b2d2cefd8ab"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/distillerylabs/gage-rs/releases/download/v0.3.1/gage-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "787348abe308c0c5afe10e3a5e26aa1f22725f423e9a8db8998884e3e65c8fbe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/distillerylabs/gage-rs/releases/download/v0.3.1/gage-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9f152c2383c85705670d3284c30896b42eedc0938bfbe8badbf923f988c8382e"
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
