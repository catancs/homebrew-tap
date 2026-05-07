class Spendwall < Formula
  desc "Local-first agent spend firewall"
  homepage "https://github.com/catancs/spendwall"
  version "0.0.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.9/spendwall-aarch64-apple-darwin.tar.xz"
      sha256 "242e10cb1104cfd36eeb4602c2310f550ef9e42a441b6538f3c1685b9a80d652"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.9/spendwall-x86_64-apple-darwin.tar.xz"
      sha256 "460ceb2f447cc8c0c35d4a26b2a00f4f8a6c26bfe5708589d170906e292259a5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.9/spendwall-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d321125c3fa0a155db14cabe3bc3b913e548227a274cbc1da883cae138e349c9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.9/spendwall-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d4d0d6c6be640b10244ff75c2ec3a7e98799f1d4750d50176a818bd0b73fd340"
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
