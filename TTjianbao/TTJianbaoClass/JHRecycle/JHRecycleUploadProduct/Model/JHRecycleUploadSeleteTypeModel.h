//
//  JHRecycleUploadSeleteTypeModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleUploadSeleteTypeBannerModel : NSObject

@property(nonatomic, copy) NSString * imageUrl;
@property(nonatomic, copy) NSString * landingId;
@property(nonatomic, copy) NSString * landingTarget;
@property(nonatomic, copy) NSString * targetName;
@property(nonatomic, assign) NSInteger detailsId;

@end

@interface JHRecycleUploadImageInfoModel : NSObject

@property(nonatomic, copy) NSString * big;
@property(nonatomic, copy) NSString * h;
@property(nonatomic, copy) NSString * w;
@property(nonatomic, copy) NSString * medium;
@property(nonatomic, copy) NSString * origin;
@property(nonatomic, copy) NSString * small;

@end

@interface JHRecycleUploadSeleteTypeListModel : NSObject

@property(nonatomic, copy) NSString *categoryId;
@property(nonatomic, copy) NSString *categoryName;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *btnType;
@property(nonatomic, strong) JHRecycleUploadImageInfoModel * categoryImgUrl;

@end

@interface JHRecycleUploadSeleteTypeModel : NSObject

//Banner model数组
@property (nonatomic, strong) NSArray<JHRecycleUploadSeleteTypeBannerModel*> *bannerImgUrls;

//类别 model数组
@property (nonatomic, strong) NSArray<JHRecycleUploadSeleteTypeListModel*> *categoryVOs;

@end


NS_ASSUME_NONNULL_END
