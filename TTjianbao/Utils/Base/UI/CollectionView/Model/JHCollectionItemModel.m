//
//  JHCollectionItemModel.m
//  TTjianbao
//
//  Created by jesee on 19/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCollectionItemModel.h"

@implementation JHCollectionItemModel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if(self = [super init])
    {
        _style = [coder decodeIntegerForKey:@"jh_style"];
        _image = [coder decodeObjectForKey:@"jh_image"];
        _title = [coder decodeObjectForKey:@"jh_title"];
        _itemId = [coder decodeObjectForKey:@"jh_itemId"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInteger:_style forKey:@"jh_style"];
    [coder encodeObject:_image forKey:@"jh_image"];
    [coder encodeObject:_title forKey:@"jh_title"];
    [coder encodeObject:_itemId forKey:@"jh_itemId"];
}


- (void)setName:(NSString *)name{
    _title = name;
}

- (void)setId:(NSString *)id{
    _itemId = id;
}

@end
