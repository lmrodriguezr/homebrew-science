class Neuron < Formula
  homepage "http://www.neuron.yale.edu/neuron/"

  stable do
    url "http://www.neuron.yale.edu/ftp/neuron/versions/v7.3/nrn-7.3.tar.gz"
    sha256 "71cff5962966c5cd5d685d90569598a17b4b579d342126b31e2d431128cc8832"
  end

  devel do
    url "http://www.neuron.yale.edu/ftp/neuron/versions/alpha/nrn-7.4.rel-1324.tar.gz"
    sha256 "cfc5270f9f06321dfaa3b55beb68dc4ec82cdfd747647bb1528e0ccc850de201"
    version "7.4.rel-1324"
  end

  head "http://www.neuron.yale.edu/hg/neuron/nrn", :using => :hg

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    revision 1
    sha256 "9bf15cfbca9705355210124779d03e562ec00d143f20a4207f2e211bf9034ab1" => :yosemite
    sha256 "f93236ba8505520cd7fc84a8f040a3ff7efb6610d4ce51d962036cd67d6be8e4" => :mavericks
    sha256 "b57130d879639a770b329dde55a62d195c61351842ea4b96ccf013edcdf51532" => :mountain_lion
  end

  depends_on "inter-views"
  depends_on :mpi => :optional
  depends_on :python if MacOS.version <= :snow_leopard

  # NEURON uses .la files to compile HOC files at runtime
  skip_clean :la

  # 1. The build fails (for both gcc and clang) when trying to build
  #    src/mac/mac2uxarg.c, which uses Carbon.
  #    According to the lead developer, Carbon is not available for 64-bit
  #    machines, and is an "ancient launcher helper", so we remove it,
  #    as was suggested in this forum thread:
  #       http://www.neuron.yale.edu/phpbb/viewtopic.php?f=4&t=3254
  # 2. The build assumes InterViews kept .la files around. It doesn't,
  #    so we link directly to the .dylib instead.
  patch :DATA

  def install
    dylib = OS.mac? ? "dylib" : "so"
    inreplace "configure", "$IV_LIBDIR/libIVhines.la", "$IV_LIBDIR/libIVhines.#{dylib}"

    args = ["--with-iv=#{Formula["inter-views"].opt_prefix}"]
    args << "--with-paranrn" if build.with? "mpi"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-pysetup=no",
                          "--with-nrnpython",
                          "--without-mpi",
                          "--prefix=#{prefix}",
                          "--exec-prefix=#{libexec}",
                          *args

    system "make"
    system "make", "check"
    system "make", "install"

    cd "src/nrnpython" do
      system "python", *Language::Python.setup_install_args(prefix)
    end

    # Neuron builds some .apps which are useless and in the wrong place
    ["idraw", "mknrndll", "modlunit",
     "mos2nrn", "neurondemo", "nrngui"].each do |app|
      rm_rf "#{prefix}/../#{app}.app"
    end

    ln_sf Dir["#{libexec}/lib/*.dylib"], lib
    ln_sf Dir["#{libexec}/lib/*.so.*"], lib
    ln_sf Dir["#{libexec}/lib/*.so"], lib
    ln_sf Dir["#{libexec}/lib/*.la"], lib
    ln_sf Dir["#{libexec}/lib/*.o"], lib

    ["hoc_ed", "ivoc", "modlunit", "mos2nrn", "neurondemo",
     "nocmodl", "nrngui", "nrniv", "nrnivmodl", "sortspike"].each do |exe|
      bin.install_symlink "#{libexec}/bin/#{exe}"
    end
  end

  def caveats; <<-EOS.undent
    NEURON recommends that you set an X11 option that raises the window
    under the mouse cursor on mouseover. If you don't set this option,
    NEURON's GUI will still work, but you will have to click in each window
    before you can interact with the widgets in that window.

    To raise the window on mouse hover, execute:
        defaults write org.macosforge.xquartz.X11 wm_ffm -bool true
    To revert this behavior, execute:
        defaults write org.macosforge.xquartz.X11 wm_ffm -bool false
    EOS
  end

  test do
    system "#{bin}/nrniv", "--version"
    system "python", "-c", "import neuron; neuron.test()"
  end
end

__END__
diff --git i/src/mac/Makefile.in w/src/mac/Makefile.in
index cecf310..7618ee0 100644
--- i/src/mac/Makefile.in
+++ w/src/mac/Makefile.in
@@ -613,17 +613,6 @@ uninstall-am: uninstall-binSCRIPTS
	uninstall-am uninstall-binSCRIPTS

 @MAC_DARWIN_TRUE@install: install-am
-@MAC_DARWIN_TRUE@@UniversalMacBinary_TRUE@	$(CC) -arch ppc -o aoutppc -Dcpu="\"$(host_cpu)\"" -I. $(srcdir)/launch.c $(srcdir)/mac2uxarg.c -framework Carbon
-@MAC_DARWIN_TRUE@@UniversalMacBinary_TRUE@	$(CC) -arch i386 -o aouti386 -Dcpu="\"$(host_cpu)\"" -I. $(srcdir)/launch.c $(srcdir)/mac2uxarg.c -framework Carbon
-@MAC_DARWIN_TRUE@@UniversalMacBinary_TRUE@	lipo aouti386 aoutppc -create -output a.out
-@MAC_DARWIN_TRUE@@UniversalMacBinary_FALSE@	gcc -g -arch i386 -Dncpu="\"$(host_cpu)\"" -I. $(srcdir)/launch.c $(srcdir)/mac2uxarg.c -framework Carbon
-
-@MAC_DARWIN_TRUE@	carbon=$(carbon) sh $(srcdir)/launch_inst.sh "$(host_cpu)" "$(DESTDIR)$(prefix)" "$(srcdir)"
-@MAC_DARWIN_TRUE@	for i in $(S) ; do \
-@MAC_DARWIN_TRUE@		sed "s/^CPU.*/CPU=\"$(host_cpu)\"/" < $(DESTDIR)$(bindir)/$$i > temp; \
-@MAC_DARWIN_TRUE@		mv temp $(DESTDIR)$(bindir)/$$i; \
-@MAC_DARWIN_TRUE@		chmod 755 $(DESTDIR)$(bindir)/$$i; \
-@MAC_DARWIN_TRUE@	done

 # Tell versions [3.59,3.63) of GNU make to not export all variables.
 # Otherwise a system limit (for SysV at least) may be exceeded.
