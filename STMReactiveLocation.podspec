#
# Be sure to run `pod lib lint STMReactiveLocation.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "STMReactiveLocation"
  s.version          = "0.1.0"
  s.summary          = "A short description of STMReactiveLocation."
  s.description      = <<-DESC
                       An optional longer description of STMReactiveLocation

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/stefanomondino/STMReactiveLocation"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Stefano Mondino" => "stefano.mondino.dev@gmail.com" }
  s.source           = { :git => "https://github.com/stefanomondino/STMReactiveLocation.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/puntoste'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'STMReactiveLocation' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'CoreLocation', 'MapKit'
   s.dependency 'ReactiveCocoa', '~> 2.3'
   s.dependency 'libextobjc/EXTScope', '~> 0.4'
end
