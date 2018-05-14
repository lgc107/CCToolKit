#
# Be sure to run `pod lib lint CCToolKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CCToolKit'
  s.version          = '0.0.3'
  s.summary          = 'Extension Tool'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                       One Extension Tool
                       DESC

  s.homepage         = 'https://github.com/lgc107/CCToolKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lgc107' => '15645969688@163.com' }
  s.source           = { :git => 'https://github.com/lgc107/CCToolKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CCToolKit/CCToolKit.h'
  
  # s.resource_bundles = {
  #   'CCToolKit' => ['CCToolKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
