# vim: ts=2 sw=2 sts=2

require_relative './epics-base'

class EpicsSscan < Formula
  desc "APS BCDA synApps module: sscan"
  homepage "http://www.aps.anl.gov/bcda/synApps"
  url "https://github.com/epics-modules/sscan/archive/R2-10-2.tar.gz"
  version "2-10-2"
  sha256 "7b02f3c2a46dea064d1b61947711eb0f65f6e7c6dead9be2ceedc5d26531d67b"

  depends_on "epics-base"
  depends_on "epics-seq"

  def install
    sncseq_path = get_package_prefix('epics-seq')
  
    system("make", "SNCSEQ=#{sncseq_path}",
           "INSTALL_LOCATION=#{prefix}", 
           *get_epics_make_variables())

    # no binaries to wrap
    # wrap_epics_binaries()
  end

  test do
    system "true"
  end
end
