//
//  JHShareInfo.h
//  TTjianbao
//  Description:分享数据模型
//  Created by Jesse on 2020/10/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHShareInfo : NSObject

@property (nonatomic, copy) NSString *title; //分享标题
@property (nonatomic, copy) NSString *desc; //描述
@property (nonatomic, copy) NSString *img; //图片
@property (nonatomic, copy) NSString *url; //分享连接
@property (nonatomic, strong) id extenseData; //扩展数据
///自定义字段 页面来源
@property (nonatomic, assign) NSInteger pageFrom;//JHPageFromType
@property (nonatomic, assign) NSInteger shareType; //分享类型:ShareObjectType

///埋点专用
@property (nonatomic, copy) NSString *eventId;
@end

NS_ASSUME_NONNULL_END
