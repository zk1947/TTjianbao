//
//  JHSQPostLiveRoomCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  帖子列表cell：直播间
//

#import "YDBaseTableViewCell.h"
#import "JHSQHelper.h"
#import "JHSQModel.h"
#import "JHSQUserInfoView.h"
#import "JHBaseOperationModel.h"
#import "JHBaseOperationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSQPostLiveRoomCell : YDBaseTableViewCell

@property (nonatomic, strong) JHPostData *postData;
@property (nonatomic, strong) UIView *stearmView; 
/** 点击更多选项回调<点点点> */
@property (nonatomic, copy) JHActionBlocks operationAction;

@property (nonatomic, copy) NSString *orderCount;


@end

NS_ASSUME_NONNULL_END
