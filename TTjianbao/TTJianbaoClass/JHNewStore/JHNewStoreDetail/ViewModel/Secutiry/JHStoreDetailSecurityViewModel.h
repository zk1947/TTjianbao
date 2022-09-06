//
//  JHStoreDetailSecurityViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品保障信息ViewModel

#import <Foundation/Foundation.h>
#import "JHStoreDetailCellBaseViewModel.h"
#import "JHAppBusinessModelManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailSecurityViewModel : JHStoreDetailCellBaseViewModel


/// 是否直发
@property(nonatomic) BOOL  directDelivery;
/// 当前商品模式
@property (nonatomic, assign) JHBusinessModel currentBusinessModel;

@end

NS_ASSUME_NONNULL_END
