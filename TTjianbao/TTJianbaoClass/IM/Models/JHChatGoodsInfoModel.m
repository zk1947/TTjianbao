//
//  JHChatGoodsInfoModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatGoodsInfoModel.h"

@implementation JHChatCustomGoodsModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = JHChatCustomTypeGoods;
    }
    return self;
}
- (NSString *)encodeAttachment
{
    return [self mj_JSONString];
}
@end

#pragma mark - goods
@implementation JHChatGoodsInfoModel

@end


