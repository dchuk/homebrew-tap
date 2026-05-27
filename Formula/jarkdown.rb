class Jarkdown < Formula
  desc "Export Jira Cloud issues to Markdown with attachments"
  homepage "https://github.com/dchuk/jarkdown-rs"
  version "1.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.7.0/jarkdown-aarch64-apple-darwin.tar.xz"
      sha256 "20861c739b94a7fc4fd354781aa66466ec545f7286d45467f4da1e9407bec9b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.7.0/jarkdown-x86_64-apple-darwin.tar.xz"
      sha256 "8fda057373f7025d163a636e1ffd5cf2eb5d85631e1c444e35584331033a60d3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.7.0/jarkdown-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "465b3c3935629fdd487b0636c9740174f466bbbc925513a2511d59a5459059e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.7.0/jarkdown-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "123ac222015b2e8966bfb644f5183310e2c62f2c580edb986991a40e9b8c3791"
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
