# vim: ts=2 sw=2 sts=2

class EpicsBase < Formula
  desc "Experimental Physics and Industrial Control System"
  homepage "http://www.aps.anl.gov/epics"
  url "https://www.aps.anl.gov/epics/download/base/baseR3.14.12.5.tar.gz"
  version "3.14.12.5"
  sha256 "ef05593edb70c87d6ae02c3e1e7c4f3f325934f1b98deaba49203d9343861d72"

  resource "extensions_top" do
    url "https://www.aps.anl.gov/epics/download/extensions/extensionsTop_20120904.tar.gz"
    sha256 "5f2f3953c3bffba735d6b57614fd05068b1295b28ed55fd1e1b85157dbc5808d"
  end

  depends_on "perl"
  depends_on "readline"

  def install
    # ENV.deparallelize
    resource("extensions_top").stage {
      (prefix/"extensions").install Dir['*']
    }

    inreplace prefix/"extensions/configure/RELEASE", "EPICS_BASE=$(TOP)/../base", "EPICS_BASE=#{prefix}"

    system "make", "install", "INSTALL_LOCATION=#{prefix}"

    # get the host architecture for the directories
    epics_host_arch = `perl startup/EpicsHostArch.pl`

    system "echo", "Host architecture is: #{epics_host_arch}"
    
    lib.install_symlink Dir["#{lib}/#{epics_host_arch}/*"]
    
    # extracted from the extensions archive
    ext_path = prefix/"extensions"

    # necessary environment variables for EPICS binaries
    epics_env = {:EPICS_HOST_ARCH => "#{epics_host_arch}",
                 :EPICS_BASE => prefix,
                 :EPICS_EXTENSIONS => ext_path,
                }

    # wrap all binaries with env scripts (bin/caget script -> bin/host_arch/caget)
    # wrap_epics_binaries(epics_host_arch, epics_env)
    # utility functions below not in scope in this formula?
    $stderr.printf("Wrapping binaries in %s\n", bin/"#{epics_host_arch}/*")
    Pathname.glob(bin/"#{epics_host_arch}/*") do |file|
      next if file.directory?
      (bin+file.basename).write_env_script(file, epics_env)
    end

    # a script that one could source to get the proper environment variables
    Pathname(bin/"epics_env.sh").write <<-EOS.undent
    #!/bin/bash
    export EPICS_HOST_ARCH=#{epics_host_arch}
    export EPICS_BASE=#{prefix}
    export EPICS_EXTENSIONS=#{ext_path}

    # Optionally echo the value of the specified variable
    if [ "$#" -eq 1 ]; then
      echo "${!1}"
    fi
    EOS
  end

  test do
    system "caget", "-h"
    system "caput", "-h"
  end
end

def wrap_epics_binaries(epics_host_arch=nil, epics_env=nil, skip_names=[])
  # wrap all binaries with env scripts (bin/caget script -> bin/host_arch/caget)
  epics_host_arch = get_epics_host_arch() if (epics_host_arch == nil)
  epics_env = get_epics_env_map() if (epics_env == nil)

  $stderr.printf("Wrapping binaries in %s\n", bin/"#{epics_host_arch}/*")
  Pathname.glob(bin/"#{epics_host_arch}/*") do |file|
    next if file.directory?
    next if skip_names.include?(file.basename)
    $stderr.printf("Wrapping binary %s\n", file)
    (bin+file.basename).write_env_script(file, epics_env)
  end
end

def get_epics_env_var(varname)
  base_prefix = Formula['epics-base'].prefix
  `bash "#{base_prefix}/bin/epics_env.sh" #{varname}`.chomp
end

def get_epics_base()
  get_epics_env_var("EPICS_BASE")
end

def get_epics_host_arch()
  get_epics_env_var("EPICS_HOST_ARCH")
end

def get_epics_extension_path()
  get_epics_env_var("EPICS_EXTENSIONS")
end

def get_epics_env_map()
  {:EPICS_HOST_ARCH => get_epics_env_var("EPICS_HOST_ARCH"),
   :EPICS_BASE => get_epics_env_var("EPICS_BASE"),
   :EPICS_EXTENSIONS => get_epics_env_var("EPICS_EXTENSIONS"),
   }
end

def get_epics_make_variables()
  ["EPICS_BASE=" + get_epics_base(), "EPICS_HOST_ARCH=" + get_epics_host_arch()]
end

def get_package_prefix(pkgname)
  Formula[pkgname].prefix
end

def fix_epics_release_file(paths={}, release_path='configure/RELEASE')
  # paths: a Hash of PKG_VAR=>PATH
  paths = paths.clone
  if not paths.has_key? :EPICS_BASE then
    paths[:EPICS_BASE] = get_epics_base()
  end

  paths.each do |name, path|
    begin
      inreplace release_path, /^\s*(#?\s*#{name}\s*=.*)$/, "#{name} = #{path}"
    rescue Utils::InreplaceError
      raise if name != :EPICS_BASE
    end
  end

  if not paths.has_key? :SUPPORT then
    begin
      inreplace release_path, /^\s*(#?\s*SUPPORT\s*=.*)$/, "# \\1"
    rescue Utils::InreplaceError
    end
  end
end
