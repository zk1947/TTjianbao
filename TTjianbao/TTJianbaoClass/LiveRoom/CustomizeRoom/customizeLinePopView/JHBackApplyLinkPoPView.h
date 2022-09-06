//
//  JHBackApplyLinkPoPView.h
//  TTjianbao
//
//  Created by apple on 2021/1/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBackApplyLinkPoPView : UIView
@property (nonatomic,copy) void(^cancelClickedBlock)(void);
- (void)removeSelf;
@end

NS_ASSUME_NONNULL_END
