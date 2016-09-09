# vim: ts=2 sw=2 sts=2 expandtab

require_relative './epics-base'

class EpicsAreaDetector2 < Formula
  desc "EPICS AreaDetector Version [R2]"
  homepage "http://cars9.uchicago.edu/software/epics/areaDetector.html"
	head "https://github.com/areaDetector/areaDetector.git", :tag => "R2-4"
  version "2-4"

  depends_on "git"
  depends_on "graphicsmagick" => :optional
  depends_on "hdf5"
  depends_on "szip"
  depends_on "netcdf"
  depends_on "libtiff"
  depends_on "libxml2"
  depends_on "nexusformat" => ["without-hdf4"]
  depends_on "libdc1394"  # firewire-dcam
  depends_on "ffmpeg" => :optional

  depends_on "epics-base"
  depends_on "epics-asyn"
  depends_on "epics-seq"
  depends_on "epics-sscan"
  depends_on "epics-calc"
  depends_on "epics-busy"
  depends_on "epics-autosave"
  depends_on "epics-ioc-stats"
  # depends_on "epics-alive"

  # default options should build without issue on osx. that is, only those that
  # are listed as "with-*" presented problems initially and i gave up in the
  # interest of moving forward
  option "with-edge", "Build with edge plugin support"
  option "without-adsc", "Build without adsc support"
  option "without-andor", "Build without andor support"
  option "without-anor3", "Build without anor3 support"
  option "without-bruker", "Build without bruker support"
  option "without-dexela", "Build without dexela support"
  option "without-example", "Build without example support"
  option "with-fastccd", "Build without fastccd support"
  option "without-lightfield", "Build without lightfield support"
  option "with-merlin", "Build with merlin support"  # libcbfad?
  option "without-mythen", "Build without mythen support"
  option "without-picam", "Build without picam support"
  option "without-psl", "Build without psl support"
  option "without-perkinelmer", "Build without perkinelmer support"
  option "without-pilatus", "Build without pilatus support"
  option "without-pixirad", "Build without pixirad support"
  option "without-pointgrey", "Build without pointgrey support"
  option "without-prosilica", "Build without prosilica support"
  option "without-pvcam", "Build without pvcam support"
  option "with-qimaging", "Build with qimaging support"  # qcamapi.h?
  option "without-roper", "Build without roper support"
  option "without-url", "Build without url support"
  option "without-mar345", "Build without mar345 support"
  option "without-marccd", "Build without marccd support"
  option "with-ned", "Build with ned support"   # syscall.h?
  option "with-aravisgige", "Build with aravisgige support"  # no ../aravis/configure?
  option "with-firewiredcam", "Build without firewiredcam support"

  def install
    # ENV.deparallelize
    build_options = {"adsc" => ["ADADSC", "ADADSC"],
                     "andor" => ["ADANDOR", "ADAndor"],
                     "andor3" => ["ADANDOR3", "ADAndor3"],
                     "aravisgige" => ["ARAVISGIGE", "aravisGigE"],
                     "bruker" => ["ADBRUKER", "ADBruker"],
                     "dexela" => ["ADDEXELA", "ADDexela"],
                     "example" => ["ADEXAMPLE", "ADExample"],
                     "fastccd" => ["ADFASTCCD", "ADFastCCD"],
                     "firewiredcam" => ["FIREWIREDCAM", "firewireDCAM"],
                     "lightfield" => ["ADLIGHTFIELD", "ADLightField"],
                     "mar345" => ["ADMAR345", "ADmar345"],
                     "marccd" => ["ADMARCCD", "ADmarCCD"],
                     "merlin" => ["ADMERLIN", "ADMerlin"],
                     "mythen" => ["ADMYTHEN", "ADMythen"],
                     "ned" => ["ADNED", "ADnED"],
                     "perkinelmer" => ["ADPERKINELMER", "ADPerkinElmer"],
                     "picam" => ["ADPICAM", "ADPICam"],
                     "pilatus" => ["ADPILATUS", "ADPilatus"],
                     "pixirad" => ["ADPIXIRAD", "ADPixirad"],
                     "edge" => ["ADPLUGINEDGE", "ADPluginEdge"],
                     "pointgrey" => ["ADPOINTGREY", "ADPointGrey"],
                     "prosilica" => ["ADPROSILICA", "ADProsilica"],
                     "psl" => ["ADPSL", "ADPSL"],
                     "pvcam" => ["ADPVCAM", "ADPvCam"],
                     "qimaging" => ["ADQIMAGING", "ADQImaging"],
                     "roper" => ["ADROPER", "ADRoper"],
                     "url" => ["ADURL", "ADURL"],
                     }
    option_hash = {}

    build_options.each do |option, info|
      if build.with? option then
        variable, directory = info
        option_hash[variable] = directory
      end
    end
  
    if build.with? "ffmpeg"
      ffmpeg_path = get_package_prefix('ffmpeg')
      option_hash["FFMPEGSERVER"] = ffmpeg_path
      option_hash["FFMPEGVIEWER"] = ffmpeg_path
    end
  
    FileUtils.mv("configure/EXAMPLE_RELEASE_PATHS.local",
                 "configure/RELEASE_PATHS.local")
    FileUtils.mv("configure/EXAMPLE_RELEASE.local",
                 "configure/RELEASE.local")
    FileUtils.mv("configure/EXAMPLE_RELEASE_LIBS.local",
                 "configure/RELEASE_LIBS.local")
    FileUtils.mv("configure/EXAMPLE_RELEASE_PRODS.local",
                 "configure/RELEASE_PRODS.local")
    FileUtils.mv("configure/EXAMPLE_CONFIG_SITE.local",
                 "configure/CONFIG_SITE.local")
  
    fix_epics_release_file(option_hash, "configure/RELEASE.local")

    release_paths = {:SUPPORT=>"SUPPORT_UNUSED_SUPPORT_HMM",
                     :AREA_DETECTOR=>buildpath,
                     :EPICS_BASE=>get_epics_base(),
                     }

    fix_epics_release_file(release_paths, "configure/RELEASE_PATHS.local")

    prods_paths = {:SNCSEQ=>get_package_prefix('epics-seq'),
                   :CALC=>get_package_prefix('epics-calc'),
                   :SSCAN=>get_package_prefix('epics-sscan'),
                   :BUSY=>get_package_prefix('epics-busy'),
                   :AUTOSAVE=>get_package_prefix('epics-autosave'),
                   :DEVIOCSTATS=>get_package_prefix('epics-ioc-stats'),
                   }
    
    fix_epics_release_file(prods_paths, "configure/RELEASE_PRODS.local")

    libs_paths = {:ASYN=>get_package_prefix('epics-asyn')
                  }
    
    fix_epics_release_file(libs_paths, "configure/RELEASE_LIBS.local")

    site_paths = {:HDF5=>get_package_prefix('hdf5'),
                  :SZIP=>get_package_prefix('szip'),
                  :XML2_INCLUDE=>"-I" + get_package_prefix('libxml2') + "/include/libxml2/",
                 }

    if build.with? "graphicsmagick"
       site_paths["GRAPHICS_MAGICK"] = get_package_prefix('graphicsmagick')
       site_paths["USE_GRAPHICSMAGICK"] = "YES"
    end 

    fix_epics_release_file(site_paths, "configure/CONFIG_SITE.local")

    system("make",
           "INSTALL_LOCATION=#{prefix}",
           *get_epics_make_variables())

    wrap_epics_binaries()

    # dependency headers are somehow copied over during the install step
    FileUtils.rm include/"Error.h"
    FileUtils.rm Dir.glob(include/'H5*')
    FileUtils.rm Dir.glob(include/'hdf5*.h')
    FileUtils.rm Dir.glob(include/'netcdf.h')
    FileUtils.rm Dir.glob(include/'tiff*.h')
  end

  test do
    system "echo exit | simDetectorApp"
  end
end
