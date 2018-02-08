# vim: ts=2 sw=2 sts=2

require_relative './epics-base'

class EpicsStream < Formula
  desc "EPICS Driver for message based I/O"
  homepage "http://epics.web.psi.ch/software/streamdevice/"
  url "https://github.com/paulscherrerinstitute/StreamDevice/archive/stream_2_7_7.tar.gz"
  version "2-7-7"
  sha256 "255ee6ab872f9a27b37e3633d29cbe3ebbcd2b1c80a8e13e09ebb8957eb1a34e"

  depends_on "epics-asyn"
  depends_on "epics-sscan"
  depends_on "epics-calc"

  def install
    paths = {:ASYN=>get_package_prefix('epics-asyn'),
             :CALC=>get_package_prefix('epics-calc'),
             :SSCAN=>get_package_prefix('epics-sscan'),
             }
    
    fix_epics_release_file(paths)
    system("make",
           "INSTALL_LOCATION=#{prefix}", 
           *get_epics_make_variables())

    wrap_epics_binaries()
  end

  test do
    # system "echo exit | mcaAIM"
  end
end
