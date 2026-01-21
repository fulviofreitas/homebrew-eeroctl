class Eeroctl < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for managing Eero mesh Wi-Fi networks"
  homepage "https://github.com/fulviofreitas/eeroctl"
  url "https://files.pythonhosted.org/packages/ea/51/23d81d425a30159aae116c68b5cb2d56504d7caa3e4ee2c2f5a76c84b28a/eeroctl-1.8.0.tar.gz"
  sha256 "0f9595ade8cc3b55e4cd73f28983f6510c4ec51c78d58f10441df31d435301b4"
  license "MIT"
  head "https://github.com/fulviofreitas/eeroctl.git", branch: "master"

  depends_on "python@3.12"

  def install
    # Create virtualenv
    venv = virtualenv_create(libexec, "python3.12")

    # Use pip directly to install with dependencies and binary wheels
    # Homebrew's venv.pip_install adds --no-deps which skips dependencies
    # We need dependencies (click, rich, etc.) so we call pip directly
    system libexec/"bin/pip", "install", "eeroctl==#{version}"

    bin.install_symlink libexec/"bin/eero"
    bin.install_symlink libexec/"bin/eeroctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eero --version")
    assert_match "Usage:", shell_output("#{bin}/eero --help")
  end
end
