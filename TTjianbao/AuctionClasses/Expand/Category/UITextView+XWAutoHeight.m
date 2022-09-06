//
//  UITextView+XWAutoHeight.m
//  XWTextViewAutoHeight
//
//  Created by cgw on 2018/12/5.
//  Copyright © 2018 bill. All rights reserved.
//

#import "UITextView+XWAutoHeight.h"

@implementation UITextView (XWAutoHeight)

- (void)autoChangeWithMinHeight:(CGFloat)minHeight maxHeight:(CGFloat)maxHeight changeBlock:(XWChangeHeightBlock)changeHeightBlock{
    
    NSMutableArray *objects = [NSMutableArray arrayWithObjects:@(maxHeight),@(minHeight), nil];
    if( changeHeightBlock ){
        [objects addObject:changeHeightBlock];
    }
    //__bridge_retained 持有objects 避免传过去的Objects 已经被释放
    [self registerForKVOWithContext:(__bridge_retained void*)objects];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    //取得新的contentSize的值
    NSValue *sizeValue =
    [self getNewValueWithObject:object change:change];
    if( !sizeValue ) return;
    
    //取得传递过来的minHeight, maxHeight, 回调block
    CGFloat maxHeight = 0, minHeight = 0;
    XWChangeHeightBlock changeBlock =
    [self getChangeBlockWithMaxHeight:&maxHeight minHeight:&minHeight context:context];
    
    //计算textview的新高度
    CGFloat newHeight =
    [self getNewHeightWithValue:sizeValue minHeight:minHeight maxHeight:maxHeight];
    
    //设置textview的高度，设置成功则回调，未成功则不回调
    if( [self changeTextViewFrameWithNewHeight:newHeight] && changeBlock ){
        
        changeBlock(newHeight);
    }
}

- (void)dealloc{
    [self removeObserverAndCache];
}

#pragma mark - Private

/**
 更改textview的高度
 
 @param newHeight 新的高度
 @return YES 修改成功，NO 未修改
 */
- (BOOL)changeTextViewFrameWithNewHeight:(CGFloat)newHeight{
    CGRect fr = self.frame;
    //若textview的高度与新的高度一致，则不改变高度也不回调
    if( ABS(fr.size.height - newHeight) < self.zeroValue){
        return NO;
    }
    
    fr.size.height = newHeight;
    self.frame = fr;
    return YES;
}

- (CGFloat)getNewHeightWithValue:(NSValue*)newValue minHeight:(CGFloat)minHeight maxHeight:(CGFloat)maxHeight{
    CGFloat zeroValue = [self zeroValue];
    CGFloat newHeight = newValue.CGRectValue.size.height;
    //若最大高度不为0，则比较最大高度
    if( maxHeight > zeroValue ){
        if( newHeight > maxHeight ){
            newHeight = maxHeight;
        }
    }
    
    //若最小高度不为0，则设置最小高度
    if( minHeight > zeroValue ){
        if( newHeight < minHeight ){
            newHeight = minHeight;
        }
    }
    
    return newHeight;
}

- (NSValue*)getNewValueWithObject:(NSObject*)object change:(NSDictionary*)change{
    if( ![object isKindOfClass:[UITextView class]] ) return nil;
    if( ![change isKindOfClass:[NSDictionary class]] ) return nil;
    
    NSValue *sizeValue = change[@"new"];
    if( [sizeValue isKindOfClass:[NSValue class]] ) return sizeValue;
    
    return nil;
}

- (XWChangeHeightBlock)getChangeBlockWithMaxHeight:(CGFloat*)maxHeight minHeight:(CGFloat*)minHeight context:(void*)context{
    
    if( context == nil ) return nil;
    
    NSArray *objects = (__bridge NSArray*)context;
    
    if( objects && [objects isKindOfClass:[NSArray class]] ){
        if( objects.count >= 2 ){
            NSNumber *num = (NSNumber*)objects[0];
            *maxHeight = num.floatValue;
            
            num = (NSNumber*)objects[1];
            *minHeight = num.floatValue;
        }
        
        if (objects.count == 3 ){
            id block = objects[2];
            if( [block isKindOfClass:[NSClassFromString(@"__NSGlobalBlock") class]] ){
                return block;
            }
        }
    }
    
    return nil;
}

- (void)removeObserverAndCache{
    //移除观察者
    [self unregisterFromKVO];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.markKey];
}

#pragma mark - 常量值
- (CGFloat)zeroValue{
    return 0.000001;
}

- (NSString*)keyPath{
    return @"contentSize";
}

- (NSString*)markKey{
    NSString *key = [NSString stringWithFormat:@"%p",(self)];
    return key;
}

#pragma mark - 注册和移除KVO
- (void)registerForKVOWithContext:(void*)context {
    
    //若已经添加过KVO，则不再添加
    if( [[NSUserDefaults standardUserDefaults] boolForKey:self.markKey] ){
        NSLog(@"已添加过观察者，本次添加会被忽略");
        return;
    }
    
    [self addObserver:self forKeyPath:self.keyPath options:(NSKeyValueObservingOptionNew) context:context];
    
    //添加一个标记，用来标记已经添加过观察者，为了移除观察者
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.markKey];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeObserverAndCache) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)unregisterFromKVO {
    if( [[NSUserDefaults standardUserDefaults] boolForKey:self.markKey] ){
        [self removeObserver:self forKeyPath:self.keyPath];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    }
}

@end

