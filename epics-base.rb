class EpicsBase < Formula
  desc "Experimental Physics and Industrial Control System"
  homepage "http://www.aps.anl.gov/epics"
  url "https://www.aps.anl.gov/epics/download/base/baseR3.14.12.5.tar.gz"
  version "3.14.12.5"
  sha256 "ef05593edb70c87d6ae02c3e1e7c4f3f325934f1b98deaba49203d9343861d72"

  depends_on "perl"
  depends_on "readline"

  def install
    # ENV.deparallelize
    
    # set the install location to the proper directory
    inreplace "configure/CONFIG_SITE", "#INSTALL_LOCATION=<fullpathname>", "INSTALL_LOCATION=#{prefix}"
    
    system "make", "install"
    
    # get the host architecture for the directories
    epics_host_arch = `perl startup/EpicsHostArch.pl`

    system "echo", "Host architecture is: #{epics_host_arch}"
    
    lib.install_symlink Dir["#{lib}/#{epics_host_arch}/*"]

    # necessary environment variables for EPICS binaries
    epics_env = {:EPICS_HOST_ARCH => "#{epics_host_arch}",
                 :EPICS_BASE => prefix,
                 :EPICS_EXTENSIONS => prefix/"extensions",
                }

    # wrap all binaries with env scripts (bin/caget script -> bin/host_arch/caget)
    Pathname.glob(bin/"#{epics_host_arch}/*") do |file|
      next if file.directory?
      (bin+file.basename).write_env_script(file, epics_env)
    end

    # a script that one could source to get the proper environment variables
    Pathname(bin/"epics_env.sh").write <<-EOS.undent
    #!/bin/bash
    export EPICS_HOST_ARCH=#{epics_host_arch}
    export EPICS_BASE=#{prefix}
    export EPICS_EXTENSIONS=#{prefix}/extensions
    EOS
  end

  test do
    system "caget", "-h"
    system "caput", "-h"
  end
end
