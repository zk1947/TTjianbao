//
//  JHShopListMode.h
//  TTjianbao
//
//  Created by apple on 2019/12/17.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface JHShopListMode : YDBaseModel

@property (nonatomic, strong) NSMutableArray *list;

- (NSString *)toUrl; //获取全部话题列表的url
- (NSString *)toSearchUrlWithKey:(NSString *)key;
- (void)configModel:(JHShopListMode *)model;

@end

NS_ASSUME_NONNULL_END
