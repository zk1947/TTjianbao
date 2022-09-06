//
//  JHCommentTagView.h
//  TTjianbao
//
//  Created by mac on 2019/5/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCommentTagView : BaseView
@property (nonatomic, copy) NSDictionary *tagArray;
@property (nonatomic, copy) void (^finish)(CGFloat height);
@property (nonatomic, assign) NSInteger starCount;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, copy) JHActionBlock clickTagFinish;

//显示tag
- (void)showTagArray:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
