class Eeroctl < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for managing Eero mesh Wi-Fi networks"
  homepage "https://github.com/fulviofreitas/eeroctl"
  url "https://files.pythonhosted.org/packages/65/b9/74222cfa0ba0c20ce79bacb4305c9a8f04e754ea50b1d3d0283f3ad3acce/eeroctl-1.7.1.tar.gz"
  sha256 "1fac59a54791ddfa5e1817510462aef04a214b9c23a98433356d1b1d7204ea38"
  license "MIT"
  head "https://github.com/fulviofreitas/eeroctl.git", branch: "master"

  depends_on "python@3.12"

  def install
    # Create virtualenv and install using pip with binary wheels (fast!)
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install "eeroctl==#{version}"

    # Link the executables
    bin.install_symlink libexec/"bin/eero"
    bin.install_symlink libexec/"bin/eeroctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eero --version")
    assert_match "Usage:", shell_output("#{bin}/eero --help")
  end
end
