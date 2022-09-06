//
//  JHFansAlterNickNameView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHFansAlterNickNameView : UIView

@property (nonatomic, copy) JHFinishBlock  alterNameBlock;
@property (nonatomic, strong) UITextField *textField;
@end

NS_ASSUME_NONNULL_END
