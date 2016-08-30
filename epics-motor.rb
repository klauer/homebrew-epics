# vim: ts=2 sw=2 sts=2

require_relative './epics-base'

class EpicsMotor < Formula
  desc "APS BCDA synApps module: motor"
  homepage "http://www.aps.anl.gov/bcda/synApps/motor/index.html"
  url "https://github.com/epics-modules/motor/archive/R6-9.tar.gz"
  version "6-9"
  sha256 "3b33ccd72c41afffb8613867907760da18a0a0cf6ee0e486b6e738bb00c0997b"

  depends_on "epics-base"
  depends_on "epics-asyn"
  depends_on "epics-seq"

  def install
    # Sorry, no IPAC support
    inreplace "configure/RELEASE", /^IPAC=.*$/, "#IPAC="
    inreplace "motorApp/Makefile", /^DIRS \+= HytecSrc/, "# hytec requires ipac"

    paths = {:ASYN=>get_package_prefix('epics-asyn'),
             :SNCSEQ=>get_package_prefix('epics-seq'),
             }
    fix_epics_release_file(paths)

    system("make",
           "INSTALL_LOCATION=#{prefix}", 
           *get_epics_make_variables())

    wrap_epics_binaries()
  end

  test do
    system "echo exit | motorSim"
  end
end
