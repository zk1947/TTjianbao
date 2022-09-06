//
//  JHCustomizeLinkShowOrderView.h
//  TTjianbao
//
//  Created by apple on 2020/11/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHSystemMsgCustomizeOrder;
@interface JHCustomizeLinkShowOrderView : UIControl
@property (nonatomic, assign) BOOL isSeller;//主播端 助理端  YES   ，用户端NO
- (void)showViewWithModel:(JHSystemMsgCustomizeOrder *)model;
@end

NS_ASSUME_NONNULL_END
