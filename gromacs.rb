class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "ftp://ftp.gromacs.org/pub/gromacs/gromacs-5.1.4.tar.gz"
  mirror "https://fossies.org/linux/privat/gromacs-5.1.4.tar.gz"
  sha256 "0f3793d8f1f0be747cf9ebb0b588fb2b2b5dc5acc32c3046a7bee2d2c03437bc"
  # tag "chemistry"
  # doi "10.1016/0010-4655(95)00042-E"

  bottle do
    sha256 "d656c66147f490bfc10b9ff6614a5910a257274dd31971601692effbdf35a504" => :sierra
    sha256 "e1077fc5af5958144360b7362cc5b06ce8bdecca7c42db615479b1ea1dc88e09" => :el_capitan
    sha256 "b5d24da6150c2e44b5eb038ad623dae7a7ce4144fd1e152c1dc2db6f61c5c64a" => :yosemite
    sha256 "0cb8624cba507f8461d08ee1309ced4a9efb7cbc71461f5234bcfe88be07f956" => :x86_64_linux
  end

  deprecated_option "with-x" => "with-x11"
  deprecated_option "enable-mpi" => "with-mpi"
  deprecated_option "enable-double" => "with-double"
  deprecated_option "without-check" => "without-test"

  option "with-double", "Enables double precision"
  option "without-test", "Skip build-time tests (not recommended)"

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gsl" => :recommended
  depends_on :mpi => :optional
  depends_on :x11 => :optional

  def install
    args = std_cmake_args
    args << "-DGMX_GSL=ON" if build.with? "gsl"
    args << "-DGMX_MPI=ON" if build.with? "mpi"
    args << "-DGMX_DOUBLE=ON" if build.include? "enable-double"
    args << "-DGMX_X11=ON" if build.with? "x11"
    args << "-DGMX_CPU_ACCELERATION=None" if MacOS.version <= :snow_leopard
    args << "-DREGRESSIONTEST_DOWNLOAD=ON" if build.with? "check"

    inreplace "scripts/CMakeLists.txt", "BIN_INSTALL_DIR", "DATA_INSTALL_DIR"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "check" if build.with? "check"
      ENV.deparallelize
      system "make", "install"
    end

    bash_completion.install "build/scripts/GMXRC" => "gromacs-completion.bash"
    bash_completion.install "#{bin}/gmx-completion-gmx.bash" => "gmx-completion-gmx.bash"
    bash_completion.install "#{bin}/gmx-completion.bash" => "gmx-completion.bash"
    zsh_completion.install "build/scripts/GMXRC.zsh" => "_gromacs"
  end

  def caveats; <<-EOS.undent
    GMXRC and other scripts installed to:
      #{HOMEBREW_PREFIX}/share/gromacs
    EOS
  end

  test do
    system "#{bin}/gmx", "help"
  end
end
