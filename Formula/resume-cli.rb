class ResumeCli < Formula
  desc "Generate resumes and PDFs from a config file (Community Edition)"
  homepage "https://github.com/ansidev/resume-cli-ce"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ansidev/resume-cli-ce/releases/download/v0.3.0/resume-cli_0.3.0_darwin_arm64.tar.gz"
      sha256 "12b05f7941fe36eab032a8977d264bc6e401820c59e12a257c0dd8b64725ee96"
    else
      url "https://github.com/ansidev/resume-cli-ce/releases/download/v0.3.0/resume-cli_0.3.0_darwin_amd64.tar.gz"
      sha256 "e4f9c0d0e8b42b231b0baab0178010e5b02a67120e1736545055e46ed7e68cfe"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ansidev/resume-cli-ce/releases/download/v0.3.0/resume-cli_0.3.0_linux_arm64.tar.gz"
      sha256 "864f0f16c8a6f0e60663b180b2fc36d3419bbd57f295c06f5c2bb699fca7967b"
    else
      url "https://github.com/ansidev/resume-cli-ce/releases/download/v0.3.0/resume-cli_0.3.0_linux_amd64.tar.gz"
      sha256 "ceb6a4990e7b7fa85915b5a49c240066fc5021a66d3f53bf6aa876accd088d6e"
    end
  end

  def install
    bin.install "resume-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resume-cli version")
  end
end
