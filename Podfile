source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!

target 'BitTrader' do
  pod 'RxSwift', '3.1.0'
  pod 'RxCocoa', '3.1.0'
  pod 'APIKit', '3.1.1'
  pod 'Himotoki', '3.0.0'
  pod 'KeychainAccess', '3.0.0'
  pod 'ReSwift', '2.1.0'
  pod 'RealmSwift', '2.1.2'

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
    if target.name == 'RxSwift'
        target.build_configurations.each do |config|
            if config.name == 'Debug'
                config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
            end
        end
    end
  end
end
