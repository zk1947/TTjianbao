//
//  HttpRequestTool.h
//  TTjianbao
//
//  Created by jiangchao on 2018/12/14.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "AFNetworking.h"

//主域名
#define FILE_BASE_STRING(_FILE_)[JHEnvVariableDefine.fileBaseString stringByAppendingString:_FILE_]
//社区域名
#define COMMUNITY_FILE_BASE_STRING(_FILE_)[JHEnvVariableDefine.communityFileBaseString stringByAppendingString:_FILE_]
//im_key
#define IMAPPKEY         JHEnvVariableDefine.imAppKey
//埋点域名
#define BurySeverURL JHEnvVariableDefine.BurySever

///阿里云图片上传域名
#define ALIYUNCS_FILE_BASE_STRING(_FILE_)[JHEnvVariableDefine.aliyuncsBaseUrl stringByAppendingString:_FILE_]

///阿里云图片上传域名
#define ALIYUNCS_VIDEO_BASE_STRING(_FILE_)[JHEnvVariableDefine.aliyuncsVideoBaseUrl stringByAppendingString:_FILE_]

//h5域名
///https
#define H5_BASE_STRING(_FILE_)[JHEnvVariableDefine.h5BaseUrl stringByAppendingString:_FILE_]
//http h5上传图片到网易 需要http
#define H5_BASE_HTTP_STRING(_FILE_)[JHEnvVariableDefine.h5BaseHttpUrl stringByAppendingString:_FILE_]

//开发debug模式域名
#define DEV_DEBUG_HTTP_STRING(_FILE_)[JHEnvVariableDefine.devDebugString stringByAppendingString:_FILE_]

#define AppUniversalLink JHEnvVariableDefine.universalLink
#define ActivityURL(isSell, isAnchor,timeStamp)[H5_BASE_STRING(@"/jianhuo/gameEntrance.html?") stringByAppendingString:[NSString stringWithFormat:@"isSell=%d&isBroad=%d&timeStamp=%@",isSell, isAnchor,timeStamp]]

#define RightBottomActivityURL(isSell, isAnchor)[H5_BASE_STRING(@"/html/platformActivities.html?") stringByAppendingString:[NSString stringWithFormat:@"isSell=%d&isBroad=%d",isSell, isAnchor]]

#define FindWishPaperURL(buyerId)[H5_BASE_HTTP_STRING(@"/jianhuo/findGoodsC.html?") stringByAppendingString:[NSString stringWithFormat:@"buyerId=%@",buyerId]]

#define AuctionURL(isSell, isAnchor, isAssistant) [H5_BASE_STRING(@"/jianhuo/auctionBottom.html?") stringByAppendingString:[NSString stringWithFormat:@"isSell=%d&isBroad=%d&isAssistant=%d",isSell, isAnchor,isAssistant]]

#define AuctionListURL(isSell, isAnchor, isAssistant) [H5_BASE_STRING(@"/jianhuo/auctionList.html?") stringByAppendingString:[NSString stringWithFormat:@"isSell=%zd&isBroad=%zd&isAssistant=%zd",isSell, isAnchor,isAssistant]]

#define SendWishPaperURL(isSell, isAnchor, isAssistant) [H5_BASE_STRING(@"/jianhuo/auctionList.html?") stringByAppendingString:[NSString stringWithFormat:@"isSell=%d&isBroad=%d&isAssistant=%d",isSell, isAnchor,isAssistant]]

#define ShowWishPaperURL(isSell, isAnchor, isAssistant) [H5_BASE_STRING(@"/jianhuo/wishB.html?") stringByAppendingString:[NSString stringWithFormat:@"isSell=%d&isBroad=%d&isAssistant=%d",isSell, isAnchor,isAssistant]]

#define ShowUserWishPaperURL(isSell, isAnchor, isAssistant) [H5_BASE_STRING(@"/jianhuo/wishC.html?") stringByAppendingString:[NSString stringWithFormat:@"isSell=%d&isBroad=%d&isAssistant=%d",isSell, isAnchor,isAssistant]]

#define ReturnDetailURL(orderID, isAnchor) [H5_BASE_STRING(@"/jianhuo/app/refundDetail.html?") stringByAppendingString:[NSString stringWithFormat:@"orderId=%@&isBroad=%d",orderID,isAnchor]]

#define AppraiseIssueDetailURL(orderID) [H5_BASE_STRING(@"/jianhuo/app/checkDetails.html?") stringByAppendingString:[NSString stringWithFormat:@"orderId=%@",orderID]]
#define CompleteOrderDetailURL(orderID) [H5_BASE_STRING(@"/jianhuo/app/orderPerfectInformation.html?") stringByAppendingString:[NSString stringWithFormat:@"orderId=%@",orderID]]
//
#define FIRSTLAUNCHCOMPLETE [@"FirstLaunchComplete" stringByAppendingString:JHAppVersion]

///业务线：0 全部，1 直播，2 商城
#define MerchantRecyleDetailURL(index, bussId) [H5_BASE_STRING(@"/jianhuo/app/recycle/order/orderList.html?") stringByAppendingString:[NSString stringWithFormat:@"index=%@&bussId=%@",index, bussId]]

//回血攻略
#define StoneRestoreBuyRuleURL H5_BASE_STRING(@"/jianhuo/app/pass_consignment_strategy.html")

//回血协议
#define StoneRestoreProtocolURL H5_BASE_STRING(@"/app/passRule.html")
//直播间排行榜
#define LiveRoomSortURL(channelID) H5_BASE_STRING([@"/jianhuo/app/consumerList/consumerListChannel.html?channelID=" stringByAppendingString:channelID?:@""])

//@"http://h5.ttjianbao.cn/app/passRule.html"

@class RequestModel, SignModel;

typedef NS_ENUM(NSUInteger, RequestSerializerType) {
    
       RequestSerializerTypeJson ,
       RequestSerializerTypeHttp,
};
//网络数据成功回调block
typedef void (^succeedBlock)(RequestModel * _Nullable respondObject);
//网络数据失败回调
typedef void (^failureBlock)(RequestModel * _Nullable respondObject);

//网络数据进度回调block
typedef void (^uploadProgressBlock)(NSProgress * _Nullable uploadProgress);

//add by wu on 2019.09.24
typedef void (^HTTPCompleteBlock)(id _Nullable respObj, BOOL hasError);


@interface HttpRequestTool : NSObject
+ (AFHTTPSessionManager *_Nonnull)sessionManager;
+ (void)getWithURL:(NSString*_Nullable)url Parameters:(id _Nullable )parameters successBlock:(succeedBlock _Nullable ) success failureBlock:(failureBlock _Nullable )failure;

+ (void)postWithURL:(NSString*_Nullable)url Parameters:(id _Nullable )parameters  requestSerializerType:(RequestSerializerType)serializerType successBlock:(succeedBlock _Nullable ) success failureBlock:(failureBlock _Nullable )failure;

+ (void)postWithURL:(NSString*)url Parameters:(id )parameters  requestSerializerType:(RequestSerializerType)serializerType timeoutInterval:(NSTimeInterval)timeoutInterval  successBlock:(succeedBlock) success failureBlock:(failureBlock)failure;

///带有uploadProgress回调的post方法
+ (void)postWithURL:(NSString*_Nullable)url Parameters:(id _Nullable )parameters  requestSerializerType:(RequestSerializerType)serializerType uploadProgress:(uploadProgressBlock _Nullable )uploadProgressBlock successBlock:(succeedBlock _Nullable ) success failureBlock:(failureBlock _Nullable )failure;

+ (void)postWithURL:(NSString*_Nullable)url Parameters:(id _Nullable )parameters isEncryption:(BOOL)encryption  requestSerializerType:(RequestSerializerType)serializerType successBlock:(succeedBlock _Nullable ) success failureBlock:(failureBlock _Nullable )failure;


+ (void)putWithURL:(NSString*_Nullable)url Parameters:(id _Nullable )parameters  requestSerializerType:(RequestSerializerType)serializerType successBlock:(succeedBlock _Nullable ) success failureBlock:(failureBlock _Nullable )failure;

+ (void)deleteWithURL:(NSString*_Nullable)url Parameters:(id _Nullable )parameters  requestSerializerType:(RequestSerializerType)serializerType successBlock:(succeedBlock _Nullable ) success failureBlock:(failureBlock _Nullable )failure;

+ (SignModel*_Nonnull)encryption:(NSDictionary*_Nullable)parameters;

/// 3.5.5 新增 替换原来所有外面暴露的
+ (NSString *)getPublicInfoString;
@end


