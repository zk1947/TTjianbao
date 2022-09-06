//
//  JHPhotoExampleViewController.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/31.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class JHRecycleUploadExampleModel;

@interface JHPhotoExampleViewController : JHBaseViewController

/// 类型id
@property(nonatomic, copy) NSString* categoryId;

/// 单个 多个
@property(nonatomic, assign) NSInteger showType;// “1“单个  2多个

@property(nonatomic, strong) NSArray <JHRecycleUploadExampleModel *> * singleModelArr;

@property(nonatomic) BOOL useLocalData;

@end

NS_ASSUME_NONNULL_END
