//
//  JHGraphiclOrderListCell.m
//  TTjianbao
//
//  Created by 张坤 on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGraphiclOrderListCell.h"
#import "JHItemMode.h"
#import "TTjianbaoHeader.h"
#import "EnlargedImage.h"
#import "UIButton+ImageTitleSpacing.h"
#import "UIImage+JHColor.h"
#import "JHCommMenuView.h"
#import "YYControl.h"
#import "NSString+NTES.h"
#import "JHNewShopDetailViewController.h"
#import "YDCountDown.h"
#import "JHGraphic0rderBottomView.h"
#import "JHGraphiclOrderDelegate.h"
#import "JHGraphicalBottomModel.h"

@interface JHGraphiclOrderListCell () {
    UIImageView * circleIcon;
}
//@property (strong, nonatomic)  UIImageView *headImage;
//@property (strong, nonatomic)  UIImageView *nameArrowImage;
@property (strong, nonatomic)  YYAnimatedImageView *liveGifView;
@property (strong, nonatomic)  UIImageView *displayImage;
//@property (strong, nonatomic)  UILabel* name;
@property (strong, nonatomic)  UILabel* title;
@property (strong, nonatomic)  UILabel* countDownTime;
@property (strong, nonatomic)  UILabel* orderCode;
@property (strong, nonatomic)  UILabel *orderTime;
@property (strong, nonatomic)  UILabel *orderStatusLabel;
@property (strong, nonatomic)  JHGraphic0rderBottomView *buttonBackView;
/// 倒计时
@property (nonatomic, strong) YDCountDown *countDown;

@end
@implementation JHGraphiclOrderListCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.layer.cornerRadius = 8;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.backgroundColor=[UIColor whiteColor];
        
        circleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mall_like_circle_img"]];
        circleIcon.hidden = YES;
        [self.contentView addSubview:circleIcon];
        [circleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(7);
            make.size.mas_equalTo(CGSizeMake(33, 33));
            make.left.offset(15);
        }];
                
        NSString *path = [[NSBundle mainBundle] pathForResource:@"icon_on_live" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        YYImage *image = [YYImage imageWithData:data];
        _liveGifView = [[YYAnimatedImageView alloc] initWithImage:image];
        _liveGifView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_liveGifView];
        _liveGifView.hidden = YES;
        
        [_liveGifView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(circleIcon);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
        
        
        _orderStatusLabel=[[UILabel alloc]init];
        _orderStatusLabel.text=@"";
        _orderStatusLabel.font=[UIFont systemFontOfSize:12];
        _orderStatusLabel.backgroundColor=[UIColor clearColor];
        _orderStatusLabel.textColor=HEXCOLOR(0xFF333333);
        _orderStatusLabel.numberOfLines = 1;
        _orderStatusLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_orderStatusLabel];
        
        [_orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.mas_equalTo(10);
        }];
        
        _countDownTime=[[UILabel alloc]init];
        _countDownTime.text=@"47:59:59";
        _countDownTime.font=[UIFont systemFontOfSize:12];
        _countDownTime.textColor=HEXCOLOR(0xFFFF4200);
        _countDownTime.numberOfLines = 1;
        _countDownTime.textAlignment = NSTextAlignmentLeft;
        _countDownTime.hidden = YES;
        [self.contentView addSubview:_countDownTime];
        
        [_countDownTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_orderStatusLabel);
            make.right.mas_equalTo(-10);
        }];
        
        UIView * line=[[UIView alloc]init];
        line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
        [self.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(_orderStatusLabel.mas_bottom).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.offset(1);
        }];
        
        _displayImage=[[UIImageView alloc]init];
        _displayImage.image=[UIImage imageNamed:@""];
        _displayImage.contentMode = UIViewContentModeScaleAspectFill;
        _displayImage.layer.masksToBounds=YES;
        _displayImage.userInteractionEnabled=YES;
        _displayImage.layer.cornerRadius =8;
        [self.contentView addSubview:_displayImage];
        [_displayImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(75, 75));
            make.left.equalTo(_orderStatusLabel);
        }];
    
        _title=[[UILabel alloc]init];
        _title.text=@"";
        _title.font=[UIFont boldSystemFontOfSize:14];
        _title.backgroundColor=[UIColor clearColor];
        _title.textColor=[CommHelp toUIColorByStr:@"#222222"];
        _title.numberOfLines = 1;
        _title.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_title];
        
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_displayImage.mas_top).mas_offset(18);
            make.right.mas_equalTo(-10);
            make.left.equalTo(_displayImage.mas_right).offset(10);
            
        }];
        
        _orderTime=[[UILabel alloc]init];
        _orderTime.text=@"";
        _orderTime.font=[UIFont systemFontOfSize:12];
        _orderTime.textColor=[CommHelp toUIColorByStr:@"#FF666666"];
        _orderTime.numberOfLines = 1;
        _orderTime.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_orderTime];
        
        [_orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_displayImage.mas_bottom).offset(-18);
            make.left.equalTo(_displayImage.mas_right).offset(10);
            
        }];
        
        _buttonBackView=[[JHGraphic0rderBottomView alloc]init];
        [self.contentView addSubview:_buttonBackView];
        [_buttonBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(0);
            make.bottom.equalTo(self.contentView).offset(0);
            make.right.equalTo(self.contentView).offset(0);
            make.height.offset(45);
        }];
        @weakify(self);
        _buttonBackView.buttonBlock = ^(JHGraphicalBottomModel * _Nullable model) {
            @strongify(self);
            
            JHGraphicalSubModel *bottommodel = self.orderMode;
            SEL Seletor = NSSelectorFromString(model.selName);
            if ([self.delegate respondsToSelector:Seletor]) {
                Class Cls = [self.delegate class];
                NSMethodSignature *sig= [Cls instanceMethodSignatureForSelector:Seletor];
                NSInvocation *invocation=[NSInvocation invocationWithMethodSignature:sig];
                [invocation setTarget:self.delegate];
                [invocation setSelector:Seletor];
                [invocation setArgument:&bottommodel atIndex:2];
                [invocation invoke];
               
            }
    
        };
    }
    
    return self;
}

-(void)setOrderMode:(JHGraphicalSubModel *)orderMode{
    
    _orderMode=orderMode;
    [_displayImage jhSetImageWithURL:[NSURL URLWithString:_orderMode.showImageSmallUrl] placeholder:kDefaultCoverImage];
    _orderTime.text = [NSString stringWithFormat:@"申请时间:%@",_orderMode.applyTime];
    _title.text = [NSString stringWithFormat:@"鉴定类目:%@",_orderMode.appraisalCateName];
    int expireTime = _orderMode.expireTime.intValue/1000;
    
    // 待付款
    if(orderMode.orderStatus.intValue == 1 ||
       orderMode.orderStatus.intValue == 2 ||
       orderMode.orderStatus.intValue == 11){
        self.countDownTime.hidden = NO;
        if (expireTime > 0) {
            @weakify(self);
            [self.countDown destoryTimer];
            [self.countDown startWithFinishTimeStamp:expireTime completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
                @strongify(self);
                NSInteger newHour = day*24+hour;
                if (newHour == 0 && minute == 0 && second == 0) {
                    [self.countDown destoryTimer];
                    self.countDownTime.hidden = YES;
                    [self performSelector:@selector(p_refreshThePage) withObject:nil afterDelay:1.0f];
                   
                } else {
                    
                    NSString *countDownTip = [NSString stringWithFormat:@"%ld:%ld:%ld", (long)newHour, (long)minute, (long)second];
                    self.countDownTime.text = countDownTip;
                }
            }];
        }
        
    }else {
        [self.countDown destoryTimer];
        self.countDownTime.hidden = YES;
    }
    
    self.orderStatusLabel.text = _orderMode.orderStatusText;
    _buttonBackView.hidden = orderMode.bottomButtons.count == 0 ? YES : NO;
    [self.buttonBackView updateGraphicBottom:orderMode.bottomButtons];
    
}

- (void)p_refreshThePage {
    if ([self.delegate respondsToSelector:@selector(countdownOver)]) {
        [self.delegate countdownOver];
    }
    
}

-(void)setOrderRemainTime:(NSString *)orderRemainTime{
    
    _orderRemainTime=orderRemainTime;
    _orderStatusLabel.text=orderRemainTime;
}

#pragma mark - set/get
- (YDCountDown *)countDown {
    if (!_countDown) {
        _countDown = [[YDCountDown alloc] init];
    }
    return _countDown;
}

- (void)dealloc
{
    [self.countDown destoryTimer];
}
@end
