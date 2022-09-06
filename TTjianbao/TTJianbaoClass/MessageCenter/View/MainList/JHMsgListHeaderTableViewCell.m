//
//  JHMsgListHeaderTableViewCell.m
//  TTjianbao
//
//  Created by mac on 2019/5/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHMsgListHeaderTableViewCell.h"
#import "UIImageView+JHWebImage.h"
#import "JHMyCenterDotNumView.h"

@interface JHMsgListHeaderTableViewCell ()

@property (strong, nonatomic) JHMyCenterDotNumView *orderDotView;
@property (strong, nonatomic) JHMyCenterDotNumView *discountDotView;
@property (weak, nonatomic) IBOutlet UIButton *orderTransportBtn;
@property (weak, nonatomic) IBOutlet UIButton *discountBtn;
@property (weak, nonatomic) IBOutlet UILabel* orderTransportLabel;
@property (weak, nonatomic) IBOutlet UILabel* discountLabel;

@end

@implementation JHMsgListHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    [self.orderTransportBtn setImageInsetStyle:MRImageInsetStyleTop spacing:8];
//    [self.discountBtn setImageInsetStyle:MRImageInsetStyleTop spacing:8];
    [self.orderTransportBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-ScreenW/4.0+14);
    }];
    [self.discountBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(ScreenW/4.0-14);
    }];
    self.orderDotView = [JHMyCenterDotNumView new];
    [self.contentView addSubview:self.orderDotView];
    [self.orderDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.orderTransportBtn.mas_right).offset(-8.5);
        make.bottom.mas_equalTo(self.orderTransportBtn.mas_top).offset(10);
    }];
    self.discountDotView = [JHMyCenterDotNumView new];
    [self.contentView addSubview:self.discountDotView];
    [self.discountDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.discountBtn.mas_right).offset(-8.5);
        make.bottom.mas_equalTo(self.discountBtn.mas_top).offset(10);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)btnAction:(id)sender {
    if (self.actionBlock) {
        UIButton* btn = (UIButton*)sender;
        if(btn.tag == 0)
            self.actionBlock(kMsgSublistTypeExpress);
        else
            self.actionBlock(kMsgSublistTypeActivity);
    }
}

- (void) updateData:(NSMutableArray*)array unread:(JHMsgCenterUnreadModel*)model
{
    //优先使用请求下来的icon和title
    for (JHMsgCenterModel* m in array)
    {
        if([m.type isEqualToString:kMsgSublistTypeExpress])
        {
            [self.orderTransportBtn.imageView jhSetImageWithURL:[NSURL URLWithString:m.icon] placeholder:[UIImage imageNamed: @"img_msg_list_transport"]];
            self.orderTransportLabel.text = m.title;
        }
        else if([m.type isEqualToString:kMsgSublistTypeActivity])
        {
            [self.discountBtn.imageView jhSetImageWithURL:[NSURL URLWithString:m.icon] placeholder:[UIImage imageNamed: @"img_msg_list_active"]];
            self.discountLabel.text = m.title;
        }
    }

    //unread
    for (JHMsgCenterSubUnreadModel* m in model.typeCounts) {
        if([m.type isEqualToString:kMsgSublistTypeExpress])
        {
            [self.orderDotView setNumber:m.count];
        }
        else if([m.type isEqualToString:kMsgSublistTypeActivity])
        {
            [self.discountDotView setNumber:m.count];
        }
    }
}

@end
