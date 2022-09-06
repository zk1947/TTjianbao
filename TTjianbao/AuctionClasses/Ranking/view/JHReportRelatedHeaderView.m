//
//  JHReportRelatedHeaderView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/2/23.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHReportRelatedHeaderView.h"
#import "JHAppraisalDetailViewController.h"
#import "NSString+AttributedString.h"

@implementation JHReportRelatedHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    _trueOrFalseImage.hidden = YES;
}

- (IBAction)intoVideo:(id)sender {
    JHAppraisalDetailViewController *player = [[JHAppraisalDetailViewController alloc] initWithAppraisalId:self.model.appraiseId ];
    player.from = 2;
    [self.viewController.navigationController pushViewController:player animated:YES];

}

- (void)setModel:(JHReporterDetailModel *)model{
    _model = model;
    if (!_model) {
        return;
    }
    self.nickLabel.text = [NSString stringWithFormat:@"宝友 %@", _model.viewerName?:@""];
    self.videoTitle.text = _model.videoTitle;
    [self.imgCover jhSetImageWithURL:[NSURL URLWithString:ThumbMiddleByOrginal(_model.videoCoverImg)] placeholder:kDefaultCoverImage];
    if (!_model.appraisePriceStr) {
        _model.appraisePriceStr = @"0";
    }
        self.priceLabel.attributedText = [[@"评估价 " stringByAppendingString:OBJ_TO_STRING(_model.appraisePriceStr)] attributedSubString:_model.appraisePriceStr font:[UIFont fontWithName:kFontBoldDIN size:19] color:HEXCOLOR(0x222222) allColor:HEXCOLOR(0x666666) allfont:[UIFont fontWithName:@"PingFangSC-Regular" size:13]];
    

    self.anchorLabel.attributedText = [[@"鉴定师 " stringByAppendingString:OBJ_TO_STRING(_model.anchorName)] attributedSubString:_model.anchorName font:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] color:HEXCOLOR(0x222222) allColor:HEXCOLOR(0x666666) allfont:[UIFont fontWithName:@"PingFangSC-Regular" size:13]];
    
    self.videoDuring.text = [CommHelp getHMSWithSecond:_model.videoDuration];
    self.timeLabel.text = _model.createDate;
//    [self.trueOrFalseImage setImage:[UIImage imageNamed:_model.isGenuine == 1?@"n_home_true":@"n_home_false"]];
//    self.trueOrFalseLabel.text = [NSString stringWithFormat:@"鉴定为%@",_model.isGenuine?@"真":@"假"];
    self.desLabel.text = _model.content;
    self.cateName.text = [NSString stringWithFormat:@"更多%@鉴定", _model.cateName];
    _trueOrFalseImage.hidden = NO;
    if (model.isGenuine == 1) {
        self.anchorLabel.hidden = NO;        self.anchorCenterLabel.hidden = YES;
        self.priceLabel.hidden = NO;
        self.trueOrFalseImage.image = [UIImage imageNamed:@"n_home_true"];
        self.trueOrFalseLabel.text = @"鉴定为真";
    }else if(model.isGenuine == 2){
        self.anchorLabel.hidden = NO;        self.anchorCenterLabel.hidden = YES;
        self.priceLabel.hidden = NO;
        self.trueOrFalseImage.image = [UIImage imageNamed:@""];
        self.trueOrFalseLabel.text = @"部分为真";
    }else {
        self.trueOrFalseLabel.text = @"鉴定为假";
        self.trueOrFalseImage.image = [UIImage imageNamed:@"n_home_false"];
        self.anchorCenterLabel.hidden = NO;
        self.anchorLabel.hidden = YES;
        self.priceLabel.hidden = YES;
            self.anchorCenterLabel.attributedText = [[@"鉴定师 " stringByAppendingString:OBJ_TO_STRING(_model.anchorName)] attributedSubString:_model.anchorName font:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] color:HEXCOLOR(0x222222) allColor:HEXCOLOR(0x666666) allfont:[UIFont fontWithName:@"PingFangSC-Regular" size:13]];
    }

}

@end
