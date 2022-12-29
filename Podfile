# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
inhibit_all_warnings!
target 'MTM Driver' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Pappea Driver
pod 'IQKeyboardManagerSwift', '~> 6.4.0'
pod 'Alamofire', '~> 4.8.2'
pod 'SDWebImage', '4.4.6'
pod 'IQDropDownTextField', '~> 1.1.1'
pod 'SwiftyJSON', '~> 5.0.0'
pod 'GoogleMaps', '3.0.3'
pod 'GooglePlaces', '3.0.3'
pod 'SideMenuSwift', '~> 2.0.7'
pod 'MarqueeLabel/Swift', '~> 3.2.1'
pod 'Socket.IO-Client-Swift', '~> 15.1.0'

pod 'SSSpinnerButton', '~> 3.0.1'
pod 'Firebase'
pod 'Firebase/Messaging'
pod 'SwiftMessages', '~> 9.0.6'
pod 'SkyFloatingLabelTextField', '~> 3.7.0'
pod 'lottie-ios', '~> 3.3.0'
pod 'ActionSheetPicker-3.0', '~> 2.3.0'
pod 'QRCodeReader.swift', '~> 10.1.0'
pod 'CountryPickerView', '~> 3.2.0'
pod 'Cosmos', '~> 23.0'
pod 'FormTextField', '~> 3.1.0'
pod 'CardIO', '~> 5.4.1'
pod 'Kingfisher', '~> 7.1.1'
pod 'MKToolTip', '~> 1.0.6'
pod 'EasyTipView', '~> 2.1'
pod 'UIView-Shimmer', '~> 1.0'


#pod 'Charts'
#pod 'XYChart'







#pod 'BFKit-Swift'
#pod 'CardIO'
#pod 'TTSegmentedControl'
#pod 'MBCircularProgressBar'
#pod 'M13Checkbox'
#pod 'DropDown'
#pod 'NVActivityIndicatorView'
#pod 'FloatRatingView'
#pod 'Sheeeeeeeeet'
#pod 'ACFloatingTextfield-Swift'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
    end
  end
end
