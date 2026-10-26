class ResumeCli < Formula
  desc "Generate resumes and PDFs from a config file (Community Edition)"
  homepage "https://github.com/ansidev/resume-cli-ce"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ansidev/resume-cli-ce/releases/download/v0.2.0/resume-cli_0.2.0_darwin_arm64.tar.gz"
      sha256 "45ec232a8df43eba2857303879a31d136f879994bdb26f4e8369724192bf1661"
    else
      url "https://github.com/ansidev/resume-cli-ce/releases/download/v0.2.0/resume-cli_0.2.0_darwin_amd64.tar.gz"
      sha256 "d8c852c2f2190558e62426ab5068f0d7d74518cb921282866773141d5b7e80f1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/ansidev/resume-cli-ce/releases/download/v0.2.0/resume-cli_0.2.0_linux_arm64.tar.gz"
      sha256 "0a273aa7a340cd003244aee7185d15536eb7d46edd10d2fb31530cd76223877c"
    else
      url "https://github.com/ansidev/resume-cli-ce/releases/download/v0.2.0/resume-cli_0.2.0_linux_amd64.tar.gz"
      sha256 "335899d5b9446e6c7e74af90745a4f4bfef6c2baef8b9c16b5ee3ee1abe14cdd"
    end
  end

  def install
    bin.install "resume-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resume-cli version")
  end
end
