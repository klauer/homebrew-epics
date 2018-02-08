# vim: ts=2 sw=2 sts=2

require_relative './epics-base'

class EpicsAsyn < Formula
  desc "epics-asyn, asynchronous driver support"
  homepage "http://www.aps.anl.gov/epics/modules/soft/asyn/"
  url "https://github.com/epics-modules/asyn/archive/R4-30.tar.gz"
  version "4-30"
  sha256 "306aa699735e18e62e78f17deab24cb7e08073db070980f59e04f71b9e83352f"

  depends_on "epics-base"
  depends_on "epics-seq"

  def install
    paths = {:SNCSEQ=>get_package_prefix('epics-seq'),
             :IPAC=>'',
             }
    
    fix_epics_release_file(paths)
    system("make", "INSTALL_LOCATION=#{prefix}",
           *get_epics_make_variables())

    host_arch = get_epics_host_arch()
    File.unlink bin/"#{host_arch}/test"
    wrap_epics_binaries() # , :skip_names=['test'])
  end

  test do
    system "echo exit | testAsynPortDriver"
    system "echo exit | testIPServer"
    system "testAsynIPPortClient"
  end
end
