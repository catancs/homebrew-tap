class SpendwallDaemon < Formula
  desc "Local-first agent spend firewall"
  homepage "https://github.com/catancs/spendwall"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.1.0/spendwall-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "fa37243560503aa7cce4d4722976cb8ecdb0eef3c843e6adcf2d110d4c8c43c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.1.0/spendwall-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "7a57944169a45bd221810e489145d9675683d241edfdb99824dfb616548ac460"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/catancs/spendwall/releases/download/v0.1.0/spendwall-daemon-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e55745cf81c4955cddc75afed721ba576078c8eda74965bd650f480548e616be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/catancs/spendwall/releases/download/v0.1.0/spendwall-daemon-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c21539de02eb4428adfda16b38ccb8224818bcf73fd22c57ad5471799339671b"
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
