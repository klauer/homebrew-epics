# vim: ts=2 sw=2 sts=2

require_relative './epics-base'

class EpicsStd < Formula
  desc "APS BCDA synApps module: std"
  homepage "http://www.aps.anl.gov/bcda/synApps"
  url "https://github.com/epics-modules/std/archive/R3-4-1.tar.gz"
  version "4-1"
  sha256 "7f17e0d58a5eb1fdbdf66c3df44e7295f4aefd922dbedfbe9a89ca18115b99fc"

  depends_on "epics-base"
  depends_on "epics-asyn"
  depends_on "epics-seq"

  def install
    paths = {:SNCSEQ=>get_package_prefix('epics-seq'),
             :ASYN=>get_package_prefix('epics-asyn'),
             }
    
    fix_epics_release_file(paths)
    system("make", "INSTALL_LOCATION=#{prefix}",
           *get_epics_make_variables())
    wrap_epics_binaries()
  end

  test do
    system "echo exit | stdApp"
  end
end
