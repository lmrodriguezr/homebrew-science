class Fermikit < Formula
  desc "Assembly-based variant calling for Illumina reads"
  homepage "https://github.com/lh3/fermikit"
  # doi "arXiv:1504.06574"
  # tag "bioinformatics"

  url "https://github.com/lh3/fermikit/releases/download/v0.12/fermikit-0.12.tar.bz2"
  sha256 "c2d7281d3720fc06cfb5685dfa0b5b151636b44e4419fbac5a136cd5d73feb0a"

  head "https://github.com/lh3/fermikit.git"

  bottle do
    cellar :any
    sha256 "7cfc4ed60eec5fa75cd2af4d09c1a31080949ba8dda2fd85750109a82fcac60a" => :yosemite
    sha256 "a61fc63afe190b41ea0f5ac38705c44b9b6f33f990177bceb638e1eb7ea5b911" => :mavericks
    sha256 "b0f62232855027e6adccf5fafd87855616784d564ebe100560292ff40a15377a" => :mountain_lion
  end

  depends_on "bfc"
  depends_on "bwa"
  depends_on "fermi2"
  depends_on "htsbox"
  depends_on "ropebwt2"
  depends_on "seqtk"
  depends_on "trimadap"

  def install
    system "make"
    prefix.install Dir["fermi.kit/*"]
    bin.install_symlink "../run-calling"
    doc.install "NEWS.md", "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/run-calling 2>&1", 255)
  end
end
