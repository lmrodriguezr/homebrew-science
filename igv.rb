class Igv < Formula
  homepage "http://www.broadinstitute.org/software/igv"
  # tag "bioinformatics"
  # doi "10.1093/bib/bbs017"
  head "https://github.com/broadinstitute/IGV.git"
  url "http://www.broadinstitute.org/igv/projects/downloads/IGV_2.3.52.zip"
  sha256 "b0bef5e92372c80e2d42f58e2e75d5fd736cc4fcb27caf13a85b8f09180bbb41"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "858a5ea4634a473f0ce4c786eab14762403a7aa08208d098397f2603e7d59b12" => :yosemite
    sha256 "3c8aff4b35fd9b2b5fa748ca0588d4c7237cd632706edbc69648c8e1c2966a60" => :mavericks
    sha256 "90d71592d24bb5893d374ddd018474e93b55c6c691bbab2bf91659723de8ca41" => :mountain_lion
  end

  depends_on :java

  def install
    inreplace "igv.sh", /^prefix=.*/, "prefix=#{libexec}"
    libexec.install Dir["igv.sh", "*.jar"]
    bin.install_symlink libexec/"igv.sh" => "igv"
    doc.install "readme.txt"
  end

  test do
    (testpath/"script").write "exit"
    assert_match "IGV", `#{bin}/igv -b script`
  end
end
