class Jarkdown < Formula
  desc "Export Jira Cloud issues to Markdown with attachments"
  homepage "https://github.com/dchuk/jarkdown-rs"
  version "1.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.7.1/jarkdown-aarch64-apple-darwin.tar.xz"
      sha256 "fac57d79e5cea22cc462831f4c460dfa5ed3773f66c0f4a0cdb5eaaf75275026"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.7.1/jarkdown-x86_64-apple-darwin.tar.xz"
      sha256 "c062b5079054f6bdf95df5715e34b38c274dc061eb37b449ae6b1a28e999f313"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.7.1/jarkdown-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bcd84c237388eaf5a15f3db4df67d805cda0f7c5225bb7ba7f520055b0bd96ac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.7.1/jarkdown-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8412b2c6e44e75f959a0828aee00a4ce789145d53f906283d5e2fcab82975839"
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
