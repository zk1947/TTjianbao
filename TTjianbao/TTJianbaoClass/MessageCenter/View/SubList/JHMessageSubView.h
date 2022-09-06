//
//  JHMessageSubView.h
//  TTjianbao
//  Description:消息中心分类(二级类别)View
//  Created by jesee on 22/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMessageHeader.h"
#import "JHMsgSubListLikeCommentModel.h"

@protocol JHMessageSubviewDelegate <NSObject>

@optional
- (void) messageSubviewEvents:(JHMsgSubEventsType)type data:(id)data;

@end

@interface JHMessageSubView : UIView

@property (nonatomic, weak) id<JHMessageSubviewDelegate>delegate;

- (instancetype) initWithFrame:(CGRect)rect pageType:(NSString*)type;
- (NSIndexPath*)indexPathFromCell:(UITableViewCell*)cell;
- (void)refreshShowData:(NSMutableArray*)array;
- (void)refreshCellIndexPath:(NSIndexPath*)indexPath isDelete:(BOOL)isDelete;
- (void)endTableRefresh;

- (void)refreshJHMsgSubListLikeCommentModelData:(NSArray<JHMsgSubListLikeCommentModel *> *)list;

@end

