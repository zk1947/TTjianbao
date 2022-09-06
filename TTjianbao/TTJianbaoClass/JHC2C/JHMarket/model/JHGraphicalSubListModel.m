//
//  JHGraphicalSubListModel.m
//  TTjianbao
//
//  Created by miao on 2021/6/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGraphicalSubListModel.h"
#import "NSString+JHCoreOperation.h"
#import "JHGraphicalBottomModel.h"

@interface JHGraphicalSubListModel ()

@property(assign,nonatomic) BOOL  isSeller;

@end

@implementation JHGraphicalSubListModel

- (instancetype)initWithIsSeller:(BOOL)isSeller {
    self = [super init];
    if (self) {

        _isSeller = isSeller;
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"resultList" : [JHGraphicalSubModel class],
      
    };
}

- (NSArray<JHGraphicalSubModel *> *)resultList {
    
    NSMutableArray *resultList = [NSMutableArray arrayWithCapacity:1];
    for (JHGraphicalSubModel *model in _resultList) {
          model.isSeller = self.isSeller;
        [resultList addObject:model];
    }
    return [resultList copy];
}

@end

@implementation JHGraphicalSubModel

- (NSString *)showImageSmallUrl {
    NSString *small = [self.goodsImg objectForKey:@"small"];
    return [NSString safeGet_ttjb:small];
}

- (NSArray<JHGraphicalBottomModel *> *)bottomButtons {
    NSMutableArray *resultList = [NSMutableArray arrayWithCapacity:1];
    NSArray *allKeys = self.buttonsVo.allKeys;
    for (NSString *key in allKeys) {
        NSString *isShow = [self.buttonsVo objectForKey:key];
        JHGraphicalBottomModel *model = [[JHGraphicalBottomModel alloc]init];
        model.kindName = key;
        model.isShow = [isShow isEqualToString:@"1"] ? YES : NO;
        if (model.isShow) {
            [resultList addObject:model];
        }
    }
    return [[resultList reverseObjectEnumerator] allObjects];
}

@end
