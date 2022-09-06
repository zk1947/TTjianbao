//
//  JHLotteryRuleCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryRuleCell.h"
#import "UIImage+JHColor.h"
#import "JHRightArrowBtn.h"
#import "JHWebViewController.h"
#import "GrowingManager+Lottery.h"
#import "UIView+CornerRadius.h"
#import "UIButton+ImageTitleSpacing.h"

@interface JHLotteryRuleCell ()
@property (strong, nonatomic)  UIView  *paddingTopView;
@property (strong, nonatomic)  UILabel *periodTitleLabel;
@property (strong, nonatomic)  UILabel *periodDescLabel;
@property (strong, nonatomic)  UIView *progressView;
@property (strong, nonatomic)  UIImageView *progressImage;
@end

@implementation JHLotteryRuleCell

+ (CGFloat)cellHeight {
    return 106.0 + 10;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyleEnabled = NO;
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    _paddingTopView = [UIView new];
    _paddingTopView.backgroundColor = kColorF5F6FA;
    [self.contentView addSubview:_paddingTopView];
    [_paddingTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(10);
    }];
    
    _periodTitleLabel=[[UILabel alloc]init];
    _periodTitleLabel.text=@"20200702期";
    _periodTitleLabel.font=[UIFont fontWithName:kFontBoldDIN size:16];
    _periodTitleLabel.textColor=kColor333;
    [self.contentView addSubview:_periodTitleLabel];
    
    [_periodTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.paddingTopView.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(15);
    }];
    _periodDescLabel=[[UILabel alloc]init];
    _periodDescLabel.text=@"（共2张抽奖码）";
    _periodDescLabel.font=[UIFont fontWithName:kFontNormal size:14];
    _periodDescLabel.textColor=kColor333;
    [self.contentView addSubview:_periodDescLabel];
    
    [_periodDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_periodTitleLabel);
        make.left.equalTo(_periodTitleLabel.mas_right).offset(10);
    }];
   //
    UIButton *ruleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    ruleBtn.backgroundColor = [UIColor clearColor];
    [ruleBtn setTitle:@"规则" forState:UIControlStateNormal];
    ruleBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    [ruleBtn setTitleColor:kColor999 forState:UIControlStateNormal];
    [ruleBtn setImage:[UIImage imageNamed:@"order_confirm_right_jiantou"] forState:UIControlStateNormal];
    [ruleBtn addTarget:self action:@selector(showRule) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:ruleBtn];
    [ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_periodTitleLabel);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    [ruleBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
                               imageTitleSpace:5];
    
   UIImageView  *progressBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lottery_progross_back_img"]];
      [self addSubview:progressBack];
      [progressBack mas_makeConstraints:^(MASConstraintMaker *make) {
          make.height.equalTo(@11);
          make.top.equalTo(_periodTitleLabel.mas_bottom).offset(10);
          make.left.equalTo(self.contentView).offset(10);
          make.right.equalTo(self.contentView).offset(-10);
      }];
    
         _progressView = [[UIView alloc] init];
         [progressBack addSubview:_progressView];
         [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.bottom.equalTo(progressBack);
             make.left.equalTo(progressBack).offset(3);
             make.right.equalTo(progressBack).offset(-3);
         }];
    
    for (int i = 0; i<7; i++) {
        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lottery_progross_line_img"]];
        [_progressView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@11);
            make.width.offset(1);
            make.centerY.equalTo(_progressView);
            make.left.equalTo(_progressView).offset(i*(ScreenW-20-6)/6);
        }];
        if (i==0||i==6) {
            [line setHidden:YES];
        }
        UILabel *title=[[UILabel alloc]init];
        title.text=[NSString stringWithFormat:@"%d张",i];
        title.font=[UIFont fontWithName:kFontMedium size:10];
        title.textColor=kColor999;
        title.tag = 100+i;
        [self.contentView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_progressView.mas_bottom).offset(10);
            if (i==0) {
                make.left.equalTo(_progressView);
            }
            else if (i==6) {
                make.right.equalTo(_progressView);
            }
            else{
                make.centerX.equalTo(line);
            }
        }];
    }
}
-(void)setCodeCount:(NSInteger)codeCount{
    
    _codeCount = codeCount;
    if (_codeCount>6) {
        _codeCount = 6;
    }
    _periodDescLabel.text=[NSString stringWithFormat:@"(共%ld张抽奖码)",(long)_codeCount];
    [_progressImage removeFromSuperview];
    _progressImage=nil;
    CGFloat width = (ScreenW-20-6)/6*_codeCount;
    UIImage *image = [UIImage gradientThemeImageSize:CGSizeMake(width, 6) radius:0];
    self.progressImage = [[UIImageView alloc] initWithImage:image];
    self.progressImage.layer.masksToBounds = YES;
    if (_codeCount==6) {
        [self.progressImage yd_setCornerRadius:3 corners:UIRectCornerAllCorners ];
    }
    else{
        [self.progressImage yd_setCornerRadius:3 corners:UIRectCornerTopLeft | UIRectCornerBottomLeft];
    }
    [_progressView addSubview:self.progressImage];
    [self.progressImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_progressView);
        make.left.equalTo(_progressView).offset(0);
    }];
      for (int i = 0; i<7; i++) {
        UILabel * label = [self viewWithTag:100+i];
        label.textColor=kColor999;
    }
    UILabel * label = [self viewWithTag:100+_codeCount];
    label.textColor=kColor333;
}
-(void)setActivityData:(JHLotteryActivityData *)activityData{
    _activityData = activityData;
     _periodTitleLabel.text=[NSString stringWithFormat:@"%@期",_activityData.activityDate];
}

#pragma mark - action
- (void)showRule {
    JHWebViewController * view = [[JHWebViewController alloc] init];
    view.urlString = self.activityData.ruleHtml; //compile error
    [self.viewController.navigationController pushViewController:view animated:YES];
    
    //埋点-点击规则按钮
    NSDictionary *params = @{@"activityDate" : _activityData.activityDate};
    [GrowingManager lotteryClickRule:params];
}
@end
