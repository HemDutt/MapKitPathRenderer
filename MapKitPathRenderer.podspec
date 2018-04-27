#
# Be sure to run `pod lib lint MapKitPathRenderer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MapKitPathRenderer'
  s.version          = '0.1.0'
  s.summary          = 'MapKitPathRenderer allows drawing straight line path between multiple points on MapKitView.'
  s.swift_version    = '4.1'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'MapKitPathRenderer allows drawing straight line path between multiple points on MapKitView.It allows multiple annotations on Map view to be connected through a straight line. MapKitPathRenderer considers date line crossing for creating shortest path between to coordinates.'
                       DESC

  s.homepage         = 'https://github.com/Hem Dutt/MapKitPathRenderer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hem Dutt' => 'hemdutt.developer@gmail.com' }
  s.source           = { :git => 'https://github.com/Hem Dutt/MapKitPathRenderer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MapKitPathRenderer/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MapKitPathRenderer' => ['MapKitPathRenderer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
