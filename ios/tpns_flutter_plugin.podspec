#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tpns_flutter_plugin.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tpns_flutter_plugin'
  s.version          = '1.1.2'
  s.summary          = 'TPNS'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://cloud.tencent.com/product/tpns/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Tencent' => 'rockzuo@tencent.com' }
  s.source           = { :git => "https://github.com/TencentCloud/TPNS-Flutter-Plugin", :branch => "V1.1.2" }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'TPNS-iOS', '1.3.3.0'
  s.platform = :ios, '9.0'
  s.static_framework = true
end
