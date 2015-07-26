class Stringtie < Formula
  homepage "http://ccb.jhu.edu/software/stringtie"
  head "https://github.com/gpertea/stringtie"
  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "629fc4718be56af23c58ad49450445443280cf5f4abe7e0d9fdad62a01ea7d39" => :yosemite
    sha256 "3f615ab88a8d943cdb1555b1176506aa547be2b37ac213c9d1332463329f6051" => :mavericks
    sha256 "299ffb79d445e9984f5fe8050f34e74d67a3ba93c363d574105edef47f1cbdc5" => :mountain_lion
  end

  # doi "10.1038/nbt.3122"
  # tag "bioinformatics"

  url "http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.0.3.tar.gz"
  sha256 "1567d9d87d9375a3db03fa0b682eaef4e89899df64fd001c14d475cc9e737e08"

  def install
    system "make", "release"
    bin.install "stringtie"
    doc.install "README", "LICENSE"
  end

  test do
    assert_match "transcripts", shell_output("stringtie 2>&1", 1)
  end
end
