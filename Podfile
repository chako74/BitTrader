source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!

target 'BitTrader' do
  pod 'RxSwift', '3.0.0-beta.2'
  pod 'RxCocoa', '3.0.0-beta.2'
  pod 'APIKit', '3.0.0-beta.2'
  pod 'Himotoki', '3.0.0'
  pod 'KeychainAccess', '3.0.0'

  target 'BitTraderTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
    end
  end
end
