//
//  JHChatMenuItemModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatMenuItemModel.h"

@implementation JHChatMenuItemModel

- (instancetype)initWithType : (JHChatMenuItemType)type title : (NSString *)title iconName : (NSString *)iconName {
    self = [super init];
    if (self) {
        self.type = type;
        self.title = title;
        self.iconName = iconName;
    }
    return self;
}
@end
