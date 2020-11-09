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
  s.homepage         = 'https://github.com/TencentCloud/TPNS-Flutter-Plugin'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Tencent' => 'rockzuo@tencent.com' }
  s.source           = { :git => "https://github.com/TencentCloud/TPNS-Flutter-Plugin", :branch => "V1.0.5" }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'TPNS-iOS', '1.2.7.2'
  s.platform = :ios, '8.0'
  s.static_framework = true
end
