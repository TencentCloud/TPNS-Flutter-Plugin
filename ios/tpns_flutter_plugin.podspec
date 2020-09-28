#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tpns_flutter_plugin.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tpns_flutter_plugin'
  s.version          = '1.0.4'
  s.summary          = 'TPNS'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://cloud.tencent.com/product/tpns/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Tencent' => 'rockzuo@tencent.com' }
  s.source           = { :git => "http://git.code.tencent.com/tpns/TPNS-Flutter-Plugin.git", :branch => "V1.0.5" }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'TPNS-iOS', '1.2.7.2'
  s.platform = :ios, '8.0'
  s.static_framework = true
end
