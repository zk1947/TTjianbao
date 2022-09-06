//
//  JHMessageCommentTableViewCell.m
//  TTjianbao
//
//  Created by jesee on 22/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMessageCommentTableViewCell.h"
#import "JHImage.h"

#define kMsgCommentTag 234

@interface JHMessageCommentTableViewCell ()
{
    UIButton* deleteButton;
    UIButton* commentButton;
    UIButton* likeButton;
    JHMsgSubListLikeCommentModel* dataModel;
}
@end

@implementation JHMessageCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self resetSubviewConstraints]; //需要修改subBgView约束,否则cell高度撑不起来
        [self drawButtonview];
    }
    
    return self;
}

- (void)drawButtonview
{
//    self.subBgView.userInteractionEnabled = YES;
//    self.subBgView.tag = kMsgCommentTag + JHMsgSubEventsTypeCommentEnterArticle;
//    [self.subBgView addTarget:self action:@selector(pressButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    //delete
    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.tag = kMsgCommentTag + JHMsgSubEventsTypeCommentDelete;
    [deleteButton setImage:[JHImage imageScaleSize:CGSizeMake(16, 16) image:@"publish_delete_topic_img"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(pressButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundsView addSubview:deleteButton];
    [deleteButton setHidden:YES];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backgroundsView).offset(-5);
        make.top.equalTo(self.backgroundsView).offset(21);
        make.size.mas_offset(26); //image=18,加大点击区域(+5*2)
    }];
    //like
    likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    likeButton.tag = kMsgCommentTag + JHMsgSubEventsTypeCommentLike;
    [likeButton setTitle:@"点赞" forState:UIControlStateNormal];
    [likeButton.titleLabel setFont:JHFont(12)];
    [likeButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [likeButton setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_normal"] forState:UIControlStateNormal];
//    [likeButton setImage:[JHImage imageScaleSize:CGSizeMake(19, 17) image:@"sq_toolbar_icon_like_normal"] forState:UIControlStateNormal];
    [likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, likeButton.imageView.width + 5, 0, 0)];
    [likeButton addTarget:self action:@selector(pressButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundsView addSubview:likeButton];
    [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subBgView.mas_bottom).offset(5); //上边:加大点击区域15->5
        make.right.equalTo(self.backgroundsView).offset(-10);
        make.bottom.equalTo(self.backgroundsView).offset(-5); //下边:加大点击区域15->5
        make.size.mas_equalTo(CGSizeMake(48, 17+20)); //加到这里10+10
    }];
    //comment
    commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.tag = kMsgCommentTag + JHMsgSubEventsTypeCommentComment;
    [commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [commentButton.titleLabel setFont:JHFont(12)];
    [commentButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [commentButton setImage:[UIImage imageNamed:@"sq_toolbar_icon_comment"] forState:UIControlStateNormal];
//    [commentButton setImage:[JHImage imageScaleSize:CGSizeMake(17, 17) image:@"sq_toolbar_icon_comment"] forState:UIControlStateNormal];
    [commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, commentButton.imageView.width + 5, 0, 0)];
    [commentButton addTarget:self action:@selector(pressButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.backgroundsView addSubview:commentButton];
    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(likeButton.mas_left).offset(-10);
        make.bottom.equalTo(likeButton).offset(0);
        make.size.equalTo(likeButton);
    }];
}

#pragma mark - update data
- (void)updateData:(JHMsgSubListLikeCommentModel*)model
{
    [super updateData:model];
    //赋值显示类型
    model.pageType = kMsgSublistTypeComment;
    dataModel = model;
    //点赞图标
    if(model.article.isLike)
    {
//        [likeButton setImage:[JHImage imageScaleSize:CGSizeMake(19, 17) image:@"sq_toolbar_icon_like_selected"] forState:UIControlStateNormal];
        [likeButton setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_selected"] forState:UIControlStateNormal];
    }
    else
    {
//        [likeButton setImage:[JHImage imageScaleSize:CGSizeMake(19, 17) image:@"sq_toolbar_icon_like_normal"] forState:UIControlStateNormal];
        [likeButton setImage:[UIImage imageNamed:@"sq_toolbar_icon_like_normal"] forState:UIControlStateNormal];
    }
    //点赞数
    if([model.article.likeNum integerValue] > 0)
        [likeButton setTitle:model.article.likeNum forState:UIControlStateNormal];
    else
        [likeButton setTitle:@"点赞" forState:UIControlStateNormal];

    if([model.article.replyCount integerValue] > 0)
        [commentButton setTitle:model.article.replyCount forState:UIControlStateNormal];
    else
        [commentButton setTitle:@"评论" forState:UIControlStateNormal];
}

#pragma mark - event
- (void)pressButtonEvent:(UIButton*)button
{
    JHMsgSubEventsType type = button.tag - kMsgCommentTag;
    if(self.actionEvents)
    {
        self.actionEvents(@(type), self);
    }
}

- (void)gotoPersonPage{
    if(self.actionEvents){
        self.actionEvents(@(JHMsgSubEventsTypePersonPage), dataModel);
    }
}

@end
