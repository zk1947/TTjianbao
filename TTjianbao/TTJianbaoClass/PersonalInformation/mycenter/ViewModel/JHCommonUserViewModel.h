//
//  JHCommomUserViewModel.h
//  TTjianbao
//
//  Created by lihui on 2020/4/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JHShopWindowLayout;

@interface JHCommonUserViewModel : NSObject

@property (nonatomic, copy) NSString *signPageUrl;  ///签约h5页面的url
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray<NSArray *> *dataArray;
@property (nonatomic, strong) NSMutableArray *bannerModes;
///推荐数组
@property (nonatomic, strong) NSMutableArray <JHShopWindowLayout *>*recommendArray;

///获取签约的url
- (void)loadSignPageUrlCompeleteBlock:(void(^)(NSString *))block;

///获取banner的数据
- (void)requestBannersWithBlock:(void(^)(void))block;

///加载推荐数据
- (void)loadRecommendData:(BOOL)isRefresh completeBlock:(void(^)(BOOL hasData, BOOL hasError))block;

- (void)loadPersonCenterDataWithBlock:(void(^)(void))block;

///获取section的data
- (NSArray *)configSectionData;

///获取cell的data
- (NSArray *)configCellData;

///原石回血的data
- (NSArray *)resaleDataSource;

///获取用户的店铺信息
- (void)requestUserSellerInfo:(HTTPCompleteBlock)block;
///轮播图数据
- (void)requestBanners;
@end

NS_ASSUME_NONNULL_END
