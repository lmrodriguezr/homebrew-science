class Geant4 < Formula
  desc "Simulation toolkit for particle transport through matter"
  homepage "http://geant4.cern.ch"
  url "http://geant4.cern.ch/support/source/geant4.10.03.p01.tar.gz"
  version "10.3.1"
  sha256 "78edab8298789b2bac4189f0864a2fb65f66ffdc50b7cb3335fafe2b1e70fd7d"

  bottle do
    cellar :any
    sha256 "b0bab9c38689f6b4b0ef9fbbce33d0e004dea936fa89e46de61c3f4deef4a6f4" => :sierra
    sha256 "7f506130046f21d7a135d1db4f19646028992e8e7d4a2d53fd482c4171ddcf5e" => :el_capitan
    sha256 "5b66fc8fd0efeaf54f498ab1b9b70b7f9ba21c843e56b753d5456f6889acf603" => :yosemite
    sha256 "d2452c9ef4c337d6963fc2e12ebd548a4dff9eaaefb7aead89291bfb11032ce5" => :x86_64_linux
  end

  option "with-g3tog4", "Use G3toG4 Library"
  option "with-gdml", "Use GDML"
  option "with-usolids", "Use USolids (experimental)"
  option "without-multithreaded", "Build without multithreading support"

  depends_on "cmake" => :run
  depends_on :x11
  depends_on "qt" => :optional
  depends_on "xerces-c" if build.with? "gdml"
  depends_on "linuxbrew/xorg/glu" unless OS.mac?

  resource "G4NEUTRONHPDATA" do
    url "http://geant4.cern.ch/support/source/G4NDL.4.5.tar.gz"
    sha256 "cba928a520a788f2bc8229c7ef57f83d0934bb0c6a18c31ef05ef4865edcdf8e"
  end

  resource "G4LEDATA" do
    url "http://geant4.cern.ch/support/source/G4EMLOW.6.50.tar.gz"
    sha256 "c97be73fece5fb4f73c43e11c146b43f651c6991edd0edf8619c9452f8ab1236"
  end

  resource "G4LEVELGAMMADATA" do
    url "http://geant4.cern.ch/support/source/G4PhotonEvaporation.4.3.2.tar.gz"
    sha256 "d4641a6fe1c645ab2a7ecee09c34e5ea584fb10d63d2838248bfc487d34207c7"
  end

  resource "G4RADIOACTIVEDATA" do
    url "http://geant4.cern.ch/support/source/G4RadioactiveDecay.5.1.1.tar.gz"
    sha256 "f7a9a0cc998f0d946359f2cb18d30dff1eabb7f3c578891111fc3641833870ae"
  end

  resource "G4NEUTRONXSDATA" do
    url "http://geant4.cern.ch/support/source/G4NEUTRONXS.1.4.tar.gz"
    sha256 "57b38868d7eb060ddd65b26283402d4f161db76ed2169437c266105cca73a8fd"
  end

  resource "G4PIIDATA" do
    url "http://geant4.cern.ch/support/source/G4PII.1.3.tar.gz"
    sha256 "6225ad902675f4381c98c6ba25fc5a06ce87549aa979634d3d03491d6616e926"
  end

  resource "G4REALSURFACEDATA" do
    url "http://geant4.cern.ch/support/source/RealSurface.1.0.tar.gz"
    sha256 "3e2d2506600d2780ed903f1f2681962e208039329347c58ba1916740679020b1"
  end

  resource "G4SAIDXSDATA" do
    url "http://geant4.cern.ch/support/source/G4SAIDDATA.1.1.tar.gz"
    sha256 "a38cd9a83db62311922850fe609ecd250d36adf264a88e88c82ba82b7da0ed7f"
  end

  resource "G4ABLADATA" do
    url "http://geant4.cern.ch/support/source/G4ABLA.3.0.tar.gz"
    sha256 "99fd4dcc9b4949778f14ed8364088e45fa4ff3148b3ea36f9f3103241d277014"
  end

  resource "G4ENSDFSTATEDATA" do
    url "http://geant4.cern.ch/support/source/G4ENSDFSTATE.2.1.tar.gz"
    sha256 "933e7f99b1c70f24694d12d517dfca36d82f4e95b084c15d86756ace2a2790d9"
  end

  def install
    (share/"Geant4-#{version}/data/G4NDL4.5").install resource("G4NEUTRONHPDATA")
    (share/"Geant4-#{version}/data/G4EMLOW6.50").install resource("G4LEDATA")
    (share/"Geant4-#{version}/data/PhotonEvaporation4.3").install resource("G4LEVELGAMMADATA")
    (share/"Geant4-#{version}/data/RadioactiveDecay5.1").install resource("G4RADIOACTIVEDATA")
    (share/"Geant4-#{version}/data/G4NEUTRONXS1.4").install resource("G4NEUTRONXSDATA")
    (share/"Geant4-#{version}/data/G4PII1.3").install resource("G4PIIDATA")
    (share/"Geant4-#{version}/data/RealSurface1.0").install resource("G4REALSURFACEDATA")
    (share/"Geant4-#{version}/data/G4SAIDDATA1.1").install resource("G4SAIDXSDATA")
    (share/"Geant4-#{version}/data/G4ABLA3.0").install resource("G4ABLADATA")
    (share/"Geant4-#{version}/data/G4ENSDFSTATE2.1").install resource("G4ENSDFSTATEDATA")

    mkdir "geant-build" do
      args = %w[
        ../
        -DGEANT4_USE_OPENGL_X11=ON
        -DGEANT4_USE_RAYTRACER_X11=ON
        -DGEANT4_BUILD_EXAMPLE=ON
      ]

      args << "-DGEANT4_USE_QT=ON" if build.with? "qt"
      args << "-DGEANT4_USE_G3TOG4=ON" if build.with? "g3tog4"
      args << "-DGEANT4_USE_GDML=ON" if build.with? "gdml"
      args << "-DGEANT4_USE_USOLIDS=ON" if build.with? "usolids"
      args << "-DGEANT4_BUILD_MULTITHREADED=ON" if build.with? "multithreaded"
      args.concat(std_cmake_args)
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    system "cmake", share/"Geant4-#{version}/examples/basic/B1"
    system "make"
    (testpath/"test.sh").write <<-EOS.undent
      . #{bin}/geant4.sh
      ./exampleB1 run2.mac
    EOS
    system "/bin/bash", "test.sh"
  end
end
