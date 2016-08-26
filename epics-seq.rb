# vim: ts=2 sw=2 sts=2

require './epics-base'

class EpicsSeq < Formula
  desc "State Notation Language and Sequencer"
  homepage "http://www-csr.bessy.de/control/SoftDist/sequencer/"
  url "http://www-csr.bessy.de/control/SoftDist/sequencer/releases/seq-2.2.3.tar.gz"
  version "2.2.3"
  sha256 "9011ba44a52ccb68cc8a312bddc6a6276344612d026b27e1f3c21a0a44a2e229"

  depends_on "epics-base"
  depends_on "re2c"

  def install
    system("make", "INSTALL_LOCATION=#{prefix}", 
           *get_epics_make_variables())

    wrap_epics_binaries()
  end

  test do
    system "true"
  end
end
