class Omcompiler < Formula
  desc "Modelica compiler translating Modelica to C code"
  homepage "https://www.openmodelica.org"
  url "https://github.com/OpenModelica/OMCompiler.git",
      :tag => "v1.9.6",
      :revision => "d3c35c90b382998275f42eb5da05c0f25e6b63a8"
  revision 1

  bottle do
    sha256 "ad536caec332f444d77712cd5de788bf09f86cf35fc6014a3e8c7b4170447cdf" => :sierra
    sha256 "0da439596e39213f1a020f38cf8233b91aa093c40557bd038461d40467cfe4d3" => :el_capitan
    sha256 "6c9c499a9841599ca824e8609adfee75d2d2f63c69c27d93e5b66c60a26707aa" => :yosemite
  end

  # Build dependencies
  depends_on "autoconf"     => :build
  depends_on "automake"     => :build
  depends_on "cmake"        => :build
  depends_on "libtool"      => :build
  depends_on "pkg-config"   => :build
  depends_on "gnu-sed"      => :build
  depends_on "xz"           => :build

  # Essential dependencies
  depends_on :fortran
  depends_on "lp_solve"
  depends_on "hwloc"
  depends_on "gettext"

  # Optional dependencies
  depends_on "boost"    => :optional
  depends_on "sundials" => :optional

  def install
    # The '-r' option seems to be missing. Without it the build process will
    # fail trying to copy a directory.
    inreplace "Makefile.common", "# Shared data\n\tcp -p",
                                 "# Shared data\n\tcp -rp"

    system "autoconf"

    args = ["--disable-debug"]
    args << "--disable-dependency-tracking"
    args << "--disable-silent-rules"
    args << "--prefix=#{prefix}"
    args << "--with-cppruntime" if build.with? "boost"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    # Define the Van der Pol equation as a simple model. Translate it to C code
    # (with 'omc'), compile the C code and execute the resulting program.
    str = "
        model VanDerPol  \"Van der Pol oscillator model\"
            Real x(start = 1);
            Real y(start = 1);
            parameter Real lambda = 0.3;
        equation
            der(x) = y;
            der(y) = - x + lambda*(1 - x*x)*y;
        end VanDerPol;
    "
    (testpath/"VanDerPol.mo").write str
    system "#{bin}/omc", "-s", "VanDerPol.mo"
    system "make", "-f", "VanDerPol.makefile"
    system "./VanDerPol"
  end
end
