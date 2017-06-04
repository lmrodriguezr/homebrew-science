class Circlator < Formula
  include Language::Python::Virtualenv

  desc "Tool to circularize genome assemblies"
  homepage "https://sanger-pathogens.github.io/circlator/"
  url "https://github.com/sanger-pathogens/circlator/archive/v1.5.1.tar.gz"
  sha256 "de9707e28adc40d5268a83ccf56294d81269651013f4607f6a4c9ae32a972564"
  head "https://github.com/sanger-pathogens/circlator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "48e4a02b6543b48fc13ccad7ec9e73829c495edd90d09299d6b89628ce4418b5" => :sierra
    sha256 "8fc96e889494fb8bba2d164c439626dddef52bdaa618039106aa06e93675fe45" => :el_capitan
    sha256 "255dad19161ed4e9d982b31337845e34b7b4ef34f296078579a982ac55087404" => :yosemite
    sha256 "92531a6d06b4d0e1841ceb87a49ff5102a8843fe5f0e4f8843a407586923b6c6" => :x86_64_linux
  end

  # tag "bioinformatics"

  depends_on :python3
  depends_on "bwa"
  depends_on "mummer"
  depends_on "prodigal"
  depends_on "samtools"
  depends_on "spades"
  depends_on "zlib" unless OS.mac?

  resource "et_xmlfile" do
    url "https://files.pythonhosted.org/packages/22/28/a99c42aea746e18382ad9fb36f64c1c1f04216f41797f2f0fa567da11388/et_xmlfile-1.0.1.tar.gz"
    sha256 "614d9722d572f6246302c4491846d2c393c199cfa4edc9af593437691683335b"
  end

  resource "jdcal" do
    url "https://files.pythonhosted.org/packages/9b/fa/40beb2aa43a13f740dd5be367a10a03270043787833409c61b79e69f1dfd/jdcal-1.3.tar.gz"
    sha256 "b760160f8dc8cc51d17875c6b663fafe64be699e10ce34b6a95184b5aa0fdc9e"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/dc/f2/c57f9f00f8ae5e1a73cb096dbf600433724f037ffcbd51c456f89da5efd9/openpyxl-2.4.1.tar.gz"
    sha256 "836e66578320e5871baa5a958c7acb7dcbc1b508989a675276b20ac2e1c08d82"
  end

  resource "pyfastaq" do
    url "https://files.pythonhosted.org/packages/0e/5d/8b39442b62c43da835c89f4c244d037bc7fcd8b47b0c0fff6e8d9097a035/pyfastaq-3.14.0.tar.gz"
    sha256 "54dc8cc8b3d24111f6939cf563833b8e9e78777b9cf7b82ca8ddec04aa1c05f2"
  end

  resource "pymummer" do
    url "https://files.pythonhosted.org/packages/96/04/a67728a727a8214de494b06178bfaca025550156889953d581a141976ec0/pymummer-0.10.1.tar.gz"
    sha256 "04a06d2faecf5b972b3a60e1493520e384cb10dd5c00bf7d643a1d059c4e8f87"
  end

  resource "pysam" do
    url "https://files.pythonhosted.org/packages/27/89/bf8c44d0bfe9d0cadab062893806994c168c9f490f67370fc56d6e8ba224/pysam-0.8.4.tar.gz"
    sha256 "30cf23931edf8a426678811f234bca4a83a53438028b323f2ef55792562d9dea"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/circlator test outdir")
    assert_match "Finished run on test data OK", output
  end
end
