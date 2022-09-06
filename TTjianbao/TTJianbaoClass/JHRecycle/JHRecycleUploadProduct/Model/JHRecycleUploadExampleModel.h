//
//  JHRecycleUploadExampleModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleUploadSeleteTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleUploadExampleModel : NSObject
/// 示例图片描述
@property(nonatomic, copy) NSString * exampleDesc;

/// 宝贝分类id
@property(nonatomic, copy) NSString * categoryId;

/// 示例id
@property(nonatomic, copy) NSString * exampleId;

/// 图片
@property(nonatomic, strong) JHRecycleUploadImageInfoModel * baseImage;

/// 商品图片类型：1 正面，2 背面 3 侧面 4 穿孔
@property(nonatomic, assign) NSInteger imgType;

@end


@interface JHRecycleUploadExampleTotalModel : NSObject

@property(nonatomic, strong) NSArray<JHRecycleUploadExampleModel*> * singleImgSimples;

@property(nonatomic, strong) NSArray<JHRecycleUploadExampleModel*> * multiImgSimples;

@property(nonatomic, copy) NSString *firstCategoryName; //标题
@property(nonatomic, copy) NSString *descTip; //钱币描述
@property(nonatomic, copy) NSString *videoDesc; //其他细节
@property(nonatomic, copy) NSString *pictureDesc; //钱bi图片
@property(nonatomic, copy) NSString *sampleDesc; //标题
@end


NS_ASSUME_NONNULL_END
