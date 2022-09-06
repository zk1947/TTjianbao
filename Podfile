source 'https://github.com/cocoapods/specs.git'
#source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
# Uncomment this line if you're using Swift
# use_frameworks!
inhibit_all_warnings!

## 消除xCode升级后pod警告⚠️
post_install do |installer|
  installer.generated_projects.each do |project|
    project.build_configurations.each do |config|
        if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 8.0
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
        end
    end
    project.targets.each do |target|
      target.build_configurations.each do |config|
        if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 8.0
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
        end
      end
    end
  end
end

target 'TTjianbao' do  
    pod 'AFNetworking', '4.0.1'
    pod 'Masonry', '1.1.0'
    pod 'MJExtension', '3.2.2'
    pod 'MJRefresh', '3.5.0'
    pod 'FMDB', '2.7.5'
    pod 'GTMBase64'

    pod 'UMCCommon', '2.1.4'

    pod 'UMCSecurityPlugins', '1.0.6'
    pod 'UMCCommonLog', '1.0.0'
    # U-Share SDK UI模块（分享面板，建议添加）
    pod 'UMCShare/UI', '6.9.10'
    pod 'GrowingAutoTrackKit','2.9.1'
    pod 'GrowingCoreKit','2.9.1'
    # 集成微信(精简版0.2M)
#    pod 'UMCShare/Social/ReducedWeChat', '~>6.9.8'
    pod 'WechatOpenSDK','1.8.7.1'
    pod 'IQKeyboardManager', '6.5.5'
    pod 'QBImagePickerController', '3.4.0'
    pod 'SDWebImage', '5.9.0'
    pod 'SDWebImageWebPCoder', '0.6.1'
    pod 'Toast', '2.4'
    pod 'SVProgressHUD', '2.2.5'
    pod 'CocoaLumberjack', '2.2.0'
    pod 'Reachability', '3.1.1'
    pod 'M80AttributedLabel', '1.3.3'
    pod 'SSZipArchive', '1.8.1'
#    pod 'UMCShare/Social/ReducedQQ', '~>6.9.8'

    pod 'UMCAnalytics', '6.1.0'
    pod 'SSKeychain', '1.4.1'
    pod 'ZFPlayer', '3.2.17'
    pod 'YYKit','1.0.9'
    pod 'SHSegmentedControl','1.3.4'
    pod 'JXCategoryView', '1.5.5'
    pod 'JXPagingView/Pager', '2.0.1'

    pod 'ReactiveObjC', '3.1.1'
    pod 'SDAutoLayout', '2.2.1'
    pod 'TYPagerController', '2.1.2'
    pod 'LEEAlert', '1.2.8'
    pod 'GKPhotoBrowser', '2.1.3'
#   网易直播部分
    pod 'NMCLiveStreaming_MINI', '3.1.2'
    pod 'NELivePlayer', '2.4.4'
    pod 'NIMSDK', '6.9.1'
  
    pod 'AliyunOSSiOS','2.10.8' #阿里云，用于图片和视频上传
    pod 'MBProgressHUD'
    pod 'LBXScan/LBXNative','2.3'
    pod 'LBXScan/LBXZXing','2.3'
    pod 'LBXScan/LBXZBar','2.3'  #WebView有改动
    pod 'LBXScan/UI','2.3'
    pod 'GDTActionSDK', '1.0.3.2' #pod引入framework支持模拟器
    pod 'SVGAPlayer', '2.5.2'
    
    pod 'JPush','3.3.2'
    pod 'JVerification','2.6.5'
    pod 'Bugly','2.5.71'

    #神策
    pod 'SensorsAnalyticsSDK','2.3.0'
    pod 'SensorsABTesting'
    
    # 网易活体检测 集成最新版SDK:
    pod 'NTESLiveDetect', '~> 2.2.0'
end

