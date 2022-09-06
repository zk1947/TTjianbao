//
//  JHCollectionItemModel.h
//  TTjianbao
//  Description:collection item 接收数据通用类型
//  Created by jesee on 19/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JHCollectionItemStyle)
{
    JHCollectionItemStyleDefault, //默认没有附加功能
    JHCollectionItemStyleDelete, //具有删除功能
};

@interface JHCollectionItemModel : NSObject <NSCoding>
//显示&数据标记
@property (nonatomic, assign) JHCollectionItemStyle style; //item类型,区分附件功能
//网络数据
@property (nonatomic, copy) NSString *itemId; //子类ID
@property (nonatomic, copy) NSString *title; //子类title
@property (nonatomic, copy) NSString *image; //子类对应icon
@property (nonatomic, copy) NSString *bg_img; //子类对应icon
///名字(个人发布页面)
@property (nonatomic, copy) NSString *name;
///id(个人发布页面)
@property (nonatomic, copy) NSString *id;
@end

