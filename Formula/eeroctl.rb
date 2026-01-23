class Eeroctl < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for managing Eero mesh Wi-Fi networks"
  homepage "https://github.com/fulviofreitas/eeroctl"
  url "https://files.pythonhosted.org/packages/2a/89/d89566135cf97295582c4fa16d6e57a8800a879a42c982b687bec30cb9e7/eeroctl-2.7.0.tar.gz"
  sha256 "2d5f569a32527b90dd1e14b35c1dd00fe470e58fdbd40c2f12cc299abb33fa10"
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
