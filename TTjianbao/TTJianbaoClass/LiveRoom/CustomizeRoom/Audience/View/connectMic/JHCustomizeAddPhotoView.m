//
//  JHCustomizeAddPhotoView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/9/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeAddPhotoView.h"
#import "JHGrowingIO.h"
#import "TTjianbaoHeader.h"
#import "UIImage+JHColor.h"
#import "UIView+CornerRadius.h"
#import "JHApplyMicRecommendView.h"
#import "TZImagePickerController.h"
#import "JHAiyunOSSManager.h"

@interface JHCustomizeAddPhotoView (){
    UILabel* titleLabel;
}
@property (nonatomic, strong)  UIButton* sureBtn;
@property(nonatomic,copy) UILabel * countLabel;
@property(nonatomic,copy) UILabel * timeLabel;
@property(nonatomic,copy) UIView * bar;
@property (nonatomic, strong)  UIImageView *cameraImageView;
@property (nonatomic, strong)  NSString *imageUrl;
@end
@implementation JHCustomizeAddPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        _bar =  [[UIView alloc]init];
        _bar.backgroundColor= [CommHelp toUIColorByStr:@"#ffffff"];
        _bar.userInteractionEnabled = YES;
        _bar.layer.masksToBounds = YES;
        _bar.frame= CGRectMake(0, 0, ScreenW, 362);
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

        titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = kColor333;
        titleLabel.text=@"请按照下面示例图片的要求上传照片";
        titleLabel.font = [UIFont fontWithName:kFontMedium size:15.f];
        titleLabel.numberOfLines = 2;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [topView addSubview:titleLabel];

        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //  make.top.equalTo((_bar)).offset(15);
            make.center.equalTo(topView);
        }];

        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"new_appraisal_close"] forState:UIControlStateNormal ];
        closeButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:closeButton];


        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel);
            make.right.equalTo(topView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];

        UILabel *tipLabel = [UILabel jh_labelWithText:@"将原料完美的展现，以便定制师参考更好的帮您设计" font:11 textColor:RGB153153153 textAlignment:1 addToSuperView:_bar];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bar);
            make.height.mas_equalTo(20);
            make.top.equalTo(topView.mas_bottom).offset(8);
        }];
        
        self.cameraImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"customize_add_default_cover"]];
        self.cameraImageView.contentMode=UIViewContentModeScaleAspectFill;
        self.cameraImageView.clipsToBounds=YES;
        self.cameraImageView.userInteractionEnabled = YES;
        [self.cameraImageView yd_setCornerRadius:8.f corners:UIRectCornerAllCorners];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage)];
        [self.cameraImageView addGestureRecognizer:tap];
        [_bar addSubview:self.cameraImageView];
        
        [self.cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bar).offset(15);
            make.right.equalTo(_bar).offset(-15);
            make.top.equalTo(topView.mas_bottom).offset(36);
            make.height.offset(194);
        }];
        

        _sureBtn=[[UIButton alloc]init];
        _sureBtn.contentMode=UIViewContentModeScaleAspectFit;
        [_sureBtn setTitle:@"拍照上传" forState:UIControlStateNormal];
        [_sureBtn setTitle:@"申请连麦" forState:UIControlStateSelected];
        _sureBtn.titleLabel.font=[UIFont fontWithName:kFontMedium size:14];
        [_sureBtn setTitleColor:[CommHelp toUIColorByStr:@"#222222"] forState:UIControlStateNormal];
        UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(320, 44) radius:22];
        [_sureBtn setBackgroundImage:nor_image forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bar addSubview:_sureBtn];

         [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cameraImageView .mas_bottom).offset(20);
            make.centerX.equalTo(_bar);
          //  make.bottom.equalTo(_bar).offset(-20);
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
}
-(void)sureClick:(UIButton *)sender{
    
    if (!self.sureBtn.selected) {
        [self chooseImage];
        [JHGrowingIO trackEventId:JHTrackCustomizelive_lmdz_camshow_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
         return;
    }
    if (!self.imageUrl) {
        [self makeToast:@"请上传图片" duration:2 position:CSToastPositionCenter];
    }
    NSMutableDictionary *dic = [[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues] mutableCopy];
       [dic setObject:@"cam" forKey:@"sqlm"];
       [JHGrowingIO trackEventId:JHTrackCustomizelive_lmdz_sqlm_click variables:dic];
    
    if (self.completeBlock) {
        self.completeBlock(self.imageUrl);
     }
     [self hiddenAlert];
}
- (void)showAlert
{
    self.bar.top =  self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom =  self.height;
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
-(void)hiddenAlert{
   [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
-(void)chooseImage{
    
     
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
     imagePickerVc.alwaysEnableDoneBtn = YES;
      imagePickerVc.allowTakeVideo = NO;
      imagePickerVc.allowPickingVideo = NO;
      imagePickerVc.sortAscendingByModificationDate = NO;
      imagePickerVc.allowPreview = YES;
    
    
//       imagePickerVc.showSelectedIndex = YES;
//       imagePickerVc.allowTakePicture = NO;
//       imagePickerVc.allowTakeVideo = NO;
//       imagePickerVc.showPhotoCannotSelectLayer = YES;
//       imagePickerVc.allowPickingOriginalPhoto = NO;
//       imagePickerVc.showSelectBtn = YES;
//       imagePickerVc.allowPickingImage = YES;
    
      imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
      imagePickerVc.showPhotoCannotSelectLayer = YES;
    @weakify(self);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
         @strongify(self);
        [self uploadImage:photos];
    }];
    
    [self.viewController presentViewController:imagePickerVc animated:YES completion:nil];
    
    
}
- (void)uploadImage:(NSArray<UIImage *> *)images {
    
    NSString *const aliUploadPath = @"client_publish/customize/pic";
    [SVProgressHUD show];
    [[JHAiyunOSSManager shareInstance] uopladImage:images returnPath:aliUploadPath finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
        [SVProgressHUD dismiss];
        if (isFinished) {
            self.cameraImageView.image = images.firstObject;
            self.imageUrl = imgKeys.firstObject;
            _sureBtn.selected = YES;
            titleLabel.text=@"照片确认后，定制师稍后会与您连麦";
        }
       
    }];
}

- (void)dealloc
{
    NSLog(@"cccccdealloc");
}
@end
