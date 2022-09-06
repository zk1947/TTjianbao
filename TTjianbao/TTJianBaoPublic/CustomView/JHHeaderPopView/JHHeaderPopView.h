//
//  JHHeaderPopView.h
//  test
//
//  Created by YJ on 2020/12/15.
//  Copyright © 2020 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHHeaderUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHHeaderPopView : UIView

- (instancetype)initWithUserInfo:(NSDictionary *)info;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
