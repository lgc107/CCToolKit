Pod::Spec.new do |s|
  s.name             = "CCToolKit"
  s.version          = "0.1.7"
  s.summary          = "Custom Category used on iOS."
  s.description      = <<-DESC
                       Custom Category used on iOS, which implement by Objective-C.
                       DESC
  s.homepage         = "https://github.com/lgc107/CCToolKit"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Harry_L" => "15645969688@163.com" }
  s.platform         = :ios, '8.0'
  s.source           = { :git => "https://github.com/lgc107/CCToolKit.git", :tag => "#{s.version}" }
  s.requires_arc     = true

  s.frameworks = "UIKit", "Foundation","CoreTelephony","WebKit"

  s.source_files  = "CCToolKit/CCToolKit.h"
  s.public_header_files = "CCToolKit/CCToolKit.h"

  s.subspec 'CCCategory' do |ss|
    ss.source_files = 'CCToolKit/CCCategory/CCCategory.h'
    ss.public_header_files = 'CCToolKit/CCCategory/CCCategory.h'

    ss.subspec 'FoundationCategory' do |sss|
    sss.source_files = 'CCToolKit/CCCategory/Foundation+Utilities/*.{h,m}'
    sss.dependency 'CCToolKit/CCXMLParser'
    end

    ss.subspec 'UIKitCategory' do |sss|
    sss.source_files = 'CCToolKit/CCCategory/UIKit+Utilities/*.{h,m}'
    end

    ss.subspec 'WebKitCategory' do |sss|
    sss.source_files = 'CCToolKit/CCCategory/WebKit+Utilities/*.{h,m}'
    sss.dependency 'CCToolKit/CCCategory/FoundationCategory'
    end

  end

  s.subspec 'CCXMLParser' do |ss|
    ss.source_files = 'CCToolKit/CCXMLParser/*.{h,m}'
    ss.public_header_files = "CCToolKit/CCXMLParser/*.h"
  end
   
  s.subspec 'CCSoftwareInfo' do |ss|
    ss.source_files = 'CCToolKit/CCSoftwareInfo/*.{h,m}'
  end
  s.subspec 'CCStorage' do |ss|
    ss.source_files = 'CCToolKit/CCStorage/*.{h,m}'
  end
  s.subspec 'CCStorage' do |ss|
    ss.source_files = 'CCToolKit/CCStorage/*.{h,m}'
  end

  s.subspec 'CCNumberKeyboard' do |ss|
    ss.source_files = 'CCToolKit/CCNumberKeyboard/*.{h,m}'
    ss.resources = 'CCToolKit/CCNumberKeyboard/Images/*.png'
    ss.framework  = 'QuartzCore'
  end 

end

