class Tbl2asn < Formula
  homepage "https://www.ncbi.nlm.nih.gov/genbank/tbl2asn2/"
  #tag "bioinformatics"

  version "24.3"
  if OS.mac?
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/mac.tbl2asn.gz"
    sha256 "0fc76b2d35974c9d20a444272ed556a0f094659a3bc4162b16ffbddaceff4ce9"
  elsif OS.linux?
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz"
    sha256 "d1ccef96cec34fcfc74f4c70a1d0582f66508a754fa3ae137bb33e1ce310fe37"
  end

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "7ce5ef183140c8f434eb502cefe23ab47ce34f82049a9c44ac0278029975353a" => :yosemite
    sha256 "b3a38555218920e11b2286eb06e0ba6e88d733b588a0d6c628363bbe8913137d" => :mavericks
    sha256 "b85880c7198de7c0abbde134a2e2f4f68dc89f546730c474fe89801066aaefc5" => :mountain_lion
  end

  resource "doc" do
    url "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/DOCUMENTATION/tbl2asn.txt"
    sha256 "b5e139c2a22cea4e1b5c7a063e3fb1f311d6b8802f2a8cca1433d7f16f816300"
  end

  def install
    if OS.mac?
      bin.install "mac.tbl2asn" => "tbl2asn"
    elsif OS.linux?
      bin.install "linux64.tbl2asn" => "tbl2asn"
    end
    doc.install resource("doc")
  end

  test do
    assert_match "tbl2asn #{version}", shell_output("tbl2asn -", 0)
  end
end
