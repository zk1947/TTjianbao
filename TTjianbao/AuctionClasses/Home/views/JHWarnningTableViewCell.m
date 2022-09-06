//
//  JHWarnningTableViewCell.m
//  TTjianbao
//
//  Created by mac on 2019/7/30.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHWarnningTableViewCell.h"
#import "UIButton+BackColor.h"
#import "UIImageView+JHWebImage.h"
#import "UIButton+ImageTitleSpacing.h"
#import "TTjianbaoMarcoUI.h"

@interface JHWarnningTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UILabel *restStateLabel;

@end

@implementation JHWarnningTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [_openBtn setBackgroundColor:HEXCOLOR(0xfee100) forState:UIControlStateNormal];
    [_openBtn setBackgroundColor:HEXCOLOR(0xeeeeee) forState:UIControlStateDisabled];

    [_openBtn setImage:[UIImage new] forState:UIControlStateNormal];
    [_openBtn setImage:[UIImage imageNamed:@"icon_open_right"] forState:UIControlStateDisabled];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)openWarningAction:(id)sender {
    if (self.openWarnningBlock) {
        self.openWarnningBlock(self.model);
    }
}

- (void)setModel:(JHRecommendAppraiserListItem *)model {
    _model = model;
    self.nickLabel.text = model.name;
    [self.avatar jhSetImageWithURL:[NSURL URLWithString:model.img] placeholder:kDefaultAvatarImage];
    self.typeLabel.text = [NSString stringWithFormat:@"擅长：%@", model.tag];
    if (model.state == 1) {
        self.restStateLabel.hidden = YES;
    }else {
        self.restStateLabel.hidden = NO;
    }
    
    if (model.follow) {
        _openBtn.enabled = NO;
        [_openBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];

    }else {
        _openBtn.enabled = YES;
        [_openBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:0];

    }
    NSString *string =  [NSString stringWithFormat:@"鉴定时间：%@ 好评率：%ld%%",model.appraiseTime, model.grade];
    self.desLabel.text = string;
}


@end
