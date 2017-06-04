class GraphTool < Formula
  desc "efficient network analysis"
  homepage "https://graph-tool.skewed.de/"
  url "https://downloads.skewed.de/graph-tool/graph-tool-2.22.tar.bz2"
  sha256 "57121b562763c79c138b3a385b8cddb59e7dec375c61e00ca7e9e96fd1a5e080"
  revision 2

  bottle do
    sha256 "ada3dc63452d56a205a1a35f2233f579908d62eb549553d9f28de78c59c99a11" => :sierra
    sha256 "e8401ad908c6dc4a251535a4d4dc1b75b2b9d45d542cf504375ebf455ef565c7" => :el_capitan
  end

  head do
    url "https://git.skewed.de/count0/graph-tool.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3b7bcf4f4a71d8f0b3062c08c378cc20089d6b4b/graph-tool/chrono-disambiguation.diff"
    sha256 "1c1a8b8bcb3f67856d45f2707ac3924e68ecddffee909a88c8a74a547ffe43df"
  end

  option "without-cairo", "Build without cairo support for plotting"
  option "without-gtk+3", "Build without gtk+3 support for interactive plotting"
  option "without-matplotlib", "Use a matplotlib you've installed yourself instead of a Homebrew-packaged matplotlib"
  option "without-numpy", "Use a numpy you've installed yourself instead of a Homebrew-packaged numpy"
  option "without-python", "Build without python2 support"
  option "without-scipy", "Use a scipy you've installed yourself instead of a Homebrew-packaged scipy"
  option "with-openmp", "Enable OpenMP multithreading"

  # Yosemite build fails with Boost >=1.64.0 due to thread-local storage error
  depends_on :macos => :el_capitan

  depends_on :python3 => :optional
  with_pythons = build.with?("python3") ? ["with-python3"] : []

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python" => with_pythons
  depends_on "cairomm" if build.with? "cairo"
  depends_on "cgal"
  depends_on "google-sparsehash" => :recommended
  depends_on "gtk+3" => :recommended

  depends_on "numpy" => [:recommended] + with_pythons
  depends_on "scipy" => [:recommended] + with_pythons
  depends_on "matplotlib" => [:recommended] + with_pythons

  if build.with? "cairo"
    depends_on "py2cairo" if build.with? "python"
    depends_on "py3cairo" if build.with? "python3"
  end

  if build.with? "gtk+3"
    depends_on "gnome-icon-theme"
    depends_on "librsvg" => "with-gtk+3"
    depends_on "pygobject3" => with_pythons
  end

  fails_with :gcc => "4.8" do
    cause "We need GCC 5.0 or above for sufficient c++14 support"
  end
  fails_with :gcc => "4.9" do
    cause "We need GCC 5.0 or above for sufficient c++14 support"
  end

  needs :openmp if build.with? "openmp"

  def install
    system "./autogen.sh" if build.head?

    config_args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    # fix issue with boost + gcc with C++11/C++14
    ENV.append "CXXFLAGS", "-fext-numeric-literals" unless ENV.compiler == :clang
    config_args << "--disable-cairo" if build.without? "cairo"
    config_args << "--disable-sparsehash" if build.without? "google-sparsehash"
    config_args << "--enable-openmp" if build.with? "openmp"

    Language::Python.each_python(build) do |python, version|
      config_args_x = ["PYTHON=#{python}"]
      if OS.mac?
        config_args_x << "PYTHON_LDFLAGS=-undefined dynamic_lookup"
        config_args_x << "PYTHON_LIBS=-undefined dynamic_lookup"
        config_args_x << "PYTHON_EXTRA_LIBS=-undefined dynamic_lookup"
      end
      config_args_x << "--with-python-module-path=#{lib}/python#{version}/site-packages"

      if python == "python3"
        inreplace "configure", "libboost_python", "libboost_python3"
        inreplace "configure", "ax_python_lib=boost_python", "ax_python_lib=boost_python3"
      end

      mkdir "build-#{python}-#{version}" do
        system "../configure", *(config_args + config_args_x)
        system "make", "install"
      end
    end
  end

  test do
    Pathname("test.py").write <<-EOS.undent
      import graph_tool.all as gt
      g = gt.Graph()
      v1 = g.add_vertex()
      v2 = g.add_vertex()
      e = g.add_edge(v1, v2)
    EOS
    Language::Python.each_python(build) { |python, _| system python, "test.py" }
  end
end
