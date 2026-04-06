class Jarkdown < Formula
  desc "Export Jira Cloud issues to Markdown with attachments"
  homepage "https://github.com/dchuk/jarkdown-rs"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.2.0/jarkdown-aarch64-apple-darwin.tar.xz"
      sha256 "bb98e2f572da9d0bdc574b6568a736bf781060fe63260d182ac5fc88b67afdd8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.2.0/jarkdown-x86_64-apple-darwin.tar.xz"
      sha256 "6fb0acca54cdc0851544fbf2cff301a233e75d4d49ff7e74917837609d8359dd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.2.0/jarkdown-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "650c4bbcb0bcf7fc57410aa5e806e1143c89a1920446bd4151cd14592783375e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dchuk/jarkdown-rs/releases/download/v1.2.0/jarkdown-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3ed2c718acca05a5e667c305a1cad7cde721a2445e54ab718d88d57fed65adbe"
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
