//
//  NTESLiveChatView.h
//  TTjianbao
//
//  Created by chris on 16/3/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESMessageModel.h"
@protocol NTESLiveChatViewDelegate <NSObject>
@optional
- (void)onTapChatView:(CGPoint)point;
- (void)onClickeCellWithUid:(NSString *)uid;
- (void)onClickeCellWithModel:(NTESMessageModel *)model;
- (void)onClickeAnonymityUser;

@end

#import "BaseView.h"

@interface NTESLiveChatView : BaseView

@property (nonatomic,strong) UITableView *tableView;
-(void)cleanMessage;
@property (nonatomic,weak) id<NTESLiveChatViewDelegate> delegate;

- (void)addMessages:(NSArray<NIMMessage *> *)messages;

- (void)addCommonComeInMessages:(NIMMessage *)message;

@property (nonatomic, assign) BOOL  isAnchor;


@end
