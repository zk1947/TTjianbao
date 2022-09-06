//
//  JHChatMenuItemModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    /// 复制
    JHChatMenuItemTypeCopy,
    /// 删除
    JHChatMenuItemTypeDelete,
    /// 撤销
    JHChatMenuItemTypeRevoke,
} JHChatMenuItemType;

@interface JHChatMenuItemModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, assign) JHChatMenuItemType type;

- (instancetype)initWithType : (JHChatMenuItemType)type title : (NSString *)title iconName : (NSString *)iconName;
@end

NS_ASSUME_NONNULL_END
