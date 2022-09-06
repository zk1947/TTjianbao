//
//  JHC2CProductDetailJianDingCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailJianDingCell.h"
#import "JHC2CProoductDetailModel.h"
#import "JHWebViewController.h"
#import "JHAudioPlayerManager.h"
#import "UIButton+ImageTitleSpacing.h"


@interface JHC2CProductDetailJianDingCell()

@property(nonatomic, strong) UIView * backView;

@property(nonatomic, strong) UIButton * seeJianDingReportBtn;
@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic, strong) UIView * lineView;

@property(nonatomic, strong) UIImageView * iconImageView;
@property(nonatomic, strong) UILabel * nameLbl;
@property(nonatomic, strong) UILabel * timeLbl;
@property(nonatomic, strong) UIImageView * statuImageView;

@property(nonatomic, strong) UIView * voiceView;
@property(nonatomic, strong) UILabel * voiceLengthLbl;
@property(nonatomic, strong) UIImageView * voicePlayImageView;

@property(nonatomic, strong) UILabel * detaiLbl;
@property(nonatomic, strong) UILabel * noticeLbl;

@end

@implementation JHC2CProductDetailJianDingCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = HEXCOLOR(0xF2F2F2);
        [self setItems];
        [self layoutItems];
    }
    return self;
}

    
- (void)setItems{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.backView];
    
    [self.backView addSubview:self.seeJianDingReportBtn];
    [self.backView addSubview:self.titleLbl];
    [self.backView addSubview:self.lineView];
    
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.nameLbl];
    [self.backView addSubview:self.timeLbl];
    [self.backView addSubview:self.statuImageView];
    
    [self.backView addSubview:self.voiceView];
    [self.backView addSubview:self.detaiLbl];
    [self.backView addSubview:self.noticeLbl];
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(10);
        make.left.bottom.right.equalTo(@0);
    }];
    [self.seeJianDingReportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(self.lineView.mas_top);
        make.width.mas_equalTo(90);
        make.right.equalTo(@0).offset(-20);

    }];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.seeJianDingReportBtn);
        make.left.top.equalTo(@0).offset(12);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(12);
        make.left.right.equalTo(@0).inset(12);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView).offset(12);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(@0).offset(12);
    }];
    [self.statuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView);
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.right.equalTo(@0).offset(-20);
    }];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
    }];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLbl.mas_bottom).offset(3);
        make.left.equalTo(self.nameLbl);
    }];
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(140, 30));
        make.left.equalTo(@0).offset(12);
    }];
    [self.detaiLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(16);
        make.left.right.equalTo(@0).inset(12);
    }];
    [self.noticeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detaiLbl.mas_bottom).offset(22);
        make.left.right.equalTo(@0).inset(12);
        make.bottom.equalTo(@0).offset(-20);
    }];
}
- (void)setModel:(JHC2CProoductDetailModel *)model{
    _model = model;
    JHC2CAppraisalResult *appModel = model.appraisalResult;
    /// 鉴定结果类型 0 真 1 仿品 2 存疑 3 现代工艺品
    self.nameLbl.text = @"图文鉴定";
    self.timeLbl.text = appModel.appraisalCompletedTime;
    self.detaiLbl.text = appModel.remark;
    self.iconImageView.image = [UIImage imageNamed:@"icon_report_icon"];
    if ([model.appraisalResult.appraisalResultType isEqualToString:@"0"]) {
        self.statuImageView.image = [UIImage imageNamed:@"c2c_pd_yuan_zhenpin"];
        
    }else if([model.appraisalResult.appraisalResultType isEqualToString:@"1"]) {
        self.statuImageView.image = [UIImage imageNamed:@"c2c_pd_yuan_fangpin"];
        
    }else if([model.appraisalResult.appraisalResultType isEqualToString:@"2"]) {
        self.statuImageView.image = [UIImage imageNamed:@"c2c_pd_yuan_cunyi"];

    }else if([model.appraisalResult.appraisalResultType isEqualToString:@"3"]) {
        self.statuImageView.image = [UIImage imageNamed:@"c2c_pd_yuan_gongyipin"];

    }
    if (appModel.voiceContentVOS && !appModel.remark.length) {
        [self refreshViewWithData];
    }
}

- (void)refreshViewWithData{
    self.detaiLbl.hidden = YES;
    self.voiceView.hidden = NO;
    self.voiceLengthLbl.text = [NSString stringWithFormat:@"%@’‘", self.model.appraisalResult.voiceContentVOS.lastObject.audioDuration];
    [self.noticeLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceView.mas_bottom).offset(22);
        make.left.right.equalTo(@0).inset(12);
        make.bottom.equalTo(@0).offset(-20);
    }];
}

- (void)jumpJianDingBaoGao{
    NSString *customerId = [UserInfoRequestManager sharedInstance].user.customerId;
    JHWebViewController *webView = [[JHWebViewController alloc] init];
    webView.urlString = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/reportGraphic.html?customerId=%@&productSn=%@"),customerId ?: @"", self.productID];
    [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];

}

- (void)playVoice{
    JHAudioPlayerManager *play = JHAudioPlayerManager.shareManger;
    
    if (play.isPlaying) {
        [play pause];
        [self.voicePlayImageView stopAnimating];
        return;
    }else if (play.isPause) {
        [play play];
        [self.voicePlayImageView startAnimating];
        return;
    }
    
    
    [play createAudioWithAudioUrl:[NSURL URLWithString:self.model.appraisalResult.voiceContentVOS.lastObject.voiceContentUrl]];
    [self.voicePlayImageView startAnimating];
    @weakify(self);
    play.didFinished = ^{
        @strongify(self);
        [self.voicePlayImageView stopAnimating];
    };
    play.hasError = ^{
        @strongify(self);
        [self.voicePlayImageView stopAnimating];
    };
    [play play];
}

#pragma mark -- <set and get>

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        _backView = view;
    }
    return _backView;
}

- (UIButton *)seeJianDingReportBtn{
    if (!_seeJianDingReportBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"查看鉴定报告" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"c2c_up_arrow"] forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(13);
        [btn addTarget:self action:@selector(jumpJianDingBaoGao) forControlEvents:UIControlEventTouchUpInside];
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
        _seeJianDingReportBtn = btn;
    }
    return _seeJianDingReportBtn;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(16);
        label.text = @"鉴定报告";
        label.textColor = HEXCOLOR(0x333333);
        _titleLbl = label;
    }
    return _titleLbl;
}
- (UIView *)lineView{
    if (!_lineView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xF0F0F0);
        _lineView = view;
    }
    return _lineView;
}

- (UILabel *)timeLbl{
    if (!_timeLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.text = @"2021-09-08";
        label.textColor = HEXCOLOR(0x999999);
        _timeLbl = label;
    }
    return _timeLbl;
}
- (UILabel *)nameLbl{
    if (!_nameLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.text = @"图文鉴定";
        label.textColor = HEXCOLOR(0x333333);
        _nameLbl = label;
    }
    return _nameLbl;
}
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        view.layer.cornerRadius = 20;
        view.layer.masksToBounds = YES;
        _iconImageView = view;
    }
    return _iconImageView;
}
- (UIImageView *)statuImageView{
    if (!_statuImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"c2c_pd_yuan_zhenpin"];
        _statuImageView = view;
    }
    return _statuImageView;
}

- (UILabel *)detaiLbl{
    if (!_detaiLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(14);
        label.text = @"";
        label.numberOfLines = 0;
        label.textColor = HEXCOLOR(0x333333);
        _detaiLbl = label;
    }
    return _detaiLbl;
}
- (UILabel *)noticeLbl{
    if (!_noticeLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.text = @"图文鉴定结果依托于宝友提供的图片或视频信息，具有局限性，鉴定结果仅供参考。";
        label.numberOfLines = 0;
        label.textColor = HEXCOLOR(0x999999);
        _noticeLbl = label;
    }
    return _noticeLbl;
}
- (UIView *)voiceView{
    if (!_voiceView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xFFD70F);
        view.hidden = YES;
        view.layer.cornerRadius = 5;
        _voiceView = view;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVoice)];
        [view addGestureRecognizer:tap];
        
        [view addSubview:self.voicePlayImageView];
        [view addSubview:self.voiceLengthLbl];
        
        [self.voicePlayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(@0).offset(8);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        [self.voiceLengthLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.left.equalTo(self.voicePlayImageView.mas_right).offset(4);
        }];

    }
    return _voiceView;
}

- (UILabel *)voiceLengthLbl{
    if (!_voiceLengthLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.text = @"0'";
        label.textColor = HEXCOLOR(0x333333);
        _voiceLengthLbl = label;
    }
    return _voiceLengthLbl;
}
    
- (UIImageView *)voicePlayImageView{
    if (!_voicePlayImageView) {
        UIImageView *view = [UIImageView new];
        view.animationImages = @[[UIImage imageNamed:@"IM_audio_play_icon1"],
                                 [UIImage imageNamed:@"IM_audio_play_icon2"],
                                 [UIImage imageNamed:@"IM_audio_play_icon3"]
        ];
        view.image = [UIImage imageNamed:@"IM_audio_play_icon3"];
        view.animationDuration = 1;
        _voicePlayImageView = view;
    }
    return _voicePlayImageView;
}
    
@end
