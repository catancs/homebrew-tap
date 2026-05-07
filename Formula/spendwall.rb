class Spendwall < Formula
  desc "Local-first agent spend firewall"
  homepage "https://github.com/catancs/spendwall"
  version "0.0.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.8/spendwall-aarch64-apple-darwin.tar.xz"
      sha256 "093ec7ce269381dce5614f41e854a46d4e3d64b5afc9aba80786b30ca12dbf0e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.8/spendwall-x86_64-apple-darwin.tar.xz"
      sha256 "0daf53681c29ffb2ece4761f46791371f38060701cce36fd2f45191f6fb81c98"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.8/spendwall-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "378215f8c0b842d5b69dfb4c2547f31780b2351254e624d6f21fb81866c76560"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.8/spendwall-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "80a61f4164352cc3dcf6e2adbc9008d6ca22e0aa45645520f1ddaafc6e1274ce"
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
    bin.install "spendwall" if OS.mac? && Hardware::CPU.arm?
    bin.install "spendwall" if OS.mac? && Hardware::CPU.intel?
    bin.install "spendwall" if OS.linux? && Hardware::CPU.arm?
    bin.install "spendwall" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
