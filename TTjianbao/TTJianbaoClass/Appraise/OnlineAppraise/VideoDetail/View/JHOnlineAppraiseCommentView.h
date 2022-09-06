//
//  JHOnlineAppraiseCommentView.h
//  TTjianbao
//
//  Created by lihui on 2020/12/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGestView.h"

///在线鉴定首页 - 视频详情页评论列表部分

NS_ASSUME_NONNULL_BEGIN

@class JHPostDetailModel;
@class AppraisalDetailMode;

typedef void (^HideCopleteBlock)(AppraisalDetailMode * mode);

@interface JHOnlineAppraiseCommentView : JHGestView

@property (nonatomic, strong) JHPostDetailModel *postDetail;
@property(strong,nonatomic)HideCopleteBlock  hideCompleteBlock;
/** 进入评论的时间戳,埋点使用*/
@property (nonatomic, copy) NSString *timstampString;
- (void)show;
- (void)dismiss;

- (void)refreshData;

@end

NS_ASSUME_NONNULL_END
