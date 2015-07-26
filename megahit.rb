class Megahit < Formula
  desc "Ultra-fast SMP/GPU succinct DBG metagenome assembly"
  homepage "https://github.com/voutcn/megahit"
  # doi "10.1093/bioinformatics/btv033"
  # tag "bioinformatics"

  url "https://github.com/voutcn/megahit/archive/v0.3.3.tar.gz"
  sha256 "f6c5edb6a42e020e82fa2d670ed803022fae243c9aea19f948d3176aa52e3fce"

  head "https://github.com/voutcn/megahit.git"

  bottle do
    sha256 "2c97141462746f7ee016e3701d3dbc8d29fcff0ddcf39005be064e3791a4ea80" => :yosemite
    sha256 "4b3f125ec9e00ed8a6e68af070c01a4be3b409880ee17be348f84491c1d79485" => :mavericks
    sha256 "50447828734d6529c3b78dd6c4ace0e00572969161746d89c8fd791f4cb90755" => :mountain_lion
  end

  fails_with :llvm do
    build 2336
    cause <<-EOS.undent
    llvm-g++ does not support -mpopcnt, -std=c++0x
    options
    EOS
  end

  # Fix error: 'omp.h' file not found
  needs :openmp

  def install
    system "make"
    bin.install Dir["megahi*"]
    doc.install "LICENSE", "ChangeLog.md", "README.md"
    (share/"megahit").install "example"
  end

  test do
    outdir = "megahit.outdir"
    system "#{bin}/megahit", "--12", "#{share}/megahit/example/readsInterleaved1.fa.gz", "-o", outdir
    assert File.exist?("#{outdir}/final.contigs.fa")
    assert File.read("#{outdir}/opts.txt").include?(outdir)
  end
end
