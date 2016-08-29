# vim: ts=2 sw=2 sts=2 expandtab

require_relative './epics-base'

class EpicsAreaDetector < Formula
  desc "EPICS AreaDetector"
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
  option "without-fastccd", "Build without fastccd support"
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
  option "without-firewiredcam", "Build without firewiredcam support"

  def install
    asyn_path = get_package_prefix('epics-asyn')
    sncseq_path = get_package_prefix('epics-seq')
    calc_path = get_package_prefix('epics-calc')
    sscan_path = get_package_prefix('epics-sscan')
    busy_path = get_package_prefix('epics-busy')
    autosave_path = get_package_prefix('epics-autosave')
    iocstats_path = get_package_prefix('epics-ioc-stats')
    hdf5_path = get_package_prefix('hdf5')
    szip_path = get_package_prefix('szip')
    graphicsmagick_path = get_package_prefix('graphicsmagick')
    xml2_path = get_package_prefix('libxml2')

		option_args = []

    if build.with? "ffmpeg"
      ffmpeg_path = get_package_prefix('ffmpeg')
      option_args << "FFMPEGSERVER=" + ffmpeg_path
      option_args << "FFMPEGVIEWER=" + ffmpeg_path
    end
  
    if build.with? "graphicsmagick"
       option_args << "GRAPHICS_MAGICK=#{graphicsmagick_path}"
       option_args << "USE_GRAPHICSMAGICK=YES"
    end 

    option_args << "ADADSC=ADADSC" if build.with? "adsc"
    option_args << "ADANDOR=ADAndor" if build.with? "andor"
    option_args << "ADANOR3=ADAndor3" if build.with? "anor3"
    option_args << "ARAVISGIGE=aravisGigE" if build.with? "aravisgige"
    option_args << "ADBRUKER=ADBruker" if build.with? "bruker"
    option_args << "ADDEXELA=ADDexela" if build.with? "dexela"
    option_args << "ADEXAMPLE=ADExample" if build.with? "example"
    option_args << "ADFASTCCD=ADFastCCD" if build.with? "fastccd"
    option_args << "FIREWIREDCAM=firewireDCAM" if build.with? "firewiredcam"
    option_args << "ADLIGHTFIELD=ADLightField" if build.with? "lightfield"
    option_args << "ADMAR345=ADmar345" if build.with? "mar345"
    option_args << "ADMARCCD=ADmarCCD" if build.with? "marccd"
    option_args << "ADMERLIN=ADMerlin" if build.with? "merlin"
    option_args << "ADMYTHEN=ADMythen" if build.with? "mythen"
    option_args << "ADNED=ADnED" if build.with? "ned"
    option_args << "ADPERKINELMER=ADPerkinElmer" if build.with? "perkinelmer"
    option_args << "ADPICAM=ADPICam" if build.with? "picam"
    option_args << "ADPILATUS=ADPilatus" if build.with? "pilatus"
    option_args << "ADPIXIRAD=ADPixirad" if build.with? "pixirad"
    option_args << "ADPLUGINEDGE=ADPluginEdge" if build.with? "edge"
    option_args << "ADPOINTGREY=ADPointGrey" if build.with? "pointgrey"
    option_args << "ADPROSILICA=ADProsilica" if build.with? "prosilica"
    option_args << "ADPSL=ADPSL" if build.with? "psl"
    option_args << "ADPVCAM=ADPvCam" if build.with? "pvcam"
    option_args << "ADQIMAGING=ADQImaging" if build.with? "qimaging"
    option_args << "ADROPER=ADRoper" if build.with? "roper"
    option_args << "ADURL=ADURL" if build.with? "url"
  
    FileUtils.mv("configure/EXAMPLE_RELEASE.local",
                 "configure/RELEASE.local")
    FileUtils.mv("configure/EXAMPLE_RELEASE_LIBS.local",
                 "configure/RELEASE_LIBS.local")
    FileUtils.mv("configure/EXAMPLE_RELEASE_PRODS.local",
                 "configure/RELEASE_PRODS.local")
    FileUtils.mv("configure/EXAMPLE_CONFIG_SITE.local",
                 "configure/CONFIG_SITE.local")
  
    epics_base_path = get_epics_base()

    open("configure/RELEASE_PATHS.local", 'w') { |f|
      f << "SUPPORT      =SUPPORT_UNUSED_SUPPORT_HMM\n"
      f << "AREA_DETECTOR=#{buildpath}\n"
      f << "EPICS_BASE   =#{epics_base_path}\n"
    }
  
    # ENV.deparallelize

    system("make",
           "ASYN=#{asyn_path}",
           "SNCSEQ=#{sncseq_path}", 
           "CALC=#{calc_path}",
           "BUSY=#{busy_path}",
           "SSCAN=#{sscan_path}",
           "AUTOSAVE=#{autosave_path}",
           "DEVIOCSTATS=#{iocstats_path}",
           "AREA_DETECTOR=#{buildpath}",
           "HDF5=#{hdf5_path}",
           "SZIP=#{szip_path}",
           "INSTALL_LOCATION=#{prefix}",
					 *option_args,
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
