//
//  NSArray+JHExtension.m
//  TTjianbao
//
//  Created by user on 2020/11/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "NSArray+JHExtension.h"

@implementation NSArray (Operations)
- (NSArray*)jh_unique {
    return [[NSSet setWithArray:self] allObjects];
}

- (NSMutableArray*)jh_map:(id (^)(id item, NSUInteger index))block {
    NSMutableArray*array = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL*_Nonnull stop) {
        id mapped = block(obj, idx);
        if (mapped) {
            [array addObject:mapped];
        } else {
            // NTYAssert(mapped, @"Cannot return nil for %@ %@", obj, @(idx));
            NSLog(@"Cannot return nil for %@ %@", obj, @(idx));
        }
    }];
    return array;
}


- (NSMutableArray*)jh_filter:(BOOL (^)(id item, NSUInteger index))block {
    NSMutableArray*array = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL*_Nonnull stop) {
        BOOL passed = block(obj, idx);
        if (passed) {
            [array addObject:obj];
        }
    }];
    return array;
}

- (NSMutableArray*)jh_split:(NSUInteger)count remindObjects:(BOOL)collect {
    if (count == 0) {
        NSAssert(count != 0, @"jh_split方法中，count不能为0");
        return nil;
    }
    NSMutableArray*array = [NSMutableArray arrayWithCapacity:self.count / count];
    for (NSUInteger i = 0; i < self.count; i = i + count) {
        NSMutableArray *splitList = [NSMutableArray arrayWithCapacity:count];
        // 从i起的count个元素加入到splitList
        for (NSUInteger j = 0; j < count; j++) {
            NSUInteger index = i + j;
            if (index < self.count) {
                [splitList addObject:self[index]];
            } else {
                break;
            }
        }
        if (collect || splitList.count == count) {
            [array addObject:splitList];
        }
    }

    return array;
}

- (NSString*)jh_joinedString:(NSString*)seperator {
    return [self componentsJoinedByString:seperator];
}

- (void)jh_each:(void (^)(id item, NSUInteger index))block {
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL*_Nonnull stop) {
        block(obj,idx);
    }];
}

- (void)jh_foreach:(void (^)(id item, NSUInteger index, BOOL*stop))block {
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL*_Nonnull stop) {
        block(obj,idx, stop);
    }];
}

- (void)jh_each:(NSArray<NSNumber*>*)indexes executor:(void (^)(id item, NSUInteger index))block {
    [indexes enumerateObjectsUsingBlock:^(NSNumber*_Nonnull obj, NSUInteger idx, BOOL *stop) {
        NSUInteger index = [obj unsignedIntegerValue];
        if (index < self.count) {
            block(self[index], index);
        }
    }];
}

- (id)jh_reduce:(id)begin executor:(id (^)(id item, NSUInteger index, id prev))block {
    __block id prev = begin;
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL*_Nonnull stop) {
        prev = block(obj,idx, prev);
    }];

    return prev;
}

- (NSMutableArray*)jh_joined:(NSArray*)array {
    if ([self isKindOfClass:[NSMutableArray
                             class]]) {
        [(NSMutableArray*) self addObjectsFromArray:array];
        return (NSMutableArray*)self;
    } else {
        NSMutableArray *result = self.mutableCopy;
        [result addObjectsFromArray:array];
        return result;
    }
}

- (id)jh_firstObjectPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL*stop))predicate {
    NSUInteger index = [self indexOfObjectPassingTest:predicate];
    if (index == NSNotFound) {
        return nil;
    }
    return self[index];
}
@end

@implementation NSArrayOperations
+ (NSMutableArray*)map:(NSArray*)input with:(id (^)(id item, NSUInteger index))block {
    return [input jh_map:block];
}
@end
