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
    # Use pip to install from PyPI with binary wheels (no compilation needed)
    # This is MUCH faster than virtualenv_install_with_resources
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install "eeroctl==#{version}"
    bin.install_symlink libexec/"bin/eero"
    bin.install_symlink libexec/"bin/eeroctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eero --version")
    assert_match "Usage:", shell_output("#{bin}/eero --help")
  end
end
