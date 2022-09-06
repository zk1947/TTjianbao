//
//  JHMoreCommentFooter.h
//  TTjianbao
//
//  Created by lihui on 2020/8/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMoreCommentFooter : UIView
@property (nonatomic, copy) void(^moreCommentBlock)(void);
@property (nonatomic, copy) NSString *showString;


@end

NS_ASSUME_NONNULL_END
