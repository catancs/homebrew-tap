class SpendwallDaemon < Formula
  desc "Local-first agent spend firewall"
  homepage "https://github.com/catancs/spendwall"
  version "0.0.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.9/spendwall-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "2a4ad5a42c453f5854804365d95594880715e4d68ae474ee7970c08ee9e89eec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.9/spendwall-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "a1aac20da0b174e1a854d54659c395546f56f5b36df1d9932524e6a2e79d3740"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.9/spendwall-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a72b2176971d9e6aebeb86b1989b0cb2e64147fcecbfa7fb0fd412833a6f95e8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.9/spendwall-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "283a6ed073e64389259f36ba897dc92dc29bf6a2522719a8e10217c448635f38"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "spendwall-daemon" if OS.mac? && Hardware::CPU.arm?
    bin.install "spendwall-daemon" if OS.mac? && Hardware::CPU.intel?
    bin.install "spendwall-daemon" if OS.linux? && Hardware::CPU.arm?
    bin.install "spendwall-daemon" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
