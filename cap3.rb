class Cap3 < Formula
  homepage "http://seq.cs.iastate.edu/cap3.html"
  if OS.mac? then
    url "http://seq.cs.iastate.edu/CAP3/cap3.macosx.intel64.tar"
    sha256 "4b6e8fa6b39147b23ada6add080854ea9fadace9a9c8870a97ac79ff1c75338e"
  elsif OS.linux? then
    url "http://seq.cs.iastate.edu/CAP3/cap3.linux.x86_64.tar"
    sha256 "3aff30423e052887925b32f31bdd76764406661f2be3750afbf46341c3d38a06"
  end
  version "2015-02-11"

  def install
    bin.install "cap3", "formcon"
    doc.install %w[README aceform doc example]
  end

  test do
    system "cap3 2>&1 |grep -q cap3"
  end
end
