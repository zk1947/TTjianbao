//
//  JHAudienceApplyCustomizeView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/9/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAudienceApplyCustomizeView.h"
#import "JHGrowingIO.h"
#import "TTjianbaoHeader.h"
#import "UIImage+JHColor.h"
#import "UIView+CornerRadius.h"
#import "JHApplyCustomizeOrderView.h"

@interface JHAudienceApplyCustomizeView(){
    
}
@property (nonatomic, strong)  UIButton* sureBtn;
@property(nonatomic,strong) UILabel * titleLabel;
@property(nonatomic,strong) UILabel * tipLabel;
@property(nonatomic,strong) UILabel * cusAreaLabel;
@property(nonatomic,strong) UIView * bar;
@property(nonatomic,strong) OrderMode * orderModel;
@property(nonatomic,strong) JHApplyCustomizeOrderView *chooseOrderImageView;

@end
@implementation JHAudienceApplyCustomizeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        _bar =  [[UIView alloc]init];
        _bar.backgroundColor= [CommHelp toUIColorByStr:@"#ffffff"];
        _bar.userInteractionEnabled = YES;
        _bar.layer.masksToBounds = YES;
        _bar.frame= CGRectMake(0, 0, ScreenW, 420);
        [_bar yd_setCornerRadius:8.f corners:UIRectCornerAllCorners];
        [self addSubview:_bar];

        UIView *topView =  [[UIView alloc] init];
        // topView.frame = CGRectMake(0,0,375,50);
        topView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        topView.layer.cornerRadius = 0;
        topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
        topView.layer.shadowOffset = CGSizeMake(0,1);
        topView.layer.shadowOpacity = 1;
        topView.layer.shadowRadius = 5;
        [_bar addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((_bar)).offset(0);
            make.left.right.equalTo(_bar);
            make.height.offset(50);

        }];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColor333;
        _titleLabel.text=@"";
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15.f];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [topView addSubview:_titleLabel];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //  make.top.equalTo((_bar)).offset(15);
            make.center.equalTo(topView);
        }];

        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"new_appraisal_close"] forState:UIControlStateNormal ];
        closeButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:closeButton];


        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel);
            make.right.equalTo(topView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];

        _tipLabel=[[UILabel alloc]init];
        _tipLabel.text=@"";
        _tipLabel.font=[UIFont fontWithName:kFontNormal size:12];
        _tipLabel.textColor=[CommHelp toUIColorByStr:@"#999999"];
        _tipLabel.numberOfLines = 2;
        _tipLabel.textAlignment = NSTextAlignmentLeft;
        _tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_bar addSubview:_tipLabel];

        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).offset(10);
            make.left.equalTo(_bar).offset(10);
            make.right.equalTo(_bar).offset(-10);

        }];

        _chooseOrderImageView=[[JHApplyCustomizeOrderView alloc]init];
        _chooseOrderImageView.userInteractionEnabled = YES;
        [_bar addSubview:_chooseOrderImageView];

        @weakify(self);
        _chooseOrderImageView.clickBlock = ^(id obj) {
            @strongify(self);
            self.orderModel = (OrderMode*)obj;
            
        };
        _chooseOrderImageView.cameraBlock = ^() {
            @strongify(self);
          
           if (self.cameraBlock) {
                self.cameraBlock();
            }
            [self hiddenAlert];
        };
        [_chooseOrderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tipLabel.mas_bottom).offset(10);
            make.left.right.equalTo(_bar);
            make.height.equalTo(@120);
        }];
        
       UIView  *lineView=[[UIView alloc]init];
        lineView.backgroundColor = [CommHelp toUIColorByStr:@"#f5f6fa"];
        [_bar addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_chooseOrderImageView.mas_bottom).offset(10);
            make.left.right.equalTo(_bar);
            make.height.equalTo(@10);
        }];

        _cusAreaLabel=[[UILabel alloc]init];
        _cusAreaLabel.text=@"";
        _cusAreaLabel.font=[UIFont fontWithName:kFontNormal size:13];
        _cusAreaLabel.textColor=[CommHelp toUIColorByStr:@"#333333"];
        _cusAreaLabel.numberOfLines = 2;
        _cusAreaLabel.textAlignment = NSTextAlignmentLeft;
        _cusAreaLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_bar addSubview:_cusAreaLabel];

        [_cusAreaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineView.mas_bottom).offset(10);
            make.left.equalTo(_bar).offset(10);
            make.right.equalTo(_bar).offset(-10);
        }];


        _sureBtn=[[UIButton alloc]init];
        _sureBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_sureBtn setTitle:@"申请连麦" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font=[UIFont fontWithName:kFontMedium size:14];
        [_sureBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(320, 44) radius:22];
        [_sureBtn setBackgroundImage:nor_image forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bar addSubview:_sureBtn];

        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          //  make.top.equalTo(_cusAreaLabel.mas_bottom).offset(20);
            make.centerX.equalTo(_bar);
            make.bottom.equalTo(_bar).offset(-20-UI.bottomSafeAreaHeight);
            make.size.mas_equalTo(CGSizeMake(320, 44));
        }];
        
    }
    return self;
}
- (void)close
{
    [self hiddenAlert];
}
- (void)cancelClick:(UIButton *)sender{
    
    [self hiddenAlert];
    
    //    if (self.cancleClick) {
    //        self.cancleClick();
    //    }
}
-(void)sureClick:(UIButton *)sender{
    
   
    if (!self.orderModel) {
        [self makeToast:@"请选择定制订单" duration:2 position:CSToastPositionCenter];
        return;
    }
    
    NSMutableDictionary *dic = [[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues] mutableCopy];
    [dic setObject:@"ordercam" forKey:@"sqlm"];
    [JHGrowingIO trackEventId:JHTrackCustomizelive_lmdz_sqlm_click variables:dic];
    if (self.completeBlock) {
        self.completeBlock(self.orderModel);
    }
    [self hiddenAlert];
}
- (void)showAlert
{
    self.bar.top =  self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom =  self.height;
    }];
     [self requestInfo];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)hiddenAlert{
   [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
-(void)requestInfo{
    
   
    [HttpRequestTool getWithURL:[FILE_BASE_STRING(@"/channel/customized/viewer/base?channelId=")stringByAppendingString:self.channelId] Parameters:@{@"channelId":self.channelId} successBlock:^(RequestModel *respondObject) {
        NSArray *array = [OrderMode mj_objectArrayWithKeyValuesArray:respondObject.data[@"viewerOrderInfos"]];
          [self.chooseOrderImageView setDataModes:[array mutableCopy]];
          self.titleLabel.text = respondObject.data[@"tip1"];
          self.tipLabel.text = respondObject.data[@"tip2"];
          self.cusAreaLabel.text = respondObject.data[@"customizeArea"];
}
        failureBlock:^(RequestModel *respondObject) {

        [self makeToast:respondObject.message];

    }];
}

- (void)dealloc
{
    NSLog(@"cccccdealloc");
}
@end
