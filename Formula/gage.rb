class Gage < Formula
  desc "gage command-line tool: git-backed, age-encrypted secrets and notes (installs the `gage` binary; not a library)"
  homepage "https://github.com/distillerylabs/gage-rs"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/distillerylabs/gage-rs/releases/download/v0.1.1/gage-cli-aarch64-apple-darwin.tar.xz"
    sha256 "910ce3254ae14ed611d3cf8e98cf15356171c202ce0d2fb3a71b4f654d718664"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/distillerylabs/gage-rs/releases/download/v0.1.1/gage-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dd2ecdfb6825b9f26179b92bb927c5a334e9c2e20f79e0ec26c18343af7897de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/distillerylabs/gage-rs/releases/download/v0.1.1/gage-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b01e241178546ffd3eb5f223f375d6e2e42fc3ac4efc56bf8924ea25d12a9c97"
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
