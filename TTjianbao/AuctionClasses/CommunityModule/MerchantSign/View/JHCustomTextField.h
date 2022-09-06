//
//  JHCustomTextField.h
//  TTjianbao
//
//  Created by apple on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomTextField : UITextField
///左侧文字
@property (nonatomic, copy) NSString *leftText;

@property (nonatomic, assign) BOOL showBottomLine;

- (instancetype)initWithLeftWith:(CGFloat)leftWith;


@end

NS_ASSUME_NONNULL_END
