Pod::Spec.new do |s|
  s.name             = "CCToolKit"
  s.version          = "0.0.8"
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

  s.frameworks = "UIKit", "Foundation",'CoreTelephony'

  s.source_files  = "CCToolKit/CCToolKit.h"
  s.public_header_files = "CCToolKit/CCToolKit.h"
  
  s.subspec 'CCSoftwareInfo' do |ss|
    ss.source_files = 'CCToolKit/CCSoftwareInfo/*.{h,m}'
  end

  s.subspec 'CCCategory' do |ss|
    ss.source_files = 'CCToolKit/CCCategory/*.{h,m}'
  end

  s.subspec 'CCStorage' do |ss|
    ss.source_files = 'CCToolKit/CCStorage/*.{h,m}'
  end

  s.subspec 'CCXMLDictionaryParser' do |ss|
    ss.source_files = 'CCToolKit/CCXMLDictionaryParser/*.{h,m}'
    ss.dependency 'CCToolKit/CCCategory'
  end

end

