class SpendwallDaemon < Formula
  desc "Local-first agent spend firewall"
  homepage "https://github.com/catancs/spendwall"
  version "0.0.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.8/spendwall-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "a0dcc7504cc893f45a21077036565803e4246d649a434b5a67f22d48d2694646"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.8/spendwall-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "7706032f755638b7ff972a0e48a4fde4369c863a3305b36d5451629a4b523580"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.8/spendwall-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4c91a415bb3ad5799f09584c55cb3d422468c0584bd159fe43714bbcf4b757e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.0.8/spendwall-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "866b8a7efa1c80c980d30bb583f60c60ef2abf5abc5f98e9a3e627e1cf2e03e4"
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
