//
//  JHAppraisePayCoponCell.h
//  TTjianbao
//
//  Created by jiangchao on 2021/6/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoponPackageMode.h"
typedef void (^JHIntroduceBlock)(int  cellIndex);
NS_ASSUME_NONNULL_BEGIN
@interface JHAppraisePayCoponCell : UITableViewCell
@property (nonatomic, copy) CoponMode *mode;
@property (nonatomic, assign) int cellIndex;
@property (nonatomic, copy) JHActionBlock buttonClick;
@property (nonatomic, copy) JHIntroduceBlock introduceClick;
@property (nonatomic, assign) BOOL isOrderCoupon;

@end


NS_ASSUME_NONNULL_END
