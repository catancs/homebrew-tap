class SpendwallDaemon < Formula
  desc "Local-first agent spend firewall"
  homepage "https://github.com/catancs/spendwall"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.1.1/spendwall-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "57ff8b5825deff1b934ec3f06c21027da5bbe3cdc7f9a8f6c9f634dfd818cf32"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.1.1/spendwall-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "d3dd9af1c846b2da5b57af98cf92da903ce2096b99c0a7658dd2935f426d8e9b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.1.1/spendwall-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "868c5e67d6ed60f8667b73eacc07d3b91ea8240122a11c7c1e728a15d3d1c80f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.1.1/spendwall-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "42fa8bd403fae76cc8b23252c54992692826d28022828a84e3e246f5044a6fb6"
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
