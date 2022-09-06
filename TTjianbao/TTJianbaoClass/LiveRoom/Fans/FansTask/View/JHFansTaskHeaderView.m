//
//  JHFansTaskHeaderView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansTaskHeaderView.h"
#import "UIView+CornerRadius.h"
#import "UIImage+JHColor.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHFansEquityPopView.h"
#import "JHFansEquityWebView.h"

@interface JHFansTaskHeaderView()
@property(nonatomic,strong)UIImageView *contentView;
@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *fansCountLabel;
@property(nonatomic,strong)UILabel *gradedLabel;
@property(nonatomic,strong)UIButton *interestsButton;
@property(nonatomic,strong)UIProgressView *processView;
@property(nonatomic,strong)UILabel *currentExpValueLabel;
@property(nonatomic,strong)UILabel *nextExpValueLabel;
@property(nonatomic,strong)UIButton *button;
@end
@implementation JHFansTaskHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
        
    }
    return self;
}
- (void)configUI
{
    _contentView = [[UIImageView alloc] init];
    _contentView.userInteractionEnabled  = YES;
    _contentView.image =  [UIImage gradientColorImageFromColors:@[HEXCOLOR(0xFFF0c8), HEXCOLOR(0xFFFFFF)] gradientType:JHGradientFromTopToBottom imgSize:CGSizeMake(ScreenW, self.height) radius:0];
    _contentView.clipsToBounds = YES;
    [_contentView yd_setCornerRadius:8 corners:UIRectCornerTopLeft|UIRectCornerTopRight];
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _headImage = [[UIImageView alloc]init];
    _headImage.image = kDefaultAvatarImage;
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.cornerRadius = 18;
    _headImage.userInteractionEnabled = YES;
    [self.contentView addSubview:_headImage];
    
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(14);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.left.offset(15);
    }];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.text = @"";
    _nameLabel.font = [UIFont fontWithName:kFontMedium size:13];
    _nameLabel.textColor = kColor333;
    _nameLabel.numberOfLines = 1;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_nameLabel];
    
    UILabel *_nameClublabel = [[UILabel alloc]init];
    _nameClublabel.text = @"的粉丝团";
    _nameClublabel.font = [UIFont fontWithName:kFontMedium size:13];
    _nameClublabel.textColor = kColor333;
    _nameClublabel.numberOfLines = 1;
    _nameClublabel.textAlignment = NSTextAlignmentLeft;
    _nameClublabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_nameClublabel];
    
    _fansCountLabel=[[UILabel alloc]init];
    _fansCountLabel.text=@"";
    _fansCountLabel.font=[UIFont fontWithName:kFontNormal size:11];
    _fansCountLabel.backgroundColor=[UIColor clearColor];
    _fansCountLabel.textColor=kColor999;
    _fansCountLabel.numberOfLines = 1;
    _fansCountLabel.textAlignment = NSTextAlignmentLeft;
    _fansCountLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:_fansCountLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImage.mas_right).offset(15);
        make.top.equalTo(_headImage);
        make.width.lessThanOrEqualTo(@150);
    }];
    
    [_nameClublabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel);
        make.left.equalTo(_nameLabel.mas_right).offset(0);
    }];
    
    [_fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.top.equalTo(_nameLabel.mas_bottom).offset(5);
        
    }];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setImage:[UIImage imageNamed:@"orderconfirm_introduce_icon"] forState:UIControlStateNormal];
    [_button setTitleColor:kColor333 forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(FansRuleIntroduce) forControlEvents:UIControlEventTouchUpInside];
    _button.contentMode=UIViewContentModeScaleAspectFit;
    
     [self.contentView addSubview:_button];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel);
        make.left.equalTo(_nameClublabel.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    _gradedLabel = [[UILabel alloc]init];
    _gradedLabel.text = @"";
    _gradedLabel.font = [UIFont fontWithName:kFontBoldDIN size:14];
    _gradedLabel.textColor = kColor333;
    _gradedLabel.numberOfLines = 1;
    _gradedLabel.textAlignment = NSTextAlignmentLeft;
    _gradedLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_gradedLabel];
    
    [_gradedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImage).offset(0);
        make.top.equalTo(_headImage.mas_bottom).offset(15);
    }];
    
    _interestsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_interestsButton setImage:[UIImage imageNamed:@"addadress_choose_icon"] forState:UIControlStateNormal];
    [_interestsButton setTitleColor:kColor666 forState:UIControlStateNormal];
    _interestsButton.titleLabel.font= [UIFont fontWithName:kFontNormal size:12];
    [_interestsButton setTitle:@"等级权益" forState:UIControlStateNormal];
    [_interestsButton addTarget:self action:@selector(levelInterests) forControlEvents:UIControlEventTouchUpInside];
    _interestsButton.contentMode=UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_interestsButton];
    
    [_interestsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_gradedLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    [_interestsButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    
    _processView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    _processView.trackTintColor = kColorEEE;
    _processView.progressTintColor = kColorMain;
    _processView.progress = 0;
    [self.contentView addSubview:_processView];
    [_processView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_gradedLabel.mas_bottom).offset(10);
        make.left.equalTo(_gradedLabel).offset(0);
        make.right.equalTo(_interestsButton).offset(0);
        make.height.offset(5);
    }];
    
    _currentExpValueLabel=[[UILabel alloc]init];
    _currentExpValueLabel.text=@"";
    _currentExpValueLabel.font=[UIFont fontWithName:kFontNormal size:11];
    _currentExpValueLabel.backgroundColor=[UIColor clearColor];
    _currentExpValueLabel.textColor=kColor999;
    _currentExpValueLabel.numberOfLines = 1;
    _currentExpValueLabel.textAlignment = NSTextAlignmentLeft;
    _currentExpValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:_currentExpValueLabel];
    
    [_currentExpValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_gradedLabel).offset(0);
        make.top.equalTo(_processView.mas_bottom).offset(10);
    }];
    
    _nextExpValueLabel=[[UILabel alloc]init];
    _nextExpValueLabel.text=@"";
    _nextExpValueLabel.font=[UIFont fontWithName:kFontNormal size:11];
    _nextExpValueLabel.backgroundColor=[UIColor clearColor];
    _nextExpValueLabel.textColor=kColor999;
    _nextExpValueLabel.numberOfLines = 1;
    _nextExpValueLabel.textAlignment = NSTextAlignmentLeft;
    _nextExpValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:_nextExpValueLabel];
    
    [_nextExpValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_interestsButton).offset(0);
        make.centerY.equalTo(_currentExpValueLabel).offset(0);
    }];
}
-(void)setFansClubModel:(JHFansClubModel *)fansClubModel{
    
    _fansClubModel = fansClubModel;
    [_headImage jh_setImageWithUrl:_fansClubModel.anchorIcon ];
    _nameLabel.text = [NSString stringWithFormat:@"%@",_fansClubModel.fansClubName];
    _fansCountLabel.text = [NSString stringWithFormat:@"亲密粉丝%@人",_fansClubModel.fansCount];
    _gradedLabel.text = [NSString stringWithFormat:@"Lv.%@ %@",_fansClubModel.userLevelType,_fansClubModel.userLevelName];
    _processView.progress = _fansClubModel.progressBar;
    _nextExpValueLabel.text= _fansClubModel.expToNextLevel;
    _currentExpValueLabel.text= [NSString stringWithFormat:@"%@累计亲密度",_fansClubModel.totalExp];
    
    
}
-(void)FansRuleIntroduce{
    
     //TODO jiang 粉丝规则说明
    JHFansEquityWebView * first =[[JHFansEquityWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 450 + UI.bottomSafeAreaHeight)];
    [JHKeyWindow addSubview:first];
    [first showAlert];
    [JHTracking trackEvent:@"gzanClick" property:@{@"from":@"任务列表"}];
    if (self.ruleAction) {
        self.ruleAction(nil);
    }
    
}
-(void)levelInterests{
    
     //TODO jiang 等级权益
    JHFansEquityPopView * view = [[JHFansEquityPopView alloc] initWithAnchorId:self.fansClubModel.anchorId andisFans:YES];
    view.fansClubId = self.fansClubModel.fansClubId;
    [JHKeyWindow addSubview:view];
    [JHTracking trackEvent:@"fsttcEnter" property:@{@"anchor_id":self.fansClubModel.anchorId,@"channel_local_id":self.channelLocalID,@"from":@"任务列表等级权益按钮"}];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
