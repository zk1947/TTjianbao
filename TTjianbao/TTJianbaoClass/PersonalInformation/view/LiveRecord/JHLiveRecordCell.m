//
//  JHLiveRecordCell.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/17.
//  Copyright © 2019年 Netease. All rights reserved.
//
#import "NIMAvatarImageView.h"
#import "JHLiveRecordCell.h"
#import "JHEvaluationViewController.h"
#import "UIView+NTES.h"
#import "JHReporterCard.h"
#import "JHPublishReportView.h"
#import "TTjianbaoHeader.h"
#import "NSString+AttributedString.h"
#import "FileUtils.h"
#import "TTjianbaoMarcoKeyword.h"

@interface JHLiveRecordCell ()
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet NIMAvatarImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isTrueImage;
@property (weak, nonatomic) IBOutlet UIButton *reporterBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reporterBtnWidth;
@property (nonatomic, strong) JHReporterCard *reporterCard;
@property (weak, nonatomic) IBOutlet UILabel *priceTitle;
///填写备注按钮
@property (nonatomic, strong) UIButton *remarkButton;
///显示备注信息
@property (nonatomic, strong) UILabel *remarkLabel;
@end
@implementation JHLiveRecordCell

- (UIButton *)remarkButton {
    if (!_remarkButton) {
        _remarkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_remarkButton setTitleColor:kColor222 forState:UIControlStateNormal];
        [_remarkButton setTitle:@"填写备注" forState:UIControlStateNormal];
        _remarkButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:14.];
        [_remarkButton addTarget:self action:@selector(__handleRemarkEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _remarkButton;
}

- (UILabel *)remarkLabel {
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.text = @"";
        _remarkLabel.font = [UIFont fontWithName:kFontNormal size:14.];
        _remarkLabel.textColor = kColorFFF;
        _remarkLabel.numberOfLines = 2.f;
        _remarkLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _remarkLabel;
}

- (void)__handleRemarkEvent {
    if (self.remarkBlock) {
        self.remarkBlock(self.model);
    }
}

- (JHReporterCard *)reporterCard {
    if (!_reporterCard) {
        _reporterCard = [[NSBundle mainBundle] loadNibNamed:@"JHReporterCard" owner:nil options:nil].firstObject;
        _reporterCard.frame = self.viewController.view.bounds;
    }
    return _reporterCard;
}

//- (JHAppraisalReportView *)reporter {
//    if (!_reporter) {
//        _reporter = [[JHAppraisalReportView alloc] initWithFrame:CGRectMake(0, ScreenH-300, ScreenW, 300)];
//        MJWeakSelf
//        _reporter.finishBlock = ^(NSDictionary *sender) {
//
//            weakSelf.model.reportId = @([sender[@"reportId"] integerValue]).stringValue;
//            weakSelf.model.isGenuine = [sender[@"authenticity"] integerValue];
//            weakSelf.model.priceStr = sender[@"price"];
//            weakSelf.roleType = weakSelf.roleType;
//            weakSelf.model = weakSelf.model;
//
//        };
//    }
//    return _reporter;
//}



- (void)awakeFromNib {
    [super awakeFromNib];
    self.commentBtn.layer.borderWidth = 1;
    self.commentBtn.layer.borderColor = kGlobalThemeColor.CGColor;
    self.commentBtn.layer.cornerRadius = 3;
    self.commentBtn.layer.masksToBounds = YES;

    self.reporterBtn.layer.cornerRadius = 3;
    self.reporterBtn.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.remarkLabel];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(14);
        make.right.equalTo(self.contentView).offset(-14);
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-18);
    }];
    
    ///添加填写备注按钮
    [self.contentView addSubview:self.remarkButton];
    self.remarkButton.hidden = YES;
    [self.remarkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.reporterBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.reporterBtn);
        make.width.height.equalTo(self.reporterBtn);
    }];
    
    [self.remarkButton layoutIfNeeded];
    self.remarkButton.layer.borderWidth = .5;
    self.remarkButton.layer.borderColor = HEXCOLOR(0xD8D8D8).CGColor;
    self.remarkButton.layer.cornerRadius = 5;
    self.remarkButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(JHLiveRecordModel *)model  {
    _model = model;
    [self.coverImage jhSetImageWithURL:[NSURL URLWithString:model.coverImg] placeholder:kDefaultCoverImage];
    [self.avatar nim_setImageWithURL:[NSURL URLWithString:model.anchorIcon] placeholderImage:kDefaultAvatarImage];
//    self.isTrueImage.image = model.isGenuine ? [UIImage imageNamed:@"icon_true_logo"]:[UIImage imageNamed:@"icon_false_logo"];
    self.nickLabel.text = model.anchorName;
    self.postLabel.text = model.anchorTitle;
    self.timeLabel.text = model.recordTime;
    self.priceLabel.text = @"";
    self.priceTitle.hidden = YES;

    if (model.isGenuine == 1) {
        if (model.priceStr && [model.priceStr isKindOfClass:[NSString class]]) {
            self.priceLabel.attributedText = [[NSString stringWithFormat:@"%@%@",([CommHelp isAvailablePrice:model.price]?@"¥":@""), model.priceStr] formatePriceFontSize:24 color:kGlobalThemeColor];
            self.priceTitle.hidden = NO;
            
            if (![CommHelp isAvailablePrice:model.price]) {
                self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:24];
            }

        }
    }else {
        self.priceLabel.text = @"";
        self.priceTitle.hidden = YES;
    }
    
    if (model.isGenuine == 1) {
        self.isTrueImage.image = [UIImage imageNamed:@"icon_true_logo"];
    }else if(model.isGenuine == 2) {
        self.isTrueImage.image = [UIImage imageNamed:@""];
    }else {
        self.isTrueImage.image = [UIImage imageNamed:@"icon_false_logo"];
    }
    
    if (!model.reportId) {
        self.priceLabel.hidden = YES;
        self.isTrueImage.hidden = YES;
    }else {
        self.priceLabel.hidden = NO;
        self.isTrueImage.hidden = NO;

    }
    self.remarkLabel.text = [_model.remark isNotBlank] ?  _model.remark : @"";
}

- (void)setRoleType:(NSInteger)roleType {
    _roleType = roleType;
    self.reporterBtnWidth.constant = 85;
    self.commentBtn.hidden = NO;
    self.remarkButton.hidden = YES;

    if (roleType == 0) {
        if (!_model.reportId) {
            self.reporterBtnWidth.constant = 0;
        }
        if (_model.evaluateId) {
            self.commentBtn.hidden = YES;
            [self handleRemarkButton];
        }
    }
    else {
        self.commentBtn.hidden = YES;
        [self handleRemarkButton];
    }
}

- (void)handleRemarkButton {
    NSString *remarkTitle = @"填写备注";
    if ([_model.remark isNotBlank]) {
        ///填写过备注 并且提交至服务器 按钮显示"编辑备注"
        remarkTitle = @"编辑备注";
    }
    [self.remarkButton setTitle:remarkTitle forState:UIControlStateNormal];
    self.remarkButton.hidden = !_model.isRecommend;
}

- (IBAction)reporterAction:(id)sender {
   
    if (_model.isGenuine < 2) {
        _reporterCard = nil;
        [self.viewController.view addSubview:self.reporterCard];
        [self.reporterCard showAlert];
        [self requestData];

    } else {
        if (_roleType) {
            
            NTESMicConnector *model = [[NTESMicConnector alloc] init];
            model.appraiseRecordId = _model.appraiseId;
            @weakify(self);
            [JHPublishReportView showWithModel:model controller:[JHRouterManager jh_getViewController] completeBlock:^(NSDictionary * _Nonnull data, NSString * _Nonnull appraiseRecordId) {
                @strongify(self);
                self.model.reportId = @([data[@"reportId"] integerValue]).stringValue;
                self.model.isGenuine = [data[@"authenticity"] integerValue];
                self.model.price = data[@"price"];
                self.model.priceStr = data[@"priceStr"];
                
                ///原有的逻辑
                self.roleType = self.roleType;
                self.model = self.model;
            }];
        }
    }

}

- (IBAction)commentBtnAction:(id)sender {
    if (!_model.evaluateId) {
        JHEvaluationViewController *vc = [[JHEvaluationViewController alloc] init];
        vc.anchorId = _model.anchorId;
        vc.appraiseId = _model.appraiseId;
        MJWeakSelf
        vc.finishBlock = ^(NSString *sender) {
            weakSelf.model.evaluateId = sender;
            weakSelf.roleType = weakSelf.roleType;
        };
        [self.viewController presentViewController:vc animated:YES completion:nil];

    }
}


- (void)requestData {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/report/authoptional/reportDetail") Parameters:@{@"appraiseRecordId":_model.appraiseId} successBlock:^(RequestModel *respondObject) {
        self.reporterCard.model = [JHRecorderModel mj_objectWithKeyValues:respondObject.data];

    } failureBlock:^(RequestModel *respondObject) {
        
    }];
    
}


@end
