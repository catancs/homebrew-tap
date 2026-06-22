class Spendwall < Formula
  desc "Local-first agent spend firewall"
  homepage "https://github.com/catancs/spendwall"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.1.1/spendwall-aarch64-apple-darwin.tar.xz"
      sha256 "6b97b43cbba99454998073495deab29f07508160f07ab798c73ba09b4511b7b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.1.1/spendwall-x86_64-apple-darwin.tar.xz"
      sha256 "44ed4fa2959c62a22d27f009b90bc5a4ceb1bcdc63d8e0a1e98d2bb2d159c0ac"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.1.1/spendwall-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e06d49561bd0e48b1ad86713a5daf2480e28eb1f70ea0699b1c079a61f286c60"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.1.1/spendwall-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "95c80b03271dc8b4d28c2bda051701ecb31463a1c276c436113749d10d5c5212"
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
