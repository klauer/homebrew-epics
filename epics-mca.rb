# vim: ts=2 sw=2 sts=2

require_relative './epics-base'

class EpicsMca < Formula
  desc "APS BCDA synApps module: mca"
  homepage "http://www.aps.anl.gov/bcda/synApps"
  url "https://github.com/epics-modules/mca/archive/R7-6.tar.gz"
  version "7-6"
  sha256 "07cc684829a7bba83ee4702feadd8d9a31ff79a41ea7f4c6c4dfb213b305e127"

  depends_on "libnet"
  depends_on "epics-base"
  depends_on "epics-asyn"
  depends_on "epics-sscan"
  depends_on "epics-calc"
  depends_on "epics-busy"
  depends_on "epics-autosave"
  depends_on "epics-std"

  def install
    asyn_path = get_package_prefix('epics-asyn')
    calc_path = get_package_prefix('epics-calc')
    sscan_path = get_package_prefix('epics-sscan')
    busy_path = get_package_prefix('epics-busy')
    autosave_path = get_package_prefix('epics-autosave')
    std_path = get_package_prefix('epics-std')
    system("make", 
           "ASYN=#{asyn_path}",
           "CALC=#{calc_path}",
           "SSCAN=#{sscan_path}",
           "BUSY=#{busy_path}",
           "AUTOSAVE=#{autosave_path}",
           "STD=#{std_path}",
           "INSTALL_LOCATION=#{prefix}", 
           *get_epics_make_variables())

    wrap_epics_binaries()
  end

  test do
    system "echo exit | mcaRontecApp"
    system "echo exit | mcaAIM"
  end
end
