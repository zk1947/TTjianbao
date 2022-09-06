//
//  JHPostCommentFooterView.h
//  TTjianbao
//
//  Created by lihui on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface JHPostCommentFooterView : UIView

@property (nonatomic, copy) void(^unfoldBlock)(NSInteger footerSection, JHPostCommentFooterView *footer);
@property (nonatomic, assign) NSInteger footerSection;
@property (nonatomic, assign) BOOL showBottomLine;

///评论条数
@property (nonatomic, copy) NSString *commentCount;

@end

NS_ASSUME_NONNULL_END
