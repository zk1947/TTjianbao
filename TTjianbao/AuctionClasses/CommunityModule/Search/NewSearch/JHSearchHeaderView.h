//
//  JHSearchHeaderView.h
//  TTjianbao
//
//  Created by liuhai on 2021/10/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSearchHeaderView : UIView
@property (nonatomic,strong) UILabel * titleLabel;
- (instancetype)initWithFrame:(CGRect)frame withTitleName:(NSString*)str;
@end

NS_ASSUME_NONNULL_END
