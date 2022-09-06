//
//  JHMsgListTableViewCell.m
//  TTjianbao
//
//  Created by mac on 2019/5/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHMsgListTableViewCell.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
#import "JHMyCenterDotNumView.h"

@interface JHMsgListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) JHMyCenterDotNumView *dotView;

@end

@implementation JHMsgListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.preservesSuperviewLayoutMargins = NO;
    self.separatorInset = UIEdgeInsetsMake(0, 65, 0, 0);
    self.layoutMargins = UIEdgeInsetsZero;
    self.dotView = [JHMyCenterDotNumView new];
    [self.contentView addSubview:self.dotView];
    [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.iconImage.mas_right).offset(-5);
        make.bottom.mas_equalTo(self.iconImage.mas_top).offset(8.5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(JHMsgCenterModel*)model {
    _model = model;
    self.nameLabel.text = model.title;
    if(!model.body)
    {
        if([model.type isEqualToString:@"announce_common"])
            model.body = @"暂无公告";
        else
            model.body = @"暂无数据";
    }
    self.desLabel.text = model.body;
    self.timeLabel.text = model.updateDate;
    [self setTipCount:model.total];
    
    [self updateShowImage:model];
}

- (void)updateShowImage:(JHMsgCenterModel*)model{
    NSString* imgStr = nil;
    
    if([kMsgSublistTypeExpress isEqualToString:model.type])
    {
        imgStr = @"img_msg_list_transport";//分类里一般不会有
    }
    else if([kMsgSublistTypeStone isEqualToString:model.type])
    {
        imgStr = @"img_msg_list_stone";
    }
    else if([kMsgSublistTypeActivity isEqualToString:model.type])
    {
        imgStr = @"img_msg_list_active";//分类里一般不会有
    }
    else if([kMsgSublistTypeCommon isEqualToString:model.type])
    {
        imgStr = @"img_msg_list_notice";
    }
    else if([kMsgSublistTypeForum isEqualToString:model.type])
    {
        imgStr = @"img_msg_list_interact";
    }
    else if([kMsgSublistTypeSettle isEqualToString:model.type])
    {
        imgStr = @"img_msg_list_settle";
    }
    else if([kMsgSublistTypePromote isEqualToString:model.type])
    {
        imgStr = @"img_msg_list_discount";
    }else if ([kMsgSublistTypeIM isEqualToString:model.type]) {
        imgStr = @"IM_user_icon";
    }
    else //官方客服或占位默认图
    {
        if ([model.title isEqualToString:@"珠宝顾问"] || [model.title isEqualToString:@"平台客服"])
        {
            imgStr = @"icon_live_chat";
        }
        else
        {
            imgStr = @"img_msg_list_service";
        }
    }
    @weakify(self)
    [[RACObserve(model, icon) takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.iconImage jh_setImageWithUrl:x placeHolder: imgStr];
    }];
}

- (void)setTipCount:(NSInteger)count {
    
    self.dotView.number = count;
}

@end
