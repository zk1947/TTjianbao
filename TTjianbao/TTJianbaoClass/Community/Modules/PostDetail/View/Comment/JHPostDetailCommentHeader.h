//
//  JHPostDetailCommentHeader.h
//  TTjianbao
//
//  Created by lihui on 2020/8/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHPostDetailCommentHeader : UIView

///评论总数
@property (nonatomic, copy) NSString *commentCount;

@property (nonatomic, copy) void(^actionBlock)(void);

@end

NS_ASSUME_NONNULL_END
