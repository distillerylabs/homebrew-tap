class Gage < Formula
  desc "gage command-line tool: git-backed, age-encrypted secrets and notes (installs the `gage` binary; not a library)"
  homepage "https://github.com/distillerylabs/gage-rs"
  version "0.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/distillerylabs/gage-rs/releases/download/v0.2.0/gage-cli-aarch64-apple-darwin.tar.xz"
    sha256 "763e284754c3f85c8d7c2ec3d25c11659e2e86378e1187f350f6cf3aaa71767c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/distillerylabs/gage-rs/releases/download/v0.2.0/gage-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "13e904f2e8117c1a4dd5cc98590779df5f9a8d4322c7717155f7322cdfc1ca86"
    end
    if Hardware::CPU.intel?
      url "https://github.com/distillerylabs/gage-rs/releases/download/v0.2.0/gage-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5961d0fc916e2c0ecf70edb390ed9eb21118bf4d4eb5dafe7ef6875934588854"
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
