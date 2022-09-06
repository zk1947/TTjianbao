//
//  JHNewStoreBannerModel.h
//  TTjianbao
//
//  Created by user on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//
//@interface BannerMode : NSObject
//@property (strong,nonatomic)NSString* picDes;
//@property (strong,nonatomic)NSString * picId;
//@property (strong,nonatomic)NSString* picLink;
//@property (strong,nonatomic)NSString * picName;
//@property (strong,nonatomic)NSString* picSort;
//@property (strong,nonatomic)NSString* picUrl;
//@end

//1社区信息流 2源头直播 3鉴定 4个人中心 5 启动页
//typedef NS_ENUM(NSInteger, JHBannerAdType) {
//    
//    JHBannerAdTypeNone = 0,
//    JHBannerAdTypeCommunity,
//    JHBannerAdTypeSaleMall,
//    JHBannerAdTypeAppraise,
//    JHBannerAdTypePersonal,
//    JHBannerAdTypeLaunchApp
//};

@interface JHNewStoreBannerTargetModel : NSObject
@property (nonatomic,   copy) NSString            *componentName;
@property (nonatomic,   copy) NSString            *vc;//专题专区点击返回
@property (nonatomic, strong) NSMutableDictionary *params;
@end

@interface JHNewStoreBannerModel : NSObject
@property (nonatomic, strong) JHNewStoreBannerTargetModel *target;
@property (nonatomic,   copy) NSString                    *image;
@property (nonatomic,   copy) NSString                    *title;
@property (nonatomic, assign) CGFloat                      wh_scale;
@property (nonatomic,   copy) NSString                    *item_id;
@property (nonatomic,   copy) NSString                    *item_type;
@property (nonatomic,   copy) NSString                    *layout;
@end




NS_ASSUME_NONNULL_END
