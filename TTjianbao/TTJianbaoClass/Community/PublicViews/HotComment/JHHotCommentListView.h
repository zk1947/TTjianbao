//
//  JHHotCommentListView.h
//  TTjianbao
//
//  Created by lihui on 2020/11/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHCommentData;

@interface JHHotCommentListView : UIView
///热评
@property (nonatomic, strong) JHCommentData *hotComment;
@property (nonatomic, assign) BOOL showLine;

@end

NS_ASSUME_NONNULL_END
