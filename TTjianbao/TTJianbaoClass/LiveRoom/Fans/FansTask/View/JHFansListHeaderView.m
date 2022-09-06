//
//  JHFansListHeaderView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansListHeaderView.h"
#import "UIView+CornerRadius.h"
#import "UIImage+JHColor.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHFansAlterNickNameView.h"
#import "JHTaskHUD.h"
#import "JHUserTitleUpHUD.h"
#import "JHOldUserTitleUpHUD.h"
#import "JHFansEquityWebView.h"

@interface JHFansListHeaderView()
@property(nonatomic,strong)UIImageView *contentView;
@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *fansCountLabel;
@property(nonatomic,strong)UILabel *gradedLabel;
@property(nonatomic,strong)UIButton *interestsButton;
@property(nonatomic,strong)UIProgressView *processView;
@property(nonatomic,strong)UILabel *currentExpValueLabel;
@property(nonatomic,strong)UILabel *nextExpValueLabel;
@property(nonatomic,strong)JHFansAlterNickNameView *alert;

@end
@implementation JHFansListHeaderView
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
    _contentView.image =  [UIImage gradientColorImageFromColors:@[HEXCOLOR(0xFFF0c8), HEXCOLOR(0xFFFFFF)] gradientType:JHGradientFromTopToBottom imgSize:CGSizeMake(ScreenW, self.height) radius:0];
    _contentView.clipsToBounds = YES;
    _contentView.userInteractionEnabled = YES;
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
    _nameLabel.text = @"至尊财神至尊财神的粉丝团";
    _nameLabel.font = [UIFont fontWithName:kFontMedium size:13];
    _nameLabel.textColor = kColor333;
    _nameLabel.numberOfLines = 1;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_nameLabel];
    
    
    _fansCountLabel=[[UILabel alloc]init];
    _fansCountLabel.text=@"亲密粉丝0人";
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
    }];
    [_fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.top.equalTo(_nameLabel.mas_bottom).offset(5);
        
    }];
    
//    UIButton *alterButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [alterButton setImage:[UIImage imageNamed:@"fans_list_edit_icon"] forState:UIControlStateNormal];
//    [alterButton setTitleColor:kColor333 forState:UIControlStateNormal];
//    [alterButton addTarget:self action:@selector(alterNickName) forControlEvents:UIControlEventTouchUpInside];
//    alterButton.contentMode=UIViewContentModeScaleAspectFit;
//
//    [self.contentView addSubview:alterButton];
//
//    [alterButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_nameLabel);
//        make.left.equalTo(_nameLabel.mas_right).offset(10);
//    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"orderconfirm_introduce_icon"] forState:UIControlStateNormal];
    [button setTitleColor:kColor333 forState:UIControlStateNormal];
    [button addTarget:self action:@selector(FansRuleIntroduce) forControlEvents:UIControlEventTouchUpInside];
    button.contentMode=UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    
    UIView *tipView = [[UIView alloc] init];
    tipView.backgroundColor = HEXCOLOR(0xfafafa);
    tipView.clipsToBounds = YES;
    [tipView yd_setCornerRadius:4 corners:UIRectCornerAllCorners];
    [self.contentView addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImage.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.offset(36);
    }];
    
    UILabel  *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"系统会优先给粉丝团成员发送您的开播通知哦~";
    tipLabel.font = [UIFont fontWithName:kFontNormal size:12];
    tipLabel.textColor = kColor999;
    tipLabel.numberOfLines = 1;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [tipView addSubview:tipLabel];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipView).offset(0);
        make.left.equalTo(tipView).offset(10);
    }];
}
-(void)setFansClubModel:(JHFansClubModel *)fansClubModel{
    
    _fansClubModel = fansClubModel;
    [_headImage jh_setImageWithUrl:_fansClubModel.anchorIcon];
    _nameLabel.text = _fansClubModel.fansClubName;
    _fansCountLabel.text = [NSString stringWithFormat:@"亲密粉丝%@人",_fansClubModel.totalfansCount];
    
}
-(void)buttonPress:(UIButton*)button{
    
}
-(void)alterNickName{
    
   // [JHTaskHUD showTitle:@"分享成功" desc:@"+10亲密度" toNum:0];
   // [UITipView showTipStr:@"恭喜您成功加入至尊财神的粉丝团"];
    if (_alert) {
        [_alert removeFromSuperview];
        _alert = nil;
    }
    _alert = [[JHFansAlterNickNameView alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:_alert];
    @weakify(self);
    _alert.alterNameBlock = ^{
        
        @strongify(self);
        [self alterName];
    };
}
-(void)alterName{
    
    NSDictionary *par = @{@"anchorId" : @"",@"fansClubId" : @"",@"fansClubName" : @""};
    NSString *url = FILE_BASE_STRING(@"/app/fans/fans-club/updateClubName");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
        [_alert removeFromSuperview];
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];
    }];
    [SVProgressHUD show];
    
}
-(void)FansRuleIntroduce{
    
     //TODO jiang 粉丝规则说明
    JHFansEquityWebView * first =[[JHFansEquityWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 450 + UI.bottomSafeAreaHeight)];
    [JHKeyWindow addSubview:first];
    [first showAlert];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

