require 'formula'

class Velvet < Formula
  homepage 'http://www.ebi.ac.uk/~zerbino/velvet/'
  url 'http://www.ebi.ac.uk/~zerbino/velvet/velvet_1.2.10.tgz'
  sha1 '216f0941609abf3a73adbba19ef1f364df489d18'

  head 'https://github.com/dzerbino/velvet.git'

  def install
    inreplace 'Makefile' do |s|
      # recommended in Makefile for compiling on Mac OS X
      s.change_make_var! "CFLAGS", "-Wall -m64"
    end

    args = ["LONGSEQUENCES=1"]
    args << "OPENMP=1" unless ENV.compiler == :clang
    args << ("MAXKMERLENGTH=" + ENV['MAXKMERLENGTH']) if ENV['MAXKMERLENGTH']
    args << ("CATEGORIES=" + ENV['CATEGORIES']) if ENV['CATEGORIES']

    system "make", "velveth", "velvetg", *args
    bin.install 'velveth', 'velvetg'

    # install additional contributed scripts
    (share/'velvet/contrib').install Dir['contrib/shuffleSequences_fasta/shuffleSequences_*']
  end

  def caveats
    <<-EOS.undent
      If you want to build with a different kmer length, you can set
      the environmental variable MAXKMERLENGTH=X to a value (X) *before*
      you brew this formula.
      
      If you want to build with support for multiple categories, you
      can set the environmental variable CATEGORIES=X to a value (X)
      *before* you brew this formula.
      
      The values used at build time were:
      #{args}

      Some additional user contributed scripts are installed here:
      #{share}/velvet/contrib
    EOS
  end

  def test
    system "velveth --help"
    system "velvetg --help"
  end
end
