require 'formula'

class Nonpareil < Formula
  homepage 'http://enve-omics.ce.gatech.edu/nonpareil'
  url 'https://github.com/lmrodriguezr/nonpareil/archive/v2.303.tar.gz'
  sha1 'abc41dbe8f17592662859905fe2eb4e517c1c1af'

  head 'https://github.com/lmrodriguezr/nonpareil.git'

  depends_on 'r'
  depends_on :mpi => [:cxx, :optional]

  def install
    system "make", "nonpareil"
    system "make", "mpicpp=#{ENV['MPICXX']}", "nonpareil-mpi" if build.with? :mpi
    system "make", "prefix=#{prefix}", "mandir=#{man1}", "install"
  end

  test do
    system "nonpareil", "-V"
    system "nonpareil-mpi", "-V" if build.with? 'open-mpi'
  end
end
