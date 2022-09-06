//
//  JHRecycleUploadProductViewController.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 回收商品上传填写信息控制器
@interface JHRecycleUploadProductViewController : JHBaseViewController

/// 类型id
@property(nonatomic, copy) NSString *categoryId;

/// 类型名称
@property(nonatomic, copy) NSString * typeName;

/// 类型图片
@property(nonatomic, copy) NSString * typeImageName;


/// 商家id  直播间跳转需要
@property(nonatomic, copy) NSString * businessId;
@end

NS_ASSUME_NONNULL_END
