# vim: ts=2 sw=2 sts=2

require_relative './epics-base'

class EpicsStream < Formula
  desc "EPICS Driver for message based I/O"
  homepage "http://epics.web.psi.ch/software/streamdevice/"
  url "https://github.com/epics-modules/stream/archive/R2-6c.tar.gz"
  version "2-6c"
  sha256 "9af8437d6a900707d3e3d085f60dd98e28f1bef2201722e820b1a1ff4f8a1445"

  depends_on "epics-asyn"
  depends_on "epics-sscan"
  depends_on "epics-calc"

  def install
    asyn_path = get_package_prefix('epics-asyn')
    calc_path = get_package_prefix('epics-calc')
    sscan_path = get_package_prefix('epics-sscan')
    system("make", 
           "ASYN=#{asyn_path}",
           "CALC=#{calc_path}",
           "SSCAN=#{sscan_path}",
           "INSTALL_LOCATION=#{prefix}", 
           *get_epics_make_variables())

    wrap_epics_binaries()
  end

  test do
    # system "echo exit | mcaAIM"
  end
end
