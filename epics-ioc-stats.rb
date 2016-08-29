# vim: ts=2 sw=2 sts=2

require_relative './epics-base'

class EpicsIocStats < Formula
  desc "iocStats - EPICS IOC Status and Control"
  homepage "http://www.slac.stanford.edu/grp/ssrl/spear/epics/site/devIocStats/"
  url "https://github.com/epics-modules/iocStats/archive/3.1.14.tar.gz"
  version "3.1.14"
  sha256 "cb28a1301c3619f2074691474fbea9d8dd0d38b8b7a9d794276abc8a70ab0bd3"

  depends_on "epics-base"
  depends_on "epics-seq"
  depends_on "epics-msi"

  def install
    sncseq_path = get_package_prefix('epics-seq')
    system("make", "SNCSEQ=#{sncseq_path}", 
           "INSTALL_LOCATION=#{prefix}",
           # TODO
           "SNCSEQ_MODULE_VERSION=seq-R2-0-11",
           "MAKE_TEST_IOC_APP=NO",
           # TODO
           *get_epics_make_variables())

    wrap_epics_binaries()
  end

  test do
    # system "echo exit | testIocStatsApp"
  end
end
