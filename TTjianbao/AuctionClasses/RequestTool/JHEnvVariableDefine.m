//
//  JHEnvVariableDefine.m
//  TTjianbao
//
//  Created by apple on 2019/6/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHEnvVariableDefine.h"
#import "TTjianbaoMarcoKeyword.h"
#import "UserInfoRequestManager.h"
#import "NTESLogManager.h"

NSString *const JHApiTestKey = @"jh_api_test_key";
NSString *const JHServiceTypeKey = @"jh_service_type_key";

//默认线上
///api域名
static NSString *JHApiURL = @"https://api.ttjianbao.com";
///h5域名
static NSString *JHH5URL = @"https://h5.ttjianbao.com";
///社区域名
static NSString *JHCommunityURL = @"https://sq-api.ttjianbao.com";
///大数据上报
static NSString *JHBigDataURL = @"http://event.ttjianbao.com:8080/report";
///h5域名 http
static NSString *JHReportH5URL = @"http://h5.ttjianbao.com";
///网易key
static NSString *JHWYKey = @"1760655eab7c17316f322cec8a686a62";
///阿里云图片域名
static NSString *JHAliyuncsURL = @"https://sq-image.oss-cn-beijing.aliyuncs.com";
///阿里云视频域名
static NSString *JHAliyuncsVideoURL = @"http://sq-videos.oss-cn-beijing.aliyuncs.com";
 ///开发用debug域名
static NSString *JHDevDebugingURL = @"http://172.17.214.69:9090/mock/12";
//神策
static NSString *SA_SERVER_URL = @"https://event-shence.ttjianbao.com/sa?project=default";
//SA_SERVER_URL = @"https://event-shence.ttjianbao.com/sa?project=production";   测试数据  真是数据对换
//神策SA_ABTEST_URL
static NSString *SA_ABTEST_URL = @"http://abtest-tx-beijing-01.saas.sensorsdata.cn/api/v2/abtest/online/results?project-key=29C6021DA15B161FB54FD9F31C91B28F35714328";
//@"http://abtest-tx-beijing-01.saas.sensorsdata.cn/api/v2/abtest/online/results?project-key=5AC0518AAA71AAC918B7AD7877063F20A27DADBF" 测试数据
static JHServiceType serviceType = JHServiceTypeRelease;

@implementation JHEnvVariableDefine

+ (void)initialize {
    serviceType = [JHUserDefaults integerForKey:JHServiceTypeKey];
    switch (serviceType) {
        case JHServiceTypePreRelease:{
            ///预生产环境
            ///api域名
            JHApiURL = @"https://api-gray.ttjianbao.com";
            ///h5域名
            JHH5URL = @"https://h5-gray.ttjianbao.com";
            ///社区域名
            JHCommunityURL = @"https://sq-api-gray.ttjianbao.com";
            ///大数据上报
            JHBigDataURL = @"https://event-gray.ttjianbao.com";
            ///h5域名 http
            JHReportH5URL = @"http://h5-gray.ttjianbao.com";
            ///网易key
            JHWYKey = @"c933ed75ccb3fc86841e26fb06c366c7";
            ///阿里云域名
            JHAliyuncsURL = @"https://sq-image.oss-cn-beijing.aliyuncs.com";
            ///阿里云视频域名
            JHAliyuncsVideoURL = @"http://sq-videos.oss-cn-beijing.aliyuncs.com";
            ///神策数据上报
            SA_SERVER_URL = @"https://event-shence.ttjianbao.com/sa?project=production";
            ///abtest
            SA_ABTEST_URL = @"http://abtest-tx-beijing-01.saas.sensorsdata.cn/api/v2/abtest/online/results?project-key=5AC0518AAA71AAC918B7AD7877063F20A27DADBF";
        }
            break;
            
        case JHServiceTypeTestA:{
            ///测试环境
            ///api域名
            JHApiURL = @"http://api-testa.ttjianbao.com";
            ///h5域名
            JHH5URL = @"http://h5-testa.ttjianbao.com";
            ///社区域名
            JHCommunityURL = @"http://sq-api-testa.ttjianbao.com";
            ///大数据上报
            JHBigDataURL = @"http://event-testa.ttjianbao.com/report";
            ///h5域名 http
            JHReportH5URL = @"http://h5-testa.ttjianbao.com";
            ///网易key
            JHWYKey = @"b571ec9d6080f409d0480c79026df5a3";
            ///阿里云域名
            JHAliyuncsURL = @"https://sq-image-test.oss-cn-beijing.aliyuncs.com";
            ///阿里云视频域名
            JHAliyuncsVideoURL = @"http://sq-videos-test.oss-cn-beijing.aliyuncs.com";
            ///神策数据上报
            SA_SERVER_URL = @"https://event-shence.ttjianbao.com/sa?project=production";
            ///abtest
            SA_ABTEST_URL = @"http://abtest-tx-beijing-01.saas.sensorsdata.cn/api/v2/abtest/online/results?project-key=5AC0518AAA71AAC918B7AD7877063F20A27DADBF";
        }
            break;
            
        case JHServiceTypeTestB:{
            ///测试环境
            ///api域名
            JHApiURL = @"https://api-testb.ttjianbao.com";
            ///h5域名
            JHH5URL = @"http://h5-testb.ttjianbao.com";
            ///社区域名
            JHCommunityURL = @"http://sq-api-testb.ttjianbao.com";
            ///大数据上报
            JHBigDataURL = @"http://event-testb.ttjianbao.com/report";
            ///h5域名 http
            JHReportH5URL = @"http://h5-jianhuo.testb.ttjianbao.com";
            ///网易key
            JHWYKey = @"01a24dd3633d4f364dd4376ad333d9d0";
            ///阿里云域名
            JHAliyuncsURL = @"https://sq-image-test.oss-cn-beijing.aliyuncs.com";
            ///阿里云视频域名
            JHAliyuncsVideoURL = @"http://sq-videos-test.oss-cn-beijing.aliyuncs.com";
            ///神策数据上报
            SA_SERVER_URL = @"https://event-shence.ttjianbao.com/sa?project=production";
            ///abtest
            SA_ABTEST_URL = @"http://abtest-tx-beijing-01.saas.sensorsdata.cn/api/v2/abtest/online/results?project-key=5AC0518AAA71AAC918B7AD7877063F20A27DADBF";
        }
            break;
            
        case JHServiceTypeTestC:{
            ///测试环境
            ///api域名
            JHApiURL = @"http://api-testc.ttjianbao.com";
            ///h5域名
            JHH5URL = @"https://h5-testc.ttjianbao.com";
            ///社区域名
            JHCommunityURL = @"http://sq-api-testc.ttjianbao.com";
            ///大数据上报
            JHBigDataURL = @"http://event-testc.ttjianbao.com/report";
            ///h5域名 http
            JHReportH5URL = @"http://h5-testc.ttjianbao.com";
            ///网易key
            JHWYKey = @"c933ed75ccb3fc86841e26fb06c366c7";
            ///阿里云域名
            JHAliyuncsURL = @"https://sq-image-test.oss-cn-beijing.aliyuncs.com";
            ///阿里云视频域名
            JHAliyuncsVideoURL = @"http://sq-videos-test.oss-cn-beijing.aliyuncs.com";
            ///神策数据上报
            SA_SERVER_URL = @"https://event-shence.ttjianbao.com/sa?project=production";
            ///abtest
            SA_ABTEST_URL = @"http://abtest-tx-beijing-01.saas.sensorsdata.cn/api/v2/abtest/online/results?project-key=5AC0518AAA71AAC918B7AD7877063F20A27DADBF";
        }
            break;
            
        case JHServiceTypeDevelop:{
            ///开发环境
            ///api域名
            JHApiURL = @"http://api-dev-a.ttjianbao.com";
            ///h5域名
            JHH5URL = @"http://h5-deva.ttjianbao.com";
            ///社区域名
            JHCommunityURL = @"http://sq-api-dev-a.ttjianbao.com";
            ///大数据上报
            JHBigDataURL = @"http://event-dev-a.ttjianbao.com";
            ///h5域名 http
            JHReportH5URL = @"http://h5-deva.ttjianbao.com";
            ///网易key
            JHWYKey = @"6bf4355099d27f8aa398accf6adf9756";
            ///阿里云域名
            JHAliyuncsURL = @"https://sq-image-test.oss-cn-beijing.aliyuncs.com";
            ///阿里云视频域名
            JHAliyuncsVideoURL = @"http://sq-videos-test.oss-cn-beijing.aliyuncs.com";
            ///神策数据上报
            SA_SERVER_URL = @"https://event-shence.ttjianbao.com/sa?project=production";
            ///abtest
            SA_ABTEST_URL = @"http://abtest-tx-beijing-01.saas.sensorsdata.cn/api/v2/abtest/online/results?project-key=5AC0518AAA71AAC918B7AD7877063F20A27DADBF";
        }
            break;
            
        default: {
            ///api域名
            JHApiURL = @"https://api.ttjianbao.com";
            ///h5域名
            JHH5URL = @"https://h5.ttjianbao.com";
            ///社区域名
            JHCommunityURL = @"https://sq-api.ttjianbao.com";
            ///大数据上报
            JHBigDataURL = @"http://event.ttjianbao.com:8080/report";
            ///h5域名 http
            JHReportH5URL = @"http://h5.ttjianbao.com";
            ///网易key
            JHWYKey = @"1760655eab7c17316f322cec8a686a62";
            ///阿里云域名
            JHAliyuncsURL = @"https://sq-image.oss-cn-beijing.aliyuncs.com";
            ///阿里云视频域名
            JHAliyuncsVideoURL = @"http://sq-videos.oss-cn-beijing.aliyuncs.com";
            ///神策数据上报
            SA_SERVER_URL = @"https://event-shence.ttjianbao.com/sa?project=default";
            ///abtest
            SA_ABTEST_URL = @"http://abtest-tx-beijing-01.saas.sensorsdata.cn/api/v2/abtest/online/results?project-key=29C6021DA15B161FB54FD9F31C91B28F35714328";
        }
            break;
    }
}

+ (JHServiceType)serviceType {
    return serviceType;
}

+ (NSString *)fileBaseString {
    return JHApiURL;
}

+ (NSString *)devDebugString {
    return JHDevDebugingURL;
}

+ (NSString *)h5BaseUrl {
    return JHH5URL;
}

//社区 Base url
+ (NSString *)communityFileBaseString {
    return JHCommunityURL;
}

+ (NSString *)imAppKey {
    return JHWYKey;
}

+ (NSString *)BurySever {
    return JHBigDataURL;
}

+ (NSString *)sa_server_url {
    return SA_SERVER_URL;
}

+ (NSString *)sa_abTest_url{
    return SA_ABTEST_URL;
}

+ (NSString *)universalLink {
    //微信后台写死线上域名了 这里也一直返回线上域名
    return @"https://universal.ttjianbao.com/";
}

#pragma mark -
#pragma mark - 3.1.6新增
+ (void)clearFilesFromPath:(NSString*)path
{//清除path下的文件
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    for (NSString *fileName in enumerator)
    {
        BOOL ret = [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingPathComponent:fileName] error:nil];
        NSLog(@"clear document files success ? = (%d)", ret);
    }
}
+ (void)clearAllPathFiles
{
    //清除dcoument下的文件
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    [self clearFilesFromPath:docPath];
    //清除Caches文件夹
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    [self clearFilesFromPath:cachePath];
    //清除Temp下的文件
    NSString* tmpPath = NSTemporaryDirectory();
    [self clearFilesFromPath:tmpPath];
}

+ (void)clearAllUserDefaultsData
{//清除UserDefaults all
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

+ (void)switchToService:(JHServiceType)type {
    
    //移除账号信息
    [JHRootController logoutAccountData];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGINSTATUS];
    //delete UserDefaults all
    [self clearAllUserDefaultsData];
    //delete all files
    [self clearAllPathFiles];
    
    //保存设置环境参数
    [JHUserDefaults setInteger:type forKey:JHServiceTypeKey];
    [JHUserDefaults synchronize];
    
    exit(0);
}

+ (JHServiceType)getService {
    return [JHUserDefaults integerForKey:JHServiceTypeKey];
}

+ (NSString *)alyunImageBucketName {
    switch (serviceType) {
        case JHServiceTypeRelease:
            return @"sq-image";
        case JHServiceTypeDevelop:
            return @"sq-image-test";
        case JHServiceTypeTestA:
            return @"sq-image-test";
        case JHServiceTypeTestB:
            return @"sq-image-test";
        case JHServiceTypeTestC:
            return @"sq-image-test";
        case JHServiceTypePreRelease:
            return @"sq-image-test";
        default:
            return @"sq-image";
    }
    
}

+ (NSString *)alyunVideoBucketName {

    switch (serviceType) {
        case JHServiceTypeRelease:
            return @"sq-videos";
        case JHServiceTypeDevelop:
            return @"sq-videos-test";
        case JHServiceTypeTestA:
            return @"sq-videos-test";
        case JHServiceTypeTestB:
            return @"sq-videos-test";
        case JHServiceTypeTestC:
            return @"sq-videos-test";
        case JHServiceTypePreRelease:
            return @"sq-videos-test";
        default:
            return @"sq-videos";
    }
    
}

+ (NSString *)alyunVoiceBucketName {

    switch (serviceType) {
        case JHServiceTypeRelease:
            return @"sq-videos";
        case JHServiceTypeDevelop:
            return @"sq-videos-test";
        case JHServiceTypeTestA:
            return @"sq-videos-test";
        case JHServiceTypeTestB:
            return @"sq-videos-test";
        case JHServiceTypeTestC:
            return @"sq-videos-test";
        case JHServiceTypePreRelease:
            return @"sq-videos-test";
        default:
            return @"sq-videos";
    }
    
}

+ (NSString *)h5BaseHttpUrl {
    return JHReportH5URL;
}

#pragma mark - 阿里云图片地址
+ (NSString *)aliyuncsBaseUrl {
    return JHAliyuncsURL;
}

#pragma mark - 阿里云图片地址
+ (NSString *)aliyuncsVideoBaseUrl {
    return JHAliyuncsVideoURL;
}

#pragma mark - show view
+ (void)showSwitchAlert
{
#if DEBUG
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"环境切换" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *preProductAction = [UIAlertAction actionWithTitle:@"预发布环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           [self switchToService:JHServiceTypePreRelease];
    }];
    [alert addAction:preProductAction];

    UIAlertAction *testActionA = [UIAlertAction actionWithTitle:@"测试环境A" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self switchToService:JHServiceTypeTestA];
    }];
    [alert addAction:testActionA];
    
    UIAlertAction *testBAction = [UIAlertAction actionWithTitle:@"测试环境B" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self switchToService:JHServiceTypeTestB];
    }];
    [alert addAction:testBAction];
    
    UIAlertAction *testCAction = [UIAlertAction actionWithTitle:@"测试环境C" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self switchToService:JHServiceTypeTestC];
    }];
    [alert addAction:testCAction];
    
    UIAlertAction *developAction = [UIAlertAction actionWithTitle:@"开发环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self switchToService:JHServiceTypeDevelop];
    }];
    [alert addAction:developAction];
    
    UIAlertAction *productAction = [UIAlertAction actionWithTitle:@"线上环境" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self switchToService:JHServiceTypeRelease];
    }];
    [alert addAction:productAction];
    
    UIAlertAction *log = [UIAlertAction actionWithTitle:@"日志" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showDemoLog];
    }];
    [alert addAction:log];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:cancleAction];
    
    [JHRootController.currentViewController presentViewController:alert animated:YES completion:nil];
    
#endif
}

+ (void)showDemoLog
{
    UIViewController *vc = [[NTESLogManager sharedManager] demoLogViewController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [JHRootController.currentViewController presentViewController:nav
                       animated:YES
                     completion:nil];
}

@end
