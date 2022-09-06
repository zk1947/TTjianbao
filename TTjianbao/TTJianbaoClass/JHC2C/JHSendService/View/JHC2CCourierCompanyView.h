//
//  JHC2CCourierCompanyView.h
//  TTjianbao
//
//  Created by hao on 2021/6/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  快递公司弹窗

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CCourierCompanyView : UIView
@property (nonatomic, copy) void(^selectCompleteBlock)(NSInteger selectIndex);
@property (nonatomic, copy) NSArray *expressCompanyListData;
- (void)show;
@end

NS_ASSUME_NONNULL_END
