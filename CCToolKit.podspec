#
#  Be sure to run `pod spec lint CCToolKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "CCToolKit"
  s.version      = "0.0.4"
  s.summary      = "iOS Extension Tool"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                  One Extension FrameWork
                   DESC

  s.homepage     = "https://github.com/lgc107/CCToolKit"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  #s.license      = "MIT"
   s.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "Harry_L" => "15645969688@163.com" }
 
   s.platform     = :ios, "8.0"




  s.source       = { :git => "https://github.com/lgc107/CCToolKit.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

   s.source_files  = "CCToolKit/CCToolKit.h"
  #s.exclude_files = "CCToolKit/Exclude"

   s.public_header_files = "CCToolKit/CCToolKit.h"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

    #s.frameworks = "UIKit", "Foundation"

    s.requires_arc = true


    s.subspec 'CCSoftwareInfo' do |ss|
       ss.dependency 'CCToolKit/CCCategory'
       ss.source_files = 'CCToolKit/CCSoftwareInfo/*.{h,m}'
       ss.ios.frameworks = 'UIKit','CoreTelephony','sys'
     
  end

    s.subspec 'CCCategory' do |ss|
      ss.source_files = 'CCToolKit/CCCategory/*.{h,m}'
      ss.ios.frameworks = 'CommonCrypto'
  end

    s.subspec 'CCStorage' do |ss|
      ss.source_files = 'CCToolKit/CCStorage/*.{h,m}'
      #ss.ios.frameworks = 'CommonCrypto'
  end

  

end
