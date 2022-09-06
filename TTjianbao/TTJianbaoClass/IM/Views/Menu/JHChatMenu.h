//
//  JHChatMenu.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHChatMenuItemModel.h"

typedef void(^SelectedHandler)(JHChatMenuItemModel * _Nullable model);

NS_ASSUME_NONNULL_BEGIN

@interface JHChatMenu : UIView
@property (nonatomic, copy) SelectedHandler handler;
+ (instancetype)shared;
+ (void)showMenuInView : (UIView *)view items : (NSArray<JHChatMenuItemModel *> *)items handler : (SelectedHandler)handler;
@end

NS_ASSUME_NONNULL_END
