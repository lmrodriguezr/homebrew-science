class Scotch < Formula
  homepage "https://gforge.inria.fr/projects/scotch"
  url "https://gforge.inria.fr/frs/download.php/file/34099/scotch_6.0.4.tar.gz"
  sha256 "6461cc9f28319a9dbe6cc10e28c0cbe90b4b25e205723c3edcde9a3ff974d6d8"
  revision 1

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "1e8625ed27ad1e9326acea04e570e41c7cc42b7373991dd8db7e45fa213a13aa" => :yosemite
    sha256 "12ab21d4df72976c5aa82c9d5aace2d8c8b2b30b2a92344ee5a74399e5383d54" => :mavericks
    sha256 "21752692104035f6ce6125a97124d38bc0f161730180bbe3bcd1c6582621886b" => :mountain_lion
  end

  option "without-check", "skip build-time tests (not recommended)"

  depends_on :mpi => :cc
  depends_on "xz" => :optional # Provides lzma compression.

  patch :DATA

  def install
    cd "src" do
      ln_s "Make.inc/Makefile.inc.i686_mac_darwin8", "Makefile.inc"

      cflags   = %w[-O3 -fPIC -Drestrict=__restrict -DCOMMON_PTHREAD_BARRIER
                    -DSCOTCH_CHECK_AUTO -DCOMMON_RANDOM_FIXED_SEED
                    -DCOMMON_TIMING_OLD -DSCOTCH_RENAME
                    -DCOMMON_FILE_COMPRESS_BZ2 -DCOMMON_FILE_COMPRESS_GZ]
      ldflags  = %w[-lm -lz -lbz2]

      cflags  += %w[-DCOMMON_FILE_COMPRESS_LZMA]   if build.with? "xz"
      ldflags += %W[-L#{Formula["xz"].lib} -llzma] if build.with? "xz"

      make_args = ["CCS=#{ENV["CC"]}",
                   "CCP=#{ENV["MPICC"]}",
                   "CCD=#{ENV["MPICC"]}",
                   "LIB=.dylib",
                   "AR=libtool",
                   "ARFLAGS=-dynamic -install_name #{lib}/$(notdir $@) -undefined dynamic_lookup -o ",
                   "RANLIB=echo",
                   "CFLAGS=#{cflags.join(" ")}",
                   "LDFLAGS=#{ldflags.join(" ")}"]

      system "make", "scotch", "VERBOSE=ON", *make_args
      system "make", "ptscotch", "VERBOSE=ON", *make_args
      system "make", "install", "prefix=#{prefix}", *make_args
      system "make", "check", "ptcheck", "EXECP=mpirun -np 2", *make_args if build.with? "check"
    end

    # Install documentation + sample graphs and grids.
    doc.install Dir["doc/*"]
    (share / "scotch").install "grf", "tgt"
  end

  test do
    mktemp do
      system "echo cmplt 7 | #{bin}/gmap #{share}/scotch/grf/bump.grf.gz - bump.map"
      system "#{bin}/gmk_m2 32 32 | #{bin}/gmap - #{share}/scotch/tgt/h8.tgt brol.map"
      system "#{bin}/gout -Mn -Oi #{share}/scotch/grf/4elt.grf.gz #{share}/scotch/grf/4elt.xyz.gz - graph.iv"
    end
  end
end

__END__
diff --git a/src/check/test_common_thread.c b/src/check/test_common_thread.c
index 8327bc7..a1d4243 100644
--- a/src/check/test_common_thread.c
+++ b/src/check/test_common_thread.c
@@ -197,11 +197,11 @@ char *              argv[])
     errorPrint ("main: cannot launch or run threads");
     return     (1);
   }
+
+  free (thrdtab);
 #else /* ((defined COMMON_PTHREAD) || (defined SCOTCH_PTHREAD)) */
   printf ("Scotch not compiled with either COMMON_PTHREAD or SCOTCH_PTHREAD\n");
 #endif /* ((defined COMMON_PTHREAD) || (defined SCOTCH_PTHREAD)) */
 
-  free (thrdtab);
-
   return (0);
 }
