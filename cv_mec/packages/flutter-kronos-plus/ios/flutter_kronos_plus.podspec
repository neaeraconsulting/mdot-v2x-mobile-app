        #
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_kronos.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_kronos_plus'
  s.version          = '1.0.0'
  s.summary          = 'Kronos is an open source Network Time Protocol (NTP) synchronization library for providing a trusted clock.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/Mo0Khaled/flutter-kronos-plus.git'
  s.license          = { :file => '../LICENSE' }
  s.author           = { '' => '' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Kronos', '4.2.2'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
