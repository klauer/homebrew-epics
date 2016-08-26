# vim: ts=2 sw=2 sts=2

require './epics-base'

class EpicsAutosave < Formula
  desc "APS BCDA synApps module: autosave"
  homepage "http://www.aps.anl.gov/bcda/synApps"
  url "https://github.com/epics-modules/autosave/archive/R5-7-1.tar.gz"
  version "5-7-1"
  sha256 "1f4796bf8af1303a022a75053bb848c4cc541f3aedf87dad03d59b1f7c1e49e1"

  depends_on "epics-base"

  def install
    system("make", "INSTALL_LOCATION=#{prefix}", *get_epics_make_variables())
    wrap_epics_binaries()
  end

  test do
    system "echo exit | asApp"
    # system "asVerify -h"
  end
end
