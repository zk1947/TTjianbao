//
//  CommentToolView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CommentToolViewDelegate <NSObject>

- (void)OnClickComment:(NSString *)string;

@end

@interface CommentToolView : BaseView
@property (nonatomic,   weak) id<CommentToolViewDelegate> delegate;
@property (nonatomic, strong)  UITextField * commentTextField;
@property (nonatomic, assign)  float top;
@end

NS_ASSUME_NONNULL_END
