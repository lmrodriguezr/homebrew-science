class Wxmaxima < Formula
  desc "Cross platform GUI for Maxima"
  homepage "https://andrejv.github.io/wxmaxima"
  url "https://downloads.sourceforge.net/project/wxmaxima/wxMaxima/16.12.2/wxmaxima-16.12.2.tar.gz"
  sha256 "42c0a4dfb2e2ad349a49b117ef7c2e251292fb252ce9fde16242760f3dfc4278"

  bottle do
    cellar :any
    sha256 "3c82f647ee04ea3b7e52483d686f9c234b3937b75659a0d621fdbf1048204009" => :sierra
    sha256 "3b2f46ec73a685508757764b248de20e3059474dbb669ca4e4431ac49ab733d9" => :el_capitan
    sha256 "d1aa7ff4ac56ae41a8b8b13be665568dc669e3f8586a21ded1278c7d8a11e0fd" => :yosemite
  end

  head do
    url "https://github.com/andrejv/wxmaxima.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "wxmac"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    cd "locales" do
      system "make", "allmo"
    end
    system "make", "wxMaxima.app"
    prefix.install "wxMaxima.app"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    When you start wxMaxima the first time, set the path to Maxima
    (e.g. #{HOMEBREW_PREFIX}/bin/maxima) in the Preferences.

    Enable gnuplot functionality by setting the following variables
    in ~/.maxima/maxima-init.mac:
      gnuplot_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
      draw_command:"#{HOMEBREW_PREFIX}/bin/gnuplot"$
    EOS
  end
end
