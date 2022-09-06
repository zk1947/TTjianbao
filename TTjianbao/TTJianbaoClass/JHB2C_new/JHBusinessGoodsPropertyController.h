//
//  JHBusinessGoodsPropertyController.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessGoodsPropertyController : JHBaseViewController
@property(nonatomic, copy) NSString * selectCateId;
@property (nonatomic,copy)void(^sureClickBlock)(NSMutableArray * arrayModel);

- (instancetype)initWithArrayModel:(NSMutableArray *)attArray;
@end

NS_ASSUME_NONNULL_END
