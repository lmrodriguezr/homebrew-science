class Scythe < Formula
  desc "3'-end adapter contaminant trimmer"
  homepage "https://github.com/vsbuffalo/scythe"
  # tag "bioinformatics"

  url "https://github.com/vsbuffalo/scythe/archive/20d3cff7d7f483bd779aff75f861e93708c0a2b5.tar.gz"
  version "0.991"
  sha256 "83d087534911e2a729975cd0225c887ea15b1255ac1558aa8b5f614b12d6368d"

  depends_on "zlib" unless OS.mac?

  def install
    system "make"
    bin.install "scythe"
    libexec.install "illumina_adapters.fa"
  end

  test do
    assert_match "prior", shell_output("#{bin}/scythe --help")
  end
end
