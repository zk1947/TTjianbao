//
//  JHPopBaseView.h
//  TTjianbao
//
//  Created by mac on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPopBaseView : BaseView
- (void)showAlert;
- (void)hiddenAlert;
- (void)closeAction:(UIButton *)btn;
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIButton *closeBtn;


@end

NS_ASSUME_NONNULL_END
