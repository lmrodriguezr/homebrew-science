class Maxima < Formula
  homepage "http://maxima.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/maxima/Maxima-source/5.34.1-source/maxima-5.34.1.tar.gz"
  sha1 "3f33730ca374c282a543da5ed78572eff72da34f"
  revision 1

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "29fc92fcd0619a76f6e7339f1f0f04106aa4f844e28dc8f4c941c9a667d9e22d" => :yosemite
    sha256 "e6ed2513be37d62c8f73fe7dfa91a4dbcf7c149f0e03fb8eecb96d46f27ba5dc" => :mavericks
    sha256 "7b4f568ed4d3f0ca84c079de617778b67d60d1640ce45af2802df92d610e1765" => :mountain_lion
  end

  depends_on "sbcl" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "rlwrap"

  # required for maxima help(), describe(), "?" and "??" lisp functionality
  skip_clean "share/info"

  # fixes 3468021: imaxima.el uses incorrect tmp directory on OS X:
  # https://sourceforge.net/tracker/?func=detail&aid=3468021&group_id=4933&atid=104933
  patch :DATA

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sbcl", "--with-sbcl=#{Formula["sbcl"].opt_bin}/sbcl",
                          "--enable-sbcl-exec",
                          "--enable-gettext"
    # Per build instructions
    ENV["LANG"] = "C"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/maxima", "--batch-string=run_testsuite(); quit();"
  end
end

__END__
diff --git a/interfaces/emacs/imaxima/imaxima.el b/interfaces/emacs/imaxima/imaxima.el
index e3feaa6..3a52a0b 100644
--- a/interfaces/emacs/imaxima/imaxima.el
+++ b/interfaces/emacs/imaxima/imaxima.el
@@ -296,6 +296,8 @@ nil means no scaling at all, t allows any scaling."
 	 (temp-directory))
 	((eql system-type 'cygwin)
 	 "/tmp/")
+	((eql system-type 'darwin)
+	 "/tmp/")
 	(t temporary-file-directory))
   "*Directory used for temporary TeX and image files."
   :type '(directory)
