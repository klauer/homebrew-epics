# vim: ts=2 sw=2 sts=2 nowrap
# TODO partially broken installation process for extensions
#
require_relative './epics-base'

class EpicsMsi < Formula
  desc "Macro Substitution and Include Tool"
  homepage "http://www.aps.anl.gov/epics/extensions/msi/"
  url "https://epics.anl.gov/download/extensions/msi1-7.tar.gz"
  version "1-7"
  sha256 "040cb5d3fbab85925e5edc5b658792b16a17b4b825198fa1b95ac8eaa2a6cef6"

  depends_on "epics-base"

  def install
    epics_host_arch = get_epics_host_arch()
    mkdir_p bin/"#{epics_host_arch}"
    mkdir_p doc

    ext_path = get_epics_extension_path()
    system("make", "TOP=#{ext_path}",
           "INSTALL_LOCATION=" + get_package_prefix('epics-base'),
           *get_epics_make_variables(),
           "install")

    # TODO this is bad... but change INSTALL_LOCATION to bin and get:
    # make[1]: *** No rule to make target `/usr/local/Cellar/epics-msi/1-7/bin/darwin-x86/lib/darwin-x86/libCom.a', needed by `msi'.  Stop.
    #
    # mock up how normal libraries are installed: bin/host_arch/msi

    # msi installs to epics-base directory... install then delete it *cough*
    epics_base_path = get_package_prefix('epics-base')
    base_install_path = epics_base_path/"bin/#{epics_host_arch}/msi"
    (bin/epics_host_arch).install(base_install_path)
    
    # and html docs
    doc.install(epics_base_path/"html/msi.html")
    
    # and test files
    pkgshare.install(Pathname.glob("test*"))
  
    # wrap it so dylibs can be found
    wrap_epics_binaries()
  end

  test do
    cd pkgshare
    system "pwd"
    system "msi", "-M a=1,b=2", pkgshare/"testfile"
  end
end
