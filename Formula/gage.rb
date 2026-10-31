class Gage < Formula
  desc "gage command-line frontend (binary: gage)"
  homepage "https://github.com/distillerylabs/gage-rs"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/distillerylabs/gage-rs/releases/download/v0.1.0/gage-cli-aarch64-apple-darwin.tar.xz"
      sha256 "18a2ea79edd78b4370a0eaa1170069ae7557eb2e5680a2b13a5d38a071e40815"
    end
    if Hardware::CPU.intel?
      url "https://github.com/distillerylabs/gage-rs/releases/download/v0.1.0/gage-cli-x86_64-apple-darwin.tar.xz"
      sha256 "d60cbc58e1e268312dd035b9355eb61f55cabed937f7127cc192666ea179a78b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/distillerylabs/gage-rs/releases/download/v0.1.0/gage-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c126435f7339226a271daf5a7c776f36927d3b9b810846c6c8a0da3794c37bd6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/distillerylabs/gage-rs/releases/download/v0.1.0/gage-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e5bb188b787b69f8f9d321e6d0290dcdb12bcac527fe41c2f409cf4d0675536a"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    if OS.mac? && Hardware::CPU.intel?
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
