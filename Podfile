platform :ios,'10.0'
use_frameworks!
inhibit_all_warnings!

def pods
  # MBMobileSDK
  pod 'MBMobileSDK', '~> 1.0'

  # code analyser / generator
  pod 'SwiftGen', '~> 6.0'
  pod 'SwiftLint', '~> 0.30'
  pod 'EFCountingLabel'
    
  # data
    
  # layout / ui
    
  # network
    
  # reporting
end

target 'MBMobileExample' do
  pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
