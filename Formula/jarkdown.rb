class Jarkdown < Formula
  desc "Export Jira Cloud issues to Markdown with attachments"
  homepage "https://github.com/dchuk/jarkdown-rs"
  version "1.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.4.0/jarkdown-aarch64-apple-darwin.tar.xz"
      sha256 "103cf4911ed6759b0ddf3434e44801d3d3676087795dee09853bfeb8e10d7b79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.4.0/jarkdown-x86_64-apple-darwin.tar.xz"
      sha256 "7822d260de22b79bee69f8bfabb611cfa8be8c75b56b55c71d993340c3bfd219"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.4.0/jarkdown-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ff84b882121e5e497f977f7dbc3bf3ac497c7f3f8bcdc0856d3558e3c10773df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.4.0/jarkdown-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "71d2228c00388273132783df6d07c7e74db06bb50852e92953a00f0bc2ce586d"
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
