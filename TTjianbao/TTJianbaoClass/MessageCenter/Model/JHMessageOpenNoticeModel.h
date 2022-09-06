//
//  JHMessageOpenNoticeModel.h
//  TTjianbao
//
//  Created by Jesse on 2020/2/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMessageOpenNoticeModel : NSObject

@property (nonatomic, copy) NSString* image;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* desc;

+ (NSMutableArray*)dataArray;
@end

NS_ASSUME_NONNULL_END
