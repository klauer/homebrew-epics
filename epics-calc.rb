# vim: ts=2 sw=2 sts=2

require './epics-base'

class EpicsCalc < Formula
  desc "APS BCDA synApps module: calc"
  homepage "http://www.aps.anl.gov/bcda/synApps"
  url "https://github.com/epics-modules/calc/archive/R3-6-1.tar.gz"
  version "3-6-1"
  sha256 "e3dd852e4cad5c5ed8896f9972ddcdbd5377574f51ec1d3212e54452baba5e77"

  depends_on "epics-base"
  depends_on "epics-seq"
  depends_on "epics-sscan"

  def install
    sncseq_path = get_package_prefix('epics-seq')
    sscan_path = get_package_prefix('epics-sscan')
  
    system("make", "SNCSEQ=#{sncseq_path}", "ASYN=#{asyn_path}",
           "INSTALL_LOCATION=#{prefix}", 
           *get_epics_make_variables())

    wrap_epics_binaries()
  end

  test do
    # system "echo exit | cal"
  end
end
