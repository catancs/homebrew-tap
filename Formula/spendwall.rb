class Spendwall < Formula
  desc "Local-first agent spend firewall"
  homepage "https://github.com/catancs/spendwall"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.1.0/spendwall-aarch64-apple-darwin.tar.xz"
      sha256 "cf086265bb6ac936e86273a28c39a3f3c3ff82ae7500322f120035a46f4c3cfb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.1.0/spendwall-x86_64-apple-darwin.tar.xz"
      sha256 "5c397095c5252f9be801a1f3ee1f1954665b02c5b3566c7b4f94fbe0e210126c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.1.0/spendwall-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "784d90cdeabc1d29069671ded777476f761cbae87d90616d49e1d01e850c9df3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.1.0/spendwall-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "37b876db5996dab984a6d22e79dda30930b5abc85a45ad3068aeacec4b062bad"
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
