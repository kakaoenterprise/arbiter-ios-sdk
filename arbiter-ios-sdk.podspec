#
# Be sure to run `pod lib lint arbiter-ios-sdk.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'arbiter-ios-sdk'
  s.version          = '0.0.2'
  s.summary          = 'AB Testing solution Arbiter`s iOS SDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/kakaoenterprise/arbiter-ios-sdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license      = { :type => "Apache 2.0", :file => "LICENSE.md" }
  s.author           = { 'zito.k' => 'zito.k@kakaoenterprise.com' }
  s.source           = { :git => 'https://github.com/kakaoenterprise/arbiter-ios-sdk.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.ios.vendored_frameworks = 'Sources/Arbiter.xcframework'
  
  # s.resource_bundles = {
  #   'arbiter-ios-sdk' => ['arbiter-ios-sdk/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
