class SpendwallDaemon < Formula
  desc "Local-first agent spend firewall"
  homepage "https://github.com/catancs/spendwall"
  version "0.0.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.6/spendwall-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "11b0dd60c2446010b1df3ccb61b72f3c7b8223bbf9d7ebaccdd1e9bd33b76330"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.6/spendwall-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "0ed90d04bb5f4fb09a8304d2baa27915d4efeec6f419c97ac76bb431e31858e5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.6/spendwall-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ea1a6935127fb091dfcea0c310b33be0665f8ab8d8bcd340bf5d70aeb49b09d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.6/spendwall-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a85de5069b3b924774b23a487cfe903819ed2f4b1ab69896592fc4575e43b2dc"
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
