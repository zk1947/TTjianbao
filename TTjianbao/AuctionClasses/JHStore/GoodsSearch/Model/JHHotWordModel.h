//
//  JHHotWordModel.h
//  TTjianbao
//
//  Created by LiHui on 2020/2/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JHHotWordTarget;

@interface JHHotWordModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *item_id;
@property (nonatomic, strong) NSNumber *item_type;
@property (nonatomic, strong) NSNumber *wh_scale;
@property (nonatomic, strong) NSNumber *layout;
@property (nonatomic, strong) JHHotWordTarget *target;
@property (nonatomic, copy) NSString *name;


@end

@interface JHHotWordTarget : NSObject

@property (nonatomic, copy) NSString *componentName;
@property (nonatomic, copy) NSDictionary *params;
@property (nonatomic, copy) NSString *vc;

@end

NS_ASSUME_NONNULL_END
