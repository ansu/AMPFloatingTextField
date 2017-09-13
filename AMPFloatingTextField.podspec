#
# Be sure to run `pod lib lint AMPFloatingTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AMPFloatingTextField'
  s.version          = '0.1.0'
  s.summary          = 'AMPFloatingTextField is a beautiful implementation of the floating title and error lable pattern'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = 'AMPFloatingTextField is a beautiful implementation of the floating title and error lable pattern. This will display the title on top and error below the text field'


  s.homepage         = 'https://github.com/ansu/AMPFloatingTextField'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ansu' => 'ansu.rajesh@gmail.com' }
  s.source           = { :git => 'https://github.com/ansu/AMPFloatingTextField.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ansujain'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AMPFloatingTextField/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AMPFloatingTextField' => ['AMPFloatingTextField/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
