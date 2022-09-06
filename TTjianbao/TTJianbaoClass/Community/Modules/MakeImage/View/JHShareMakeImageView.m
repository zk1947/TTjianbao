//
//  JHShareMakeImageView.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHShareMakeImageView.h"
#import "JHSnapShotScreenView.h"
#import "JHGradientView.h"
#import <MBProgressHUD.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
@interface JHShareMakeImageView ()

@property (nonatomic, weak) UIButton *saveButton;

@property (nonatomic, weak) UIButton *weChatButton;

@property (nonatomic, weak) UIButton *timeLineButton;

@property (nonatomic, strong) JHPostDetailModel *model;

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UIImageView *loadingImageView;


@property (nonatomic, weak) MBProgressHUD *HUD;

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation JHShareMakeImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        JHGradientView *bgView = [[JHGradientView alloc] initWithFrame:self.bounds];
        [bgView setGradientColor:@[(__bridge id)RGB(126, 126, 126).CGColor, (__bridge id)RGB(81, 81, 81).CGColor] orientation:JHGradientOrientationVertical];
        [self addSubview:bgView];
        
        _scrollView = [UIScrollView jh_scrollViewWithContentSize:CGSizeZero showsScrollIndicator:NO scrollsToTop:NO bounces:YES pagingEnabled:NO addToSuperView:self];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        _imageView = [UIImageView jh_imageViewWithContentModel:UIViewContentModeScaleAspectFit addToSuperview:self.scrollView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView).insets(UIEdgeInsetsMake(40, 50, 185, 50));
        }];
        [self addSelfSubViews];
    }
    return self;
}

- (void)addSelfSubViews {
    
    CGFloat bottom = 12 + 145 + UI.bottomSafeAreaHeight;
    UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [whiteView jh_cornerRadius:12];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(12);
        make.height.mas_equalTo(bottom);
    }];
    
    _saveButton = [self creatButtonWithtitle:@"保存到相册" disabledImage:@"operation_make_image_unable" normalImage:@"operation_make_image" method:@selector(saveMethod)];
    
    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).offset(10);
        make.top.equalTo(whiteView).offset(10);
        make.size.mas_equalTo(CGSizeMake(65, 100));
    }];
    
    _weChatButton = [self creatButtonWithtitle:@"微信好友" disabledImage:@"operation_weixin_icon_unable" normalImage:@"operation_weixin_icon" method:@selector(wechatMethod)];
    
    [_weChatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).offset(80);
        make.top.width.height.equalTo(self.saveButton);
    }];
    
    _timeLineButton = [self creatButtonWithtitle:@"朋友圈" disabledImage:@"operation_quan_icon_unable" normalImage:@"operation_quan_icon" method:@selector(timeLineMethod)];
    
    [_timeLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).offset(150);
        make.top.width.height.equalTo(self.saveButton);
    }];
    
    UIView *lineView = [UIView jh_viewWithColor:RGB(245,246, 250) addToSuperview:whiteView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(whiteView);
        make.top.equalTo(whiteView).offset(100);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *button = [UIButton jh_buttonWithTitle:@"取消" fontSize:18 textColor:RGB102102102 target:self action:@selector(cancelMethod) addToSuperView:whiteView];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(lineView);
        make.height.mas_equalTo(45);
    }];

    _saveButton.enabled = NO;
    _weChatButton.enabled = NO;
    _timeLineButton.enabled = NO;
    
    _loadingImageView = [UIImageView jh_imageViewWithImage:@"operation_make_image_loading" addToSuperview:self];
    [_loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(275.f, 400.f));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(- 0.5 * bottom);
    }];
    
}

- (void)wechatMethod {
    [self shareWithType:YES];
}

- (void)timeLineMethod {
    [self shareWithType:NO];
}

///是否是聊天
- (void)shareWithType:(BOOL)isChat
{
    if(!self.imageView.image) {
        return;
    }
    //调用分享接口
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = UIImageJPEGRepresentation(self.imageView.image, 0.7);

    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = imageObject;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = isChat ? WXSceneSession : WXSceneTimeline;
    [WXApi sendReq:req completion:^(BOOL success) {
        NSLog(@"toShareImage complete!");
    }];
    [self cancelMethod];
}

- (UIButton *)creatButtonWithtitle:(NSString *)title
                     disabledImage:(NSString *)disabledImage
                       normalImage:(NSString *)normalImage
                            method:(SEL)method {
    UIButton *button = [UIButton jh_buttonWithTitle:title fontSize:12 textColor:RGB153153153 target:self action:method addToSuperView:self];
    
    [button setImage:JHImageNamed(normalImage) forState:UIControlStateNormal];
    [button setTitleColor:RGB515151 forState:UIControlStateNormal];
    
    [button setImage:JHImageNamed(disabledImage) forState:UIControlStateDisabled];
    [button setTitleColor:RGB153153153 forState:UIControlStateDisabled];
    
    [button setTitleEdgeInsets:(UIEdgeInsetsMake(15, -53, -15, 0))];
    [button setImageEdgeInsets:(UIEdgeInsetsMake(-20, 5, 20, -5))];
    
    return button;
}

- (void)saveMethod {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    [self savePhoto];
                }
            });
        }];
    } else if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        NSString *message = @"请在设置-隐私-照片选项中，允许访问你的手机相册";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法使用相册" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];

            }]];
       [JHRootController presentViewController:alert animated:YES completion:nil];
    } else {
        [self savePhoto];
    }
}

- (void)savePhoto {
    UIImageWriteToSavedPhotosAlbum(self.imageView.image,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    [self cancelMethod];
    [JHAllStatistics jh_allStatisticsWithEventId:@"sharemakepic_save_click" type:(JHStatisticsTypeSensors | JHStatisticsTypeGrowing)];
}

- (void)cancelMethod {
    [self removeFromSuperview];
}

- (void)setModel:(JHPostDetailModel *)model {
    _model = model;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JHSnapShotScreenView makeImageWithModel:_model complete:^(UIImage * _Nonnull image, UIView * _Nonnull currentView) {
            self.imageView.image = image;
            if(image) {
                CGFloat height = (image.size.height/image.size.width) * (ScreenW - 100.f);
                ///小图居中
                CGFloat space = 0;
                if(ScreenH - 226 > height) {
                    space = (ScreenH - 226 - height) / 2.f;
                }
                
                [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.scrollView).insets(UIEdgeInsetsMake(40 + space, 50, 185 + space, 50));
                    make.size.mas_equalTo(CGSizeMake(ScreenW - 100.f, height));
                }];
                
                [self.loadingImageView removeFromSuperview];
                [currentView removeFromSuperview];
                [self.HUD hideAnimated:YES];
                self.saveButton.enabled = YES;
                self.weChatButton.enabled = YES;
                self.timeLineButton.enabled = YES;
                
            }
            else {
                [self.HUD hideAnimated:YES];
                [self removeFromSuperview];
            }
        }];
    });
    [self.HUD showAnimated:YES];
    
}

///保存图片完成之后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
contextInfo:(void *)contextInfo {

    if (error != NULL) {
        JHTOAST(@"保存失败");
    }
    else {  // No errors
        JHTOAST(@"保存成功");
    }
}

- (MBProgressHUD *)HUD {
    if(!_HUD) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.loadingImageView animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.label.text = @"长图生成中…";
        [hud showAnimated:YES];
        _HUD = hud;
    }
    
    return _HUD;
}

+ (void)showWithModel:(JHPostDetailModel *)model {
    JHShareMakeImageView *makeImageView = [[JHShareMakeImageView alloc] initWithFrame:JHKeyWindow.bounds];
    makeImageView.model = model;
    [JHKeyWindow addSubview:makeImageView];
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"article_detail_sharemakepic_click" type:(JHStatisticsTypeSensors | JHStatisticsTypeGrowing)];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
