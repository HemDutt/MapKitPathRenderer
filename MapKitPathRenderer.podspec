#
# Be sure to run `pod lib lint MapKitPathRenderer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MapKitPathRenderer'
  s.version          = '0.1.1'
  s.summary          = 'MapKitPathRenderer returns points on a route between a source and destination on MapKit over which animation can rendered.'
  s.swift_version    = '4.1'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'MapKitPathRenderer returns multiple points on a straight Polyline path between a source and destination on MapKit over which animation can rendered. MapKitPathRenderer considers Date Line crossing for creating shortest path between two coordinates for animation to be rendered.'
                       DESC

  s.homepage         = 'https://github.com/HemDutt/MapKitPathRenderer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hem Dutt' => 'hemdutt.developer@gmail.com' }
  s.source           = { :git => 'https://github.com/HemDutt/MapKitPathRenderer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://www.linkedin.com/in/hem-dutt-65a16630/'

  s.ios.deployment_target = '8.0'
  
  s.source_files = 'MapKitPathRenderer/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MapKitPathRenderer' => ['MapKitPathRenderer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
