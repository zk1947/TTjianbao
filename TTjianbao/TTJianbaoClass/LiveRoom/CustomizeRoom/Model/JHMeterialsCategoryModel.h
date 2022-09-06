//
//  JHMeterialsCategoryModel.h
//  TTjianbao
//
//  Created by apple on 2020/11/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMeterialsCategoryModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, assign) BOOL supportFlag; //1 支持， 0 不支持
@property (nonatomic, assign) BOOL customizeFlag;//第二步1 支持， 0 不支持
@property (assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
