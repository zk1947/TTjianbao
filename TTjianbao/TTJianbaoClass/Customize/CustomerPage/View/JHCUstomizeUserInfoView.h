//
//  JHCUstomizeUserInfoView.h
//  TTjianbao
//
//  Created by user on 2020/12/6.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YYControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCUstomizeUserInfoView : YYControl
- (void)setTitle:(NSString *)title value:(NSString *)value;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@end

NS_ASSUME_NONNULL_END
