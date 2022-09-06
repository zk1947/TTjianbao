//
//  JHSQBasePostCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YDBaseTableViewCell.h"
#import "JHSQHelper.h"
#import "JHSQModel.h"
#import "JHSQUserInfoView.h"
#import "JHSQOptionToolBar.h"
#import "JHSQHotCommentView.h"
#import "JHBaseOperationModel.h"
#import "JHBaseOperationView.h"
#import "JHPostCellHeader.h"

typedef NS_ENUM(NSInteger, JHActionType) {
    ///点击右上角更多
    JHActionTypeMore = 1,
    ///点击底部分享按钮的快速操作
    JHActionTypeFastOperate,
};

NS_ASSUME_NONNULL_BEGIN

@interface JHSQBasePostCell : YDBaseTableViewCell

@property (nonatomic, strong) JHPostData *postData;
/** 点击更多选项回调<点点点> */
@property (nonatomic, copy) JHActionBlocks operationAction;


#pragma mark - 公共视图
/** 用户信息栏 */
@property (nonatomic, strong) JHSQUserInfoView *userInfoView;

/** 互动工具栏 */
@property (nonatomic, strong) JHSQOptionToolBar *toolBar;

/** 热评内容 */
@property (nonatomic, strong) JHSQHotCommentView *hotCommentView;

/** 底部分割线 (h=10) */
@property (nonatomic, strong) UIView *bottomLine;

/** 当前所属控制器类型 */
@property (nonatomic, assign) JHPageType pageType;

/**372新增:是否支持视频详情页*/
@property (nonatomic, assign) BOOL supportEnterVideo;

#pragma mark -------- 为了埋点加的方法 --------

///。。。
- (void)baseMoreAction;

///点击头像
- (void)baseAvatarAction;

///点击评论
- (void)baseCommentAction;

///点击点赞
- (void)baseLikeAction;

///点击取消点赞
- (void)baseUnLikeAction;

///点击分享
- (void)baseShareAction;

///点击动态全文
- (void)baseFullTextAction;

///进入详情
- (void)baseEnterDetailAction;

///点击动态图片
- (void)baseDynamicPhotoAction;

///点击动态快捷评论框
- (void)baseQuickCommentAction;

- (JHPageFromType)getPageFrom:(JHPageType)type actionType:(JHActionType)action;

@end

NS_ASSUME_NONNULL_END
