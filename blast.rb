class Blast < Formula
  homepage "http://blast.ncbi.nlm.nih.gov/"
  # doi "10.1016/S0022-2836(05)80360-2"
  # tag "bioinformatics"

  url "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.2.30/ncbi-blast-2.2.30+-src.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/n/ncbi-blast+/ncbi-blast+_2.2.30.orig.tar.gz"
  version "2.2.30"
  sha256 "26f72d51c81b9497f33b7274109565c36692572faef4d72377f79b7e59910e40"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    revision 4
    sha256 "97ceb730f0e337c0226482540ba80be02f1532d530d64055249e306a46427822" => :yosemite
    sha256 "ef753168975423c481862be97688847986a2fe64709b135c0d634ca2b502964c" => :mavericks
    sha256 "cd3f9044fc34579f876ddb674331be26418d4dc21a72f9b1a09814d057dec8e4" => :mountain_lion
  end

  # Build failure reported to toolbox@ncbi.nlm.nih.gov on 11 May 2015,
  # patch provided by developers; should be included in next release
  patch :p0, :DATA

  option "without-static", "Build without static libraries & binaries"
  option "with-dll", "Build dynamic libraries"
  option "without-check", "Skip the self tests (Boost not needed)"

  depends_on "boost" if build.with? "check"
  depends_on "freetype" => :optional
  depends_on "gnutls"   => :optional
  depends_on "hdf5"     => :optional
  depends_on "jpeg"     => :recommended
  depends_on "libpng"   => :recommended
  depends_on "pcre"     => :recommended
  depends_on :mysql     => :optional
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    # Fix error:
    # /bin/sh: line 2: /usr/bin/basename: No such file or directory
    # See http://www.ncbi.nlm.nih.gov/viewvc/v1?view=revision&revision=65204
    inreplace "c++/src/build-system/Makefile.in.top", "/usr/bin/basename", "basename"

    args = %W[--prefix=#{prefix} --without-debug --with-mt]

    args << (build.with?("mysql") ? "--with-mysql" : "--without-mysql")
    args << (build.with?("freetype") ? "--with-freetype=#{Formula["freetype"].opt_prefix}" : "--without-freetype")
    args << (build.with?("gnutls") ? "--with-gnutls=#{Formula["gnutls"].opt_prefix}" : "--without-gnutls")
    args << (build.with?("jpeg")   ? "--with-jpeg=#{Formula["jpeg"].opt_prefix}" : "--without-jpeg")
    args << (build.with?("libpng") ? "--with-png=#{Formula["libpng"].opt_prefix}" : "--without-png")
    args << (build.with?("pcre")   ? "--with-pcre=#{Formula["pcre"].opt_prefix}" : "--without-pcre")
    args << (build.with?("hdf5")   ? "--with-hdf5=#{Formula["hdf5"].opt_prefix}" : "--without-hdf5")

    if build.without? "static"
      args << "--with-dll" << "--without-static" << "--without-static-exe"
    else
      args << "--with-static"
      args << "--with-static-exe" unless OS.linux?
      args << "--with-dll" if build.with? "dll"
    end

    # Boost is used only for unit tests.
    args << (build.with?("check") ? "--with-check" : "--without-boost")

    cd "c++" do
      system "./configure", *args
      system "make"
      system "make", "install"

      # libproj.a conflicts with the formula proj
      libexec.install Dir["#{lib}/lib*.a"] if build.with? "static"
    end
  end

  def caveats; <<-EOS.undent
    Using the option '--without-static' will create dynamic binaries instead of
    static. The NCBI Blast static installation is approximately 7 times larger
    than the dynamic.

    Static binaries should be used for speed if the executable requires
    fast startup time, such as if another program is frequently restarting
    the blast executables.

    Static libraries are installed in #{libexec}
    EOS
  end

  test do
    system bin/"blastn", "-version"
  end
end

__END__
--- c++/include/corelib/ncbimtx.inl (revision 467211)
+++ c++/include/corelib/ncbimtx.inl (working copy)
@@ -388,7 +388,17 @@
     _ASSERT(m_Lock);

     m_ObjLock.Lock();
-    m_Listeners.remove(TRWLockHolder_ListenerWeakRef(listener));
+    // m_Listeners.remove(TRWLockHolder_ListenerWeakRef(listener));
+    // The above gives strange errors about invalid operands to operator==
+    // with the Apple Developer Tools release containing Xcode 6.3.1 and
+    // "Apple LLVM version 6.1.0 (clang-602.0.49) (based on LLVM 3.6.0svn)".
+    // The below workaround should be equivalent.
+    TRWLockHolder_ListenerWeakRef ref(listener);
+    TListenersList::iterator it;
+    while ((it = find(m_Listeners.begin(), m_Listeners.end(), ref))
+           != m_Listeners.end()) {
+        m_Listeners.erase(it);
+    }
     m_ObjLock.Unlock();
 }
