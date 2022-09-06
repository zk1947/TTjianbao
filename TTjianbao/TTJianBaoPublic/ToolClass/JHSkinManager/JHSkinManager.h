//
//  JHSkinManager.h
//  test
//
//  Created by YJ on 2020/12/17.
//  Copyright © 2020 YJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHSkinModel.h"
#import "TTJianBaoColor.h"


typedef enum : NSUInteger {
    /// 首页标题
    JHSkinTypeTitle,
    /// 导航栏
    JHSkinTypeNavi,
    /// 消息按钮
    JHSkinTypeMessage,
    JHSkinTypeMessageNumBg,
    JHSkinTypeMessageNumTitle,
    /// 签到按钮
    JHSkinTypeSign,
    /// 分类按钮
    JHSkinTypeCategory,
    /// 主区域背景 - 导航下方区域
    JHSkinTypeBGHome,
    /// 直播图标 - banner - 有 直播显示
    JHSkinTypeLiveIcon,
    /// tabbar - title
    JHSkinTypeBarTitle,
    /// tabbar - index : 0 宝友集市
    JHSkinTypeBarIndex0,
    /// tabbar - index : 1 源头直购-首页
    JHSkinTypeBarIndex1,
    /// tabbar - index : 2 天天商城
    JHSkinTypeBarIndex2,
    /// tabbar - index : 3 鉴定回收
    JHSkinTypeBarIndex3,
    /// tabbar - index : 4 个人中心
    JHSkinTypeBarIndex4,
    /// tabbar - 返回顶部
    JHSkinTypeBarGoTop,
    /// 平台保障-Title
    JHSkinTypePlatformTitle,
    /// 平台保障-背景
    JHSkinTypePlatformBg,
    /// 平台保障-右箭头
    JHSkinTypePlatformRight,
    /// 平台保障- index - 0 - 低价购
    JHSkinTypePlatform0,
    /// 平台保障- index - 1 - 专家逐件把关
    JHSkinTypePlatform1,
    /// 平台保障- index - 2 - 7天无理由
    JHSkinTypePlatform2,
    /// 金刚位 - title
    JHSkinTypeVajraTitle,
} JHSkinType;



NS_ASSUME_NONNULL_BEGIN
typedef void(^DownloadSuccessHandler) (void);
#define  POST_JHHOMETABCONTROLLER   @"POST_JHHOMETABCONTROLLER"
#define SIZE_WIDTH  25

@interface JHSkinManager : NSObject

@property (nonatomic, copy) DownloadSuccessHandler downloadSuccessHandler;

@property (nonatomic, assign) JHSkinType type;

+ (instancetype)shareManager;

/* 请求皮肤data */
+ (void)requeastSkinData;

/* 皮肤data存储 */
+ (void)storeSkinData:(NSDictionary *)data;

/* 读取皮肤data */
+ (NSDictionary *)getSkinData;

/* clear皮肤data以及相关标识 */
+ (void)clearSkinData;
/// 获取 换肤数据
+ (JHSkinModel *)getSkinInfoWithType : (JHSkinType)type;
+ (UIImage *)getImageWithName : (NSString *)name;
+ (UIImage *)getImageWithPath : (NSString *)path;
+ (UIImage *)getImageWithName : (NSString *)name scaleSize : (CGSize)size;
+ (UIImage *)getImageWithPath : (NSString *)path scaleSize : (CGSize)size;
/* 直播购物 */
//+ (JHSkinModel *)liveShopping;
//
///* 天天定制 */
//+ (JHSkinModel *)ttCustomize;
//
///* 特卖商城 */
//+ (JHSkinModel *)saleStore;
//
///* 文玩社区 */
//+ (JHSkinModel *)oneDefini;
//
///* 源头直购 */
//+ (JHSkinModel *)twoDefini;
//
///* + */
//+ (JHSkinModel *)threeDefini;
//
///* 在线鉴定 */
//+ (JHSkinModel *)fourDefini;
//
///* 个人中心 */
//+ (JHSkinModel *)fiveDefini;
//
///* 搜索 */
//+ (JHSkinModel *)search;
//
///* 签到 */
//+ (JHSkinModel *)sign;
///* 分类 */
//+ (JHSkinModel *)category;
///* 消息 */
//+ (JHSkinModel *)message;
//
///* 红点 */
//+ (JHSkinModel *)redBottom;
//
///* 红点数字 */
//+ (JHSkinModel *)numColor;
//
///* 金刚位 */
//+ (JHSkinModel *)kimFont;
//
///* 一级导航选择器 */
//+ (JHSkinModel *)navigation;
//
///* 平台保障色 */
//+ (JHSkinModel *)platformBottom;
//
///* 平台保障字色 */
//+ (JHSkinModel *)platformFont;
//
///* 背景body */
//+ (JHSkinModel *)entiretyBody;
///* 背景head */
//+ (JHSkinModel *)entiretyHead;
//
///* 源头直播低价购image  */
//+ (JHSkinModel *)sourceLive;
///* 专家逐件把关image  */
//+ (JHSkinModel *)experts;
///* 7天无理由退换image  */
//+ (JHSkinModel *)exchange;
///* 平台保障右箭头image  */
//+ (JHSkinModel *)platformRight;
///* 直播图标image  */
//+ (JHSkinModel *)liveBottom;
///* 返回顶部image*/
//+ (JHSkinModel *)top;
//
///* 底部导航字色 */
//+ (JHSkinModel *)bottomNavigation;

+ (NSDictionary *)skinValueForKey:(NSString *)key;

/* 皮肤版本 */
+ (NSString *)getSkinVersion;

/* 是否换肤 */
+ (BOOL)isChangeSkin;

/* 存储换肤指令 */
+ (void)storeChangeSkinInstruction:(NSString *)instruction;

/* 下载皮肤资源包，解压，本地存储 */
+ (void)downLoadSkinResourcePack:(NSString *)url;

/* 存储对应的皮肤路径 key：图片对应名称 */
+ (void)storeSkinImagePath:(NSString *)imagePath forKey:(NSString *)imageName;

/* 读取对应的皮肤路径 key：图片对应名称 */
+ (NSString *)getSkinImagePath:(NSString *)imageName;

/* 解压完毕并存储是否成功 */
+ (BOOL)isStoreSuccess;

/* 获取解压后所有图片文件路径 */
+ (NSMutableArray *)getImagesPathWithSkinPath;

/* 根据图片name获取图片路径 */
+ (NSString *)getImageFilePath:(NSString *)imageNamed;

///* 直播购物未选中image */
//+ (UIImage *)getLiveShoppingUnselectedImage;
//
///* 直播购物选中image */
//+ (UIImage *)getLiveShoppingselectedImage;
//
///* 天天定制未选中image */
//+ (YYImage *)getTtCustomizeUnselectedImage;
//
///* 天天定制选中image */
//+ (YYImage *)getTtCustomizeselectedImage;
///// 直播首页 天天直播标题
//+ (UIImage *)getLiveTitleImage;
///* 特卖商城未选中image */
//+ (UIImage *)getSaleStoreUnselectedImage;
//
///* 特卖商城选中image */
//+ (UIImage *)getSaleStoreselectedImage;
//
//
///* 文玩社区tabBar未选中image */
//+ (UIImage *)getCommunityUnselectedImage;
//
///* 文玩社区tabBar选中image */
//+ (UIImage *)getCommunityselectedImage;
//
///* 源头直播tabBar未选中image */
//+ (UIImage *)getLiveBroadcastUnselectedImage;
//
///* 源头直播tabBar选中image */
//+ (UIImage *)getLiveBroadcastselectedImage;
//
///* 在线鉴定tabBar未选中image */
//+ (UIImage *)getOnlineIdentificationUnselectedImage;
//
///* 在线鉴定tabBar选中image */
//+ (UIImage *)getOnlineIdentificationselectedImage;
//
///* 个人中心tabBar未选中image */
//+ (UIImage *)getPersonalCenterUnselectedImage;
//
///* 个人中心tabBar选中image */
//+ (UIImage *)getPersonalCenterselectedImage;
//
///* 发布tabBar未选中image */
//+ (UIImage *)getPublishUnselectedImage;
//
///* 发布tabBar选中image */
//+ (UIImage *)getPublishselectedImage;
//
///* 搜索 */
//+ (UIImage *)getSearchImage;
//
///* 签到未签 */
//+ (UIImage *)getSignBeforeImage;
//
///* 签到已签 */
//+ (UIImage *)getSignAfterImage;
//+ (UIImage *)getCategoryImage;
///* 消息 */
//+ (UIImage *)getMessageImage;
//
///* 源头直播低价购image  */
//+ (UIImage *)getSourceLiveImage;
//
///* 专家逐件把关image  */
//+ (UIImage *)getExpertsImage;
//
///* 7天无理由退换image  */
//+ (UIImage *)getExchangeImage;
//
///* 平台保障右箭头image  */
//+ (UIImage *)getPlatformRightImage;
//
///* 直播图标image  */
//+ (YYImage *)getLiveBottomImage;
//
///* 文玩社区tabBar未选中字色 */
//+ (UIColor *)getCommunityUnselectedColor;
//
///* 文玩社区tabBar选中字色 */
//+ (UIColor *)getCommunityselectedColor;
//
///* 背景body */
//+ (UIImage *)getEntiretyBodyImage;
///* 背景head */
//+ (UIImage *)getEntiretyHeadImage;
//
///* 返回顶部image*/
//+ (UIImage *)getTopImage;

+ (BOOL)getImagePathExtension:(NSString *)imageName;
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
