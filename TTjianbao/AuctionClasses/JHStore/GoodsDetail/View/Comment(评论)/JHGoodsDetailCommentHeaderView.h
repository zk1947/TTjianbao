//
//  JHGoodsDetailCommentHeaderView.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  评论header
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCellId_GoodsDetailCommentHeader = @"commentHeader";


@interface JHGoodsDetailCommentHeaderView : UICollectionReusableView

- (void)setTitleStr:(NSString *)titleStr gradeStr:(NSString *)gradeStr;

@end

NS_ASSUME_NONNULL_END
