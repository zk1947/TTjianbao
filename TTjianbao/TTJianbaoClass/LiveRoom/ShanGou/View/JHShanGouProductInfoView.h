//
//  JHShanGouProductInfoView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/9/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHShanGouModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JHShanGouProductInfoView : UIView
/// 商品编码
@property (nonatomic,   copy) NSString *productCode;

@property(nonatomic, strong) JHShanGouModel * shanGouModel;

/// 商品编码
@property (nonatomic,   copy) NSString *anchorId;

@property(nonatomic, copy) void(^jumpUserListBlock)(JHShanGouModel* _Nullable  productCode) ;

@end

NS_ASSUME_NONNULL_END
