//
//  JHApplyMicSuccessAlertView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/4/2.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHApplyMicSuccessAlertView.h"
#import "JHGrowingIO.h"
#import "TTjianbaoHeader.h"
#import "UIImage+JHColor.h"
#import "UIView+CornerRadius.h"
#import "JHApplyMicRecommendView.h"

@interface JHApplyMicSuccessAlertView (){
    
    UIView *showview ;
}
@property (nonatomic, strong)  UIButton* sureBtn;
@property(nonatomic,copy)sureBlock sureClick;
@property(nonatomic,copy)cancleBlock cancleClick;
@property(nonatomic,copy) UILabel * countLabel;
@property(nonatomic,copy) UILabel * timeLabel;
@property(nonatomic,copy) JHApplyMicRecommendView *recommendView;

@end
@implementation JHApplyMicSuccessAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       // self.frame = CGRectMake(0, self.height, self.width, self.height);
       // self.backgroundColor= [UIColor blackColor];
        //self.userInteractionEnabled = YES;
//        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelClick:)]];
      [self addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
         showview =  [[UIView alloc]init];
         showview.backgroundColor= [CommHelp toUIColorByStr:@"#ffffff"];
      //  showview.center=self.center;
         showview.userInteractionEnabled = YES;
      //  showview.contentMode=UIViewContentModeScaleAspectFit;
        [showview yd_setCornerRadius:8.f corners:UIRectCornerAllCorners];
        [self addSubview:showview];
        [showview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(260);
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"new_appraisal_close"] forState:UIControlStateNormal ];
        closeButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:closeButton];
        
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(showview).offset(5);
            make.right.equalTo(showview).offset(-5);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
//        UILabel * viewTitle=[[UILabel alloc]init];
//        viewTitle.text=@"请等待主播与您连线";
//        viewTitle.font=[UIFont systemFontOfSize:12];
//        viewTitle.textColor=[CommHelp toUIColorByStr:@"#999999999"];
//        viewTitle.numberOfLines = 2;
//        viewTitle.textAlignment = UIControlContentHorizontalAlignmentLeft;
//        viewTitle.lineBreakMode = NSLineBreakByWordWrapping;
//        [showview addSubview:viewTitle];
//
//        [viewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(showview).offset(70);
//            make.left.right.equalTo(showview);
//
//        }];
        
        UIView * countBack=[[UIView alloc]init];
        [showview addSubview:countBack];
        
        [countBack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(showview).offset(40);
            make.centerX.equalTo(showview);
            
        }];
        
        UIImageView *logo =  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"apprise_applysuccess_icon"]];
        logo.contentMode=UIViewContentModeScaleAspectFit;
        [countBack addSubview:logo];
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(countBack);
            make.left.equalTo(countBack);
            
        }];
        
        _countLabel=[[UILabel alloc]init];
       
        _countLabel.font=[UIFont fontWithName:kFontMedium size:18];
        _countLabel.textColor=[CommHelp toUIColorByStr:@"#222222"];
        _countLabel.numberOfLines = 2;
        _countLabel.text=@"";
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [countBack addSubview:_countLabel];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(logo);
            make.left.equalTo(logo.mas_right).offset(10);
            make.right.equalTo(countBack);
            
        }];
        
         _timeLabel=[[UILabel alloc]init];
        _timeLabel.text=@"";
        _timeLabel.font=[UIFont systemFontOfSize:12];
        _timeLabel.textColor=[CommHelp toUIColorByStr:@"#222222"];
        _timeLabel.numberOfLines = 2;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [showview addSubview:_timeLabel];
        
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(_countLabel.mas_bottom).offset(10);
            make.left.right.equalTo(showview);
            
        }];
        
        UILabel * tip=[[UILabel alloc]init];
        tip.text=@"推荐您逛逛直播购物";
        tip.font=[UIFont fontWithName:kFontNormal size:13];
        tip.textColor=[CommHelp toUIColorByStr:@"#333333"];
        tip.numberOfLines = 2;
        tip.textAlignment = NSTextAlignmentCenter;
        tip.lineBreakMode = NSLineBreakByWordWrapping;
        [showview addSubview:tip];
        
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timeLabel.mas_bottom).offset(30);
            make.left.right.equalTo(showview);
            
        }];
        
        _recommendView=[[JHApplyMicRecommendView alloc]init];
        _recommendView.userInteractionEnabled = YES;
        [showview addSubview:_recommendView];
        
        @weakify(self);
        _recommendView.clickBlock = ^(id obj) {
        @strongify(self);
        [self HideMicPopView];
          NSString *roomId = (NSString*)obj;
          [JHRootController EnterLiveRoom:roomId fromString:@""];

        };
        [_recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tip.mas_bottom).offset(10);
            make.left.right.equalTo(showview);
             make.height.equalTo(@110);
        }];
        
//        UIButton* cancleBtn=[[UIButton alloc]init];
//        cancleBtn.contentMode=UIViewContentModeScaleAspectFit;
//        [cancleBtn setTitle:@"继续等待" forState:UIControlStateNormal];
//        cancleBtn.titleLabel.font=[UIFont systemFontOfSize:14];
//        [cancleBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
//        [cancleBtn setBackgroundImage:[UIImage imageNamed:@"Mic_Left_button.png"] forState:UIControlStateNormal];
//        [cancleBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
//        [showview addSubview:cancleBtn];
//
//        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//             make.top.equalTo(tip.mas_bottom).offset(20);
//             make.bottom.equalTo(showview.mas_bottom).offset(-15);
//             make.left.offset(25);
//
//        }];
        
        _sureBtn=[[UIButton alloc]init];
        _sureBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_sureBtn setTitle:@"逛逛直播购物" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_sureBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
//        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"Mic_right_button.png"] forState:UIControlStateNormal];
        UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(160, 38) radius:19];
        [_sureBtn setBackgroundImage:nor_image forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
        [showview addSubview:_sureBtn];
        
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_recommendView.mas_bottom).offset(20);
            make.centerX.equalTo(showview);
            make.bottom.equalTo(showview).offset(-20);
             make.size.mas_equalTo(CGSizeMake(160, 38));
        }];
      
        
    }
    return self;
}

-(void)setMode:(JHMicWaitMode *)mode{
   
     _mode=mode;
     _countLabel.text=[NSString stringWithFormat:@"前方排队%d人",_mode.waitCount-1];
//     _timeLabel.text=[NSString stringWithFormat:@"预计需时%@分",[CommHelp getHMSWithSecond:_mode.waitCount*_mode.singleWaitSecond]];
    _timeLabel.text=[NSString stringWithFormat:@"预计需要%d分钟",(_mode.waitCount-1)*_mode.singleWaitSecond/60];
}
-(void)withSureClick:(sureBlock)block{
    
    self.sureClick = block;
    
}
-(void)withCancleClick:(cancleBlock)block{
    
    self.cancleClick = block;
    
}
- (void)close
{
    [JHGrowingIO trackEventId:JHLiveRoomMicCloseClick];
    [self HideMicPopView];
}
- (void)cancelClick:(UIButton *)sender{
    

    [self HideMicPopView];
    
    if (self.cancleClick) {
        self.cancleClick();
    }
 [JHGrowingIO trackEventId:JHTracklive_identifywait2_wait variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    
}
-(void)sureClick:(UIButton *)sender{
    
    [self HideMicPopView];
    
    if (self.sureClick) {
        self.sureClick();
    }
    [JHGrowingIO trackEventId:JHTracklive_identifywait2_guangguang variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
}
- (void)showAlert {
    CGRect rect = self.frame;
    rect.origin.y = 0;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
     [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self requestInfo];
}
-(void)HideMicPopView{
   
    CGRect rect = self.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25 animations:^{
           self.frame = rect;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
   
}
-(void)requestInfo{
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/channel/sellChannelsDiversion?diversionNo=%ld"),3];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSArray *arr = [JHLiveRoomMode mj_objectArrayWithKeyValuesArray:respondObject.data];
        if (arr.count>0) {
             [self.recommendView setDataModes:[arr mutableCopy]];
        }
        else{
            [_recommendView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }
    }
        failureBlock:^(RequestModel *respondObject) {
        [_recommendView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }];
}
- (void)dealloc
{
    NSLog(@"cccccdealloc");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
