class Dwgsim < Formula
  homepage "https://github.com/nh13/DWGSIM"
  url "https://github.com/nh13/DWGSIM.git",
    :tag => "dwgsim.0.1.11",
    :revision => "49aa199775e0d8bc1fee79aec7117a7fde8cb2bf"
  head "https://github.com/nh13/DWGSIM.git"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "fa90c65c4e4b60e4f5393459012764bee2a17d59b714a6ff6ee155bdc5f9e99b" => :yosemite
    sha256 "bf3ee48fcf6e92be1dcb615d2a619f6737856e12ada59f6e896546fe596bcefe" => :mavericks
    sha256 "db114d69ac843ee4d3bc4e1d599091cc691b0a945252c1a429987a3802c2a61c" => :mountain_lion
    sha256 "77fda3da399617f36d84d0bac71f58e9900ca3d0ee3182f2999fd07ba1b29994" => :x86_64_linux
  end

  unless OS.mac?
    # dwgsim builds a vendored copy of samtools, which requires ncurses.
    depends_on "ncurses" => :build
    depends_on "zlib"
  end

  def install
    system "make"
    bin.install "dwgsim", "dwgsim_eval"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/dwgsim -h 2>&1", 1)
  end
end
