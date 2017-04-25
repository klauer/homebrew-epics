# vim: ts=2 sw=2 sts=2

require_relative './epics-base'

class PyepicsTestIoc < Formula
  desc "PyEpics test IOC"
  homepage "https://github.com/pyepics/"
	head "https://github.com/pyepics/testioc.git", :tag => "master"
  version "0-1"

  depends_on "epics-base"
  depends_on "epics-asyn"
  depends_on "epics-sscan"
  depends_on "epics-calc"
  depends_on "wget"

  def install
    epics_host_arch = get_epics_host_arch()
    inreplace "testiocApp/src/Makefile", "testioc", "pyepics_testioc"
    inreplace "testiocApp/src/Makefile", "pyepics_testiocMain.cpp", "softiocMain.cpp"
    inreplace "iocBoot/iocTestioc/Makefile", "linux-x86_64", epics_host_arch

    system("wget", 
           "https://raw.githubusercontent.com/epics-base/epics-base/723ccf683bf720e2780c9bdf887f726111e60aa1/src/softIoc/softMain.cpp",
           "-O", "testiocApp/src/softiocMain.cpp")
  
    inreplace "testiocApp/src/softiocMain.cpp", "softIoc_registerRecordDeviceDriver", "pyepics_testioc_registerRecordDeviceDriver"

    Pathname("configure/RELEASE").unlink()
    Pathname("configure/RELEASE").write <<-EOS.undent
    EPICS_BASE=#{get_package_prefix('epics-base')}
    ASYN=#{get_package_prefix('epics-asyn')}
    SSCAN=#{get_package_prefix('epics-sscan')}
    CALC=#{get_package_prefix('epics-calc')}
    EOS
    
    system("make",
           "INSTALL_LOCATION=#{prefix}", 
           *get_epics_make_variables())


    ioc_script = bin/"#{epics_host_arch}/pyepics_testioc-run.sh"
    Pathname(ioc_script).write <<-EOS.undent
    #!/bin/bash
    pyepics_testioc -D #{prefix}/dbd/pyepics_testioc.dbd -m "P=Py:" -d #{prefix}/db/pydebug.db
    EOS

    FileUtils.chmod 0777, Pathname(ioc_script)

    wrap_epics_binaries()
  end

  test do
    system "echo exit | testIoc"
  end
end
