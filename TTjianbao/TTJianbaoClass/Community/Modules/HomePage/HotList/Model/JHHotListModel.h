//
//  JHHotListModel.h
//  TTjianbao
//
//  Created by lihui on 2020/6/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JHPostData;

@interface JHHotListModel : NSObject

@property (nonatomic, copy) NSString *last_date;
@property (nonatomic, copy) NSString *now_date;
///标记是否为起始点 1:是起始点 0：不是起始点
@property (nonatomic, assign) BOOL is_begin;
@property (nonatomic, strong) NSArray<JHPostData *> *list;

@end

NS_ASSUME_NONNULL_END
