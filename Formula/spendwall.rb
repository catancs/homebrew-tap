class Spendwall < Formula
  desc "Local-first agent spend firewall"
  homepage "https://github.com/catancs/spendwall"
  version "0.0.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.6/spendwall-aarch64-apple-darwin.tar.xz"
      sha256 "a75dcabc8fb118dc882f6dddc3f629828bdec8b758d7dba8d876a34b9d5cf390"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.6/spendwall-x86_64-apple-darwin.tar.xz"
      sha256 "2d9e0eb57b618471cfc59b8ea9fad3ac941baa736a0ff96a10697bd722a36ae0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.6/spendwall-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "df12aa83ec223a956e36198736df7f0ab1e7283ee75974f2bbb5ef3f1c0d66b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.6/spendwall-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dbbdcd9006395e47078b8bdc3cafb92eabc41c9ba2ca975a8e056557b4df3180"
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
