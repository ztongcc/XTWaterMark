#
# Be sure to run `pod lib lint XTWaterMark.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XTWaterMark'
  s.version          = '0.1.0'
  s.summary          = 'A tool class that generates watermarks'
  s.description      = "A tool class that generates watermarks"

  s.homepage         = 'https://github.com/ztongcc/XTWaterMark.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zt.cheng' => 'ztongcc@163.cn' }
  s.source           = { :git => 'https://github.com/ztongcc/XTWaterMark.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'XTWaterMark/Classes/**/*'
  
  # s.resource_bundles = {
  #   'XTWaterMark' => ['XTWaterMark/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
