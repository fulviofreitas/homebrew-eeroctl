class Eeroctl < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for managing Eero mesh Wi-Fi networks"
  homepage "https://github.com/fulviofreitas/eeroctl"
  url "https://files.pythonhosted.org/packages/22/16/13254e10d024ab6485d0de9a1a651d91ec475f591f3da7d88a8c95f00161/eeroctl-2.21.7.tar.gz"
  sha256 "ceadf044a3e070a54d8b71be761e989f5240cfa3dd546eceef3c00e9e34d3df4"
  license "MIT"
  head "https://github.com/fulviofreitas/eeroctl.git", branch: "master"

  depends_on "python@3.12"

  def install
    # Create virtualenv only - package installation happens in post_install
    # to bypass Homebrew's dylib ID rewriting which fails on pydantic_core
    virtualenv_create(libexec, "python3.12")

    # Create wrapper scripts that delegate to the actual binaries
    # These will work after post_install runs
    (bin/"eero").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/bin/eero" "$@"
    EOS
    (bin/"eeroctl").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/bin/eeroctl" "$@"
    EOS
  end

  def post_install
    # Install packages here, AFTER Homebrew's cleanup/linkage steps
    # This avoids the "Failed changing dylib ID" error for pydantic_core
    system libexec/"bin/python", "-m", "pip", "install",
 "--quiet", "--disable-pip-version-check",
 "eeroctl==#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eero --version")
    assert_match "Usage:", shell_output("#{bin}/eero --help")
  end
end
