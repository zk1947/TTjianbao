//
//  JHSearchTagsView.h
//  TTjianbao
//
//  Created by hao on 2021/10/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSearchTagsView : UIView
@property (nonatomic,   copy) NSArray *tagsDataArray;
///点击回调
@property (nonatomic, copy) void(^deleteClickBlock)(NSInteger selectIndex);

@end

NS_ASSUME_NONNULL_END
