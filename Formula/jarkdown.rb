class Jarkdown < Formula
  desc "Export Jira Cloud issues to Markdown with attachments"
  homepage "https://github.com/dchuk/jarkdown-rs"
  version "1.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.5.0/jarkdown-aarch64-apple-darwin.tar.xz"
      sha256 "625b1d15135198086ba785232755fec34b96c43a01028a1f7bf8bbd03d54a712"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.5.0/jarkdown-x86_64-apple-darwin.tar.xz"
      sha256 "84e226d72d3a03d2b3c36a4fec8fb0a3a1e2514794d28e7ee8c53a48b4448ed1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.5.0/jarkdown-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "418967ffd2be852d881750fabcce877ab6c4314562c142637dd4eba807103d2f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.5.0/jarkdown-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ee98f0c7607dad292e52a0b9cfb47b961e76962e01902e8da9ba085825fce35d"
    end
  end
  license "MIT"

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
    bin.install "jarkdown-rs" if OS.mac? && Hardware::CPU.arm?
    bin.install "jarkdown-rs" if OS.mac? && Hardware::CPU.intel?
    bin.install "jarkdown-rs" if OS.linux? && Hardware::CPU.arm?
    bin.install "jarkdown-rs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
