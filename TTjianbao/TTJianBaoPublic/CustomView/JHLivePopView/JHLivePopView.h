//
//  JHLivePopView.h
//  test
//
//  Created by YJ on 2020/12/16.
//  Copyright © 2020 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHLivePopView : UIView

- (instancetype)initWithLiveInfo:(NSDictionary *)info;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
