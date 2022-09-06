//
//  JHNewStoreHomeNavView.h
//  TTjianbao
//
//  Created by user on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreHomeNavView : UIView
@property (nonatomic, strong) NSArray *hotKeysArray;
@property (nonatomic,   copy) dispatch_block_t searchClickBlock;
@property (nonatomic,   copy) void(^searchScrollBlock)(NSInteger index);
@property (nonatomic,   copy) dispatch_block_t messageBtnClickBlock;
- (void)reloadHotKeys;
- (void)reloadAnimation:(CGFloat)offset;
- (void)reloadMessageInfoCount:(NSString *)count;
@end

NS_ASSUME_NONNULL_END
