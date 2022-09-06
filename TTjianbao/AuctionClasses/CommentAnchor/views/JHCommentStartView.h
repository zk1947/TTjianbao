//
//  JHCommentStartView.h
//  TTjianbao
//
//  Created by mac on 2019/5/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCommentStartView : BaseView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, assign) CGFloat leftSpace;
@property (nonatomic, assign) NSInteger selectedCount;
@property (nonatomic, copy) JHActionBlock selectedComplete;
@property (nonatomic, assign) BOOL isShow;

@end

NS_ASSUME_NONNULL_END
