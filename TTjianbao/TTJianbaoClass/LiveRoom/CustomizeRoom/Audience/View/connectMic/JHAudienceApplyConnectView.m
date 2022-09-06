//
//  JHAudienceApplyConnectView.m
//  TTjianbao
//
//  Created by jiangchao on 2018/12/28.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "JHAudienceApplyConnectView.h"
#import "UIView+NTES.h"
#import "NTESDataManager.h"
#import "NIMAvatarImageView.h"
#import "NTESLiveManager.h"
#import "UIImage+GIF.h"
#import "HKClipperHelper.h"
#import <QBImagePickerController/QBImagePickerController.h>
#import "TTjianbaoHeader.h"
#import "TTjianbaoBussiness.h"
#import "HKClipperHelper.h"
#import "MBProgressHUD.h"
#import "NOSUpImageTool.h"
#import "UIImage+JHColor.h"
@interface JHAudienceApplyConnectView()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIImage * cameraImage;
    UIButton *cameraBackImage;
    
}
@property (nonatomic, strong) UIView *bar;

@property (nonatomic, strong) UIImageView *anchorAvatar;
@property (nonatomic, strong) UIImageView *audienceAvatar;

@property (nonatomic, strong) UILabel *waitingNumLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong)  UIImageView *cameraImageView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *typeTitle;
@property (strong, nonatomic) UIImage *photoImg;
@property (nonatomic, strong)  NSString *imageUrl;

@end

@implementation JHAudienceApplyConnectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _bar = [[UIView alloc] init];
        _bar.frame = CGRectMake(0,0,frame.size.width,375.5);

        _bar.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
//        _bar.layer.cornerRadius = 16;
        
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:_bar.bounds byRoundingCorners: UIRectCornerTopLeft  | UIRectCornerTopRight cornerRadii:CGSizeMake(16, 16)];
        CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = maskPath.CGPath;
        _bar.layer.mask = maskLayer;
        _bar.userInteractionEnabled=YES;
        [self addSubview:_bar];
        UIView *titleView = [[UIView alloc] init];
        titleView.frame = CGRectMake(0,0,frame.size.width,40.5);
        titleView.backgroundColor = [UIColor colorWithRed:255/255.0 green:252/255.0 blue:231/255.0 alpha:1.0];
        titleView.layer.cornerRadius = 16;
        [_bar addSubview:titleView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor =[CommHelp toUIColorByStr:@"#999999"];
        _titleLabel.text=@"先给宝贝拍张照片，鉴定师稍后会和你连线";
        _titleLabel.font = [UIFont systemFontOfSize:11.f];
        [titleView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.equalTo(titleView);
          
        }];
        
        UIImageView *titileLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"live_audience_apply_logo"] ];
        titileLogo.contentMode=UIViewContentModeScaleAspectFit;
        [titleView addSubview:titileLogo];
        
        [titileLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo((_titleLabel.mas_left)).offset(-10);
            make.centerY.equalTo(titleView);
            
        }];
        
        cameraBackImage = [UIButton buttonWithType:UIButtonTypeCustom];
          [cameraBackImage  setBackgroundImage:[UIImage imageNamed:@"live_audience_apply_back"] forState:UIControlStateNormal];
        [cameraBackImage addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
//        [cameraBackImage setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//         cameraBackImage.imageView.contentMode=UIViewContentModeScaleAspectFill;
//        cameraBackImage.imageView.clipsToBounds=YES;
        [_bar addSubview:cameraBackImage];
        
        [cameraBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((titleView.mas_bottom)).offset(10);
            make.centerX.equalTo(_bar);
            make.size.mas_equalTo(CGSizeMake(285,185));
        }];
        
        self.cameraImageView = [[UIImageView alloc]init];
        self.cameraImageView.contentMode=UIViewContentModeScaleAspectFill;
        self.cameraImageView.clipsToBounds=YES;
        [cameraBackImage addSubview:self.cameraImageView];
        [self.cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(cameraBackImage).offset(5);
            make.bottom.right.equalTo(cameraBackImage).offset(-5);
        }];
         
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cameraBtn setBackgroundImage:[UIImage imageNamed:@"live_audience_apply_ camera"] forState:UIControlStateNormal ];
        cameraBtn.contentMode=UIViewContentModeScaleAspectFit;
        [cameraBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
        [cameraBackImage addSubview:cameraBtn];
        
        [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo((cameraBackImage)).offset(-10);
            make.centerX.equalTo(cameraBackImage);
            
        }];
        
        UILabel * title=[[UILabel alloc]init];
        title.text=@"拍摄宝贝";
        title.font=[UIFont systemFontOfSize:12];
        title.backgroundColor=[UIColor clearColor];
        title.textColor=[CommHelp toUIColorByStr:@"#333333"];
        title.numberOfLines = 1;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [cameraBackImage addSubview:title];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cameraBtn.mas_bottom).offset(10);
            make.centerX.equalTo(cameraBackImage);
            
        }];
        
        UILabel * desc=[[UILabel alloc]init];
        desc.text=@"图片大小不超过2M";
        desc.font=[UIFont systemFontOfSize:10];
        desc.backgroundColor=[UIColor clearColor];
        desc.textColor=[CommHelp toUIColorByStr:@"#333333"];
        desc.numberOfLines = 1;
        desc.textAlignment = UIControlContentHorizontalAlignmentCenter;
        desc.lineBreakMode = NSLineBreakByWordWrapping;
        [cameraBackImage addSubview:desc];
        
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_bottom).offset(5);
            make.centerX.equalTo(cameraBackImage);
            
        }];
        
        _typeTitle = [UILabel new];
        _typeTitle.text = @"鉴定范围：";
        _typeTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _typeTitle.textColor = HEXCOLOR(0xFF4200);
        [_bar addSubview:_typeTitle];
        
        [_typeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cameraBackImage);
            make.width.equalTo(@75);
            make.top.equalTo(cameraBackImage.mas_bottom).offset(5);
        }];
        _typeTitle.hidden=YES;
        _typeLabel = [UILabel new];
        _typeLabel.textColor = _typeTitle.textColor;
        _typeLabel.font = _typeTitle.font;
        _typeLabel.numberOfLines = 0;
        _typeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_bar addSubview:_typeLabel];
        [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_typeTitle.mas_right);
            make.top.equalTo(_typeTitle);
            make.right.equalTo(cameraBackImage);
        }];
        
        _desWarningLabel = [UILabel new];
        _desWarningLabel.textColor = kColor999;
        _desWarningLabel.font = [UIFont fontWithName:kFontNormal size:10];
        _desWarningLabel.numberOfLines = 0;
        _desWarningLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _desWarningLabel.text = @"平台对连线鉴定进行全程监控，对任何不文明及违反法律、平台规则的行为将严厉打击，有权将相关信息移交公安等有关部门予以严肃处理！";
        [_bar addSubview:_desWarningLabel];
        [_desWarningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_typeTitle.mas_left);
            make.top.equalTo(_typeLabel.mas_bottom).offset(5);
            make.right.equalTo(cameraBackImage);
        }];
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
         UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(320, 44) radius:22];
        [_sureButton setBackgroundImage:nor_image forState:UIControlStateNormal];
        [_sureButton setTitle:@"申请鉴定" forState:UIControlStateNormal];
        _sureButton.titleLabel.font=[UIFont systemFontOfSize:14];
        [_sureButton setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        _sureButton.contentMode=UIViewContentModeScaleAspectFit;
        [_sureButton addTarget:self action:@selector(complete:) forControlEvents:UIControlEventTouchUpInside];
        [_bar addSubview:_sureButton];
        
        [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
        
        [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo((_bar));
            make.bottom.equalTo(_bar.mas_bottom).offset(-15);
            
        }];
        
//            UIWindow *window = [UIApplication sharedApplication].keyWindow;
//            [window addSubview:self];

    }
    return self;
}

- (void)setEndAppraise {
    _titleLabel.text=@"先给宝贝拍张照片，再结束吧";
    [_sureButton setTitle:@"确定结束" forState:UIControlStateNormal];
}

-(void)addPhoto{

     [JHGrowingIO trackEventId:JHTracklive_identifyapply_paishe variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
//    if ([self.delegate respondsToSelector:@selector(addPhoto)]) {
//        [self.delegate addPhoto];
//    }
    // if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle) {
         [JHAllStatistics jh_allStatisticsWithEventId:@"clickOther" params:@{@"channel_local_id":self.channel.channelLocalId,@"page_position":@"recyclingLiveLayer",@"other_name":@"takePicture"} type:JHStatisticsTypeSensors];
    // }
    [self choosePhoto];
}
- (void)onTapBackground:(UIButton *)button
{
    [self dismiss];
}

- (void)complete:(UIButton *)button
{
    
    // if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle) {
         [JHAllStatistics jh_allStatisticsWithEventId:@"clickOther" params:@{@"channel_local_id":self.channel.channelLocalId,@"page_position":@"recyclingLiveLayer",@"other_name":@"applyConnection"} type:JHStatisticsTypeSensors];
    // }
    
    if (!cameraImage) {
          [[UIApplication sharedApplication].keyWindow makeToast:@"请拍摄一张照片" duration:1.0 position:CSToastPositionCenter];
        return;
    }
     [JHGrowingIO trackEventId:JHTracklive_identifyapply_applybtn variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
//    if ([self.delegate respondsToSelector:@selector(onComplete)]) {
//        [self.delegate onComplete];
//    }
   
    if (self.completeBlock) {
           self.completeBlock(self.imageUrl);
        }
       [self dismiss];
}

- (void)showTags:(NSArray *)tags
{
    
    if (tags.count) {
        NSString *string = @"";
        for (NSDictionary *dic in tags) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@ ",dic[@"tagName"]]];
        }
        _typeLabel.text = string;
        _typeTitle.hidden = NO;

    } else {
        _typeTitle.hidden = YES;
    }
    
    [self setCameraImage:nil];
    self.bar.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom = self.height;
    }];
}

- (void)show
{
    
    [self setCameraImage:nil];
    self.bar.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom = self.height;
    }];
}


- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)setCameraImage:(UIImage*)image{
    if (image) {
        [cameraBackImage bringSubviewToFront:self.cameraImageView];
    }else{
        [cameraBackImage sendSubviewToBack:self.cameraImageView];
    }
    cameraImage=image;
    self.cameraImageView.image = cameraImage;
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bar.bottom = self.height;
    
}

#pragma mark =============== addPhoto ===============
-(void)choosePhoto{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.viewController.view];
    
 
    
}
-(void)UploadImaged{
    
    NOSFormData * data=[[NOSFormData alloc]init];
    data.fileImage=self.photoImg;
    data.fileDir=@"apply_appraisal";

    JH_WEAK(self)
    [[NOSUpImageTool getInstance] upImageWithformData:data successBlock:^(RequestModel *respondObject) {
        JH_STRONG(self)
        [MBProgressHUD hideHUDForView:self.viewController.view animated:NO];
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        [self setCameraImage:self.photoImg];
        self.imageUrl = respondObject.data;
        // weakSelf.imgList=[NSMutableArray arrayWithCapacity:10];
       // [weakSelf.imgList addObject:respondObject.data];

    } failureBlock:^(RequestModel *respondObject) {
        JH_STRONG(self)
        //后续流程可能执行NOSAsyncRun,此处不能保证主线程
        if([NSThread isMainThread])
        {
            [MBProgressHUD hideHUDForView:self.viewController.view animated:NO];
            [SVProgressHUD showErrorWithStatus:respondObject.message];
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.viewController.view animated:NO];
                 [SVProgressHUD showErrorWithStatus:respondObject.message];
                 [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            });
        }
    }];
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
}
//相册、相机调用方法
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [HKClipperHelper shareManager].nav = self.viewController.navigationController;
        [HKClipperHelper shareManager].clippedImgSize = CGSizeMake(ScreenW, ScreenW*14./15.);
        [HKClipperHelper shareManager].clipperType = ClipperTypeImgMove;
        [HKClipperHelper shareManager].systemEditing = NO;
        [HKClipperHelper shareManager].isSystemType = YES;
        [[HKClipperHelper shareManager] photoWithSourceType:UIImagePickerControllerSourceTypeCamera];
        MJWeakSelf
               [HKClipperHelper shareManager].clippedImageHandler = ^(UIImage *image) {
                   weakSelf.photoImg=image;
                   [weakSelf UploadImaged];
                   
               };
    }
    
}
- (void)dealloc
{
   
    
}
@end
