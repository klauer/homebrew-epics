# vim: ts=2 sw=2 sts=2

require './epics-base'

class EpicsBusy < Formula
  desc "APS BCDA synApps module: busy"
  homepage "http://www.aps.anl.gov/bcda/synApps"
  url "https://github.com/epics-modules/busy/archive/R1-6-1.tar.gz"
  version "6-1"
  sha256 "0d352a6722dad3aa9192660f91e72bcc9c26c44c6c18b6f331eee20bb93a6fd2"

  depends_on "epics-base"
  depends_on "epics-asyn"

  def install
    asyn_path = get_package_prefix('epics-asyn')
    system("make", "ASYN=#{asyn_path}",
           "INSTALL_LOCATION=#{prefix}", 
           *get_epics_make_variables())

    wrap_epics_binaries()
  end

  test do
    system "true"
  end
end
