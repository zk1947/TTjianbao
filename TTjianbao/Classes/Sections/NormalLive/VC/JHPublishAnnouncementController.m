//
//  JHPublishAnnouncementController.m
//  TTjianbao
//
//  Created by Donto on 2020/7/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPublishAnnouncementController.h"
#import "JHAnnouncementDisplayView.h"
#import "JHAnnouncementTemplateController.h"
#import "TZImagePickerController.h"
#import "JHAiyunOSSManager.h"
#import "JHAnnouncementInfoModel.h"
#import <NSData+ImageContentType.h>
#import "JHGrowingIO.h"
#import "JHWebImage.h"

@interface JHPublishAnnouncementController ()

@property (nonatomic, strong) UIImageView *announcementImageView;
@property (nonatomic, strong) UIButton *addAnnouncementButton;
//!公告内容
@property (nonatomic, copy) NSString *content;
//! 公告图片地址
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) BOOL alreadyPublished;
@property (nonatomic, strong) UIButton *rightNavItem;

@end

@implementation JHPublishAnnouncementController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupToolBarWithTitle:@"直播间公告" backgroundColor:UIColor.whiteColor];
    self.title = @"直播间公告";
    UIButton *rightNavItem = [[UIButton alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width - 70, UI.statusBarHeight, 56, 44)];
    [rightNavItem setTitle:@"完成添加" forState:UIControlStateNormal];
    rightNavItem.enabled = NO;
    rightNavItem.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightNavItem setTitleColor:kColorTopicTitle forState:UIControlStateNormal];
    [rightNavItem setTitleColor:kColor999 forState:UIControlStateDisabled];
    [rightNavItem addTarget:self action:@selector(finishAddAction) forControlEvents:UIControlEventTouchUpInside];
    _rightNavItem = rightNavItem;
    [self.jhNavView addSubview:rightNavItem];
    
    _content = @"";
    _imageUrl = @"";
    [self initContentViews];
    [self fetchAnnocementInfo];
}

- (void)initContentViews {
    
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    UIButton *exampleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight + 18, 43, 25)];
    [exampleButton setTitle:@" 示例" forState:UIControlStateNormal];
    exampleButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [exampleButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [exampleButton addTarget:self action:@selector(exampleAction) forControlEvents:UIControlEventTouchUpInside];
    [exampleButton setImage:[UIImage imageNamed:@"jh_publish_Announcement_example"] forState:UIControlStateNormal];
    
    UIImageView *announcementImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/2.0-45, UI.statusAndNavBarHeight+32,90, 280)];
    announcementImageView.backgroundColor = kColorF5F6FA;
    _announcementImageView = announcementImageView;
    
    UIButton *addAnnouncementButton = [[UIButton alloc]initWithFrame:announcementImageView.frame];
    [addAnnouncementButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [addAnnouncementButton setImage:[UIImage imageNamed:@"jh_add_annoucenment"] forState:UIControlStateNormal];
    _addAnnouncementButton = addAnnouncementButton;
    
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, announcementImageView.bottom+26, screenWidth-90, 34)];
    tipsLabel.font = [UIFont systemFontOfSize:12];
    tipsLabel.textColor = [UIColor colorWithHexStr:@"999999"];
    tipsLabel.text = @"添加公告图片后，观众可在直播间看到\n图片要求：JPG、PNG、小于等于270*840px、小于1M";
    tipsLabel.numberOfLines = 0;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:exampleButton];
    [self.view addSubview:announcementImageView];
    [self.view addSubview:addAnnouncementButton];
    [self.view addSubview:tipsLabel];

}

- (void)fetchAnnocementInfo {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/channel/announce/detail") Parameters:@{@"channelId" : _channelId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
            DDLogInfo(@"fetchAnnouncementInfo====>%@",respondObject);
            JHAnnouncementInfoModel *aModel = [JHAnnouncementInfoModel mj_objectWithKeyValues:respondObject.data];
            if (aModel.imageUrl.length > 0) {
                _imageUrl = aModel.imageUrl;
                _alreadyPublished = YES;
                JH_WEAK(self)
                [JHWebImage loadImageWithURL:[NSURL URLWithString:aModel.imageUrl] options:SDWebImageRefreshCached completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
                    JH_STRONG(self)
                    [self configTemplateImage:image];
                }];
            }
            
        } failureBlock:^(RequestModel *respondObject) {
            
        }];
}

- (void)configTemplateImage:(UIImage *)templateImage {
    if (templateImage) {
        _rightNavItem.enabled = YES;
//        [_rightNavItem setTitle:@"已上架" forState:UIControlStateNormal];
        NSData *imageData = UIImagePNGRepresentation(templateImage);
        UIImage *image = [UIImage imageWithData:imageData scale:(templateImage.size.width/90.0)];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, image.size.width/2.0, 100, image.size.width/2.0) resizingMode:UIImageResizingModeStretch];
        _announcementImageView.image = image;
        _announcementImageView.height = image.size.height;
        [_addAnnouncementButton setImage:[UIImage new] forState:UIControlStateNormal];
        
    }
}

#pragma mark -- Actions

- (void)finishAddAction {
    
    NSMutableDictionary *parameters = @{}.mutableCopy;
    [parameters setObject:_channelId forKey:@"channelId"];
    [parameters setObject:_content forKey:@"content"];
    [parameters setObject:_imageUrl forKey:@"imageUrl"];

    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/channel/announce/save") Parameters:parameters requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [self.navigationController popViewControllerAnimated:YES];
        [self sa_method];
    } failureBlock:^(RequestModel *respondObject) {
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}

- (void)sa_method {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.channel.channelId forKey:@"channel_id"];
    [params setValue:self.channel.channelLocalId forKey:@"channel_local_id"];
    [params setValue:self.channel.title forKey:@"channel_name"];
    [JHAllStatistics jh_allStatisticsWithEventId:@"announcementAdd" params:params type:JHStatisticsTypeSensors];
}

- (void)exampleAction {
    
    JHAnnouncementDisplayView *displayView = [JHAnnouncementDisplayView announcementDisplay:JHAnnouncementDisplayExample];
    displayView.announcementImage = [UIImage imageNamed:@"jh_announcement_example"];
    
    UIView *coverView = [[UIView alloc]initWithFrame:UIScreen.mainScreen.bounds];
    coverView.backgroundColor = [UIColor colorWithRGB:0X000000 alpha:0.6];
    [coverView addSubview:displayView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeExample:)];
    [coverView addGestureRecognizer:tapGes];
    [UIApplication.sharedApplication.keyWindow addSubview:coverView];
}

- (void)addAction:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    if(_imageUrl.length == 0) {
        [alert addAction:[UIAlertAction actionWithTitle:@"上传图片" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pickAndUploadImage];
        }]];
        
        __weak typeof(self) weakSelf = self;
        [alert addAction:[UIAlertAction actionWithTitle:@"选择模板" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakSelf) self = weakSelf;
            
            JHAnnouncementTemplateController *atVC = [JHAnnouncementTemplateController new];
            [self.navigationController pushViewController:atVC animated:YES];
            atVC.selectedTemplateCompletion = ^(NSString * _Nonnull content, UIImage * _Nonnull annoucementImage) {
                self.content = content;
                [self uploadAnnoucementImage:@[annoucementImage]];
            };
        }]];
    }
    else {
        [alert addAction:[UIAlertAction actionWithTitle:@"删除" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteAnnoucement];
        }]];
    }
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)closeExample:(UITapGestureRecognizer *)ges {
    [ges.view removeFromSuperview];
    [JHGrowingIO trackEventId:JHChannelLocalldNoticeCloseClick variables:@{@"channelLocalId":_channelId ? : @""}];
}

- (void)deleteAnnoucement {
    if (_alreadyPublished) {
        [SVProgressHUD show];
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/channel/announce/delete") Parameters:@{@"channelId":_channelId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
            _alreadyPublished = NO;
            [_addAnnouncementButton setImage:[UIImage imageNamed:@"jh_add_annoucenment"] forState:UIControlStateNormal];
            _announcementImageView.image = nil;
            _imageUrl = @"";
            _rightNavItem.enabled = NO;
//            [_rightNavItem setTitle:@"上架" forState:UIControlStateNormal];
            _announcementImageView.backgroundColor = kColorF5F6FA;
            _announcementImageView.height = 280;
            [SVProgressHUD dismiss];
        } failureBlock:^(RequestModel *respondObject) {
            
            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
            [SVProgressHUD dismiss];

        }];
    }
    else {
        _announcementImageView.image = nil;
        [_addAnnouncementButton setImage:[UIImage imageNamed:@"jh_add_annoucenment"] forState:UIControlStateNormal];
        _imageUrl = @"";
        _rightNavItem.enabled = NO;
//        [_rightNavItem setTitle:@"上架" forState:UIControlStateNormal];
        _announcementImageView.backgroundColor = kColorF5F6FA;
        _announcementImageView.height = 280;

    }
    
    
}

- (void)pickAndUploadImage {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    imagePickerVc.allowCameraLocation = NO;
    @weakify(self);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self);
        
        PHAsset *asset = assets.firstObject;
        if ([[asset valueForKey:@"filename"] hasSuffix:@"PNG"] || [[asset valueForKey:@"filename"] hasSuffix:@"JPG"]) {
            [self uploadAnnoucementImage:photos];

        }
        else {
            [self.view makeToast:@"图片要求：JPG、PNG、小于270*840px、小于1M" duration:1.0 position:CSToastPositionCenter];
        }
        
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];

}

- (void)uploadAnnoucementImage:(NSArray<UIImage *> *)images {
    
    CGFloat mLength = 1024*1024;
    UIImage *annoucementImage = images.firstObject;
    NSData * imageData = UIImagePNGRepresentation(annoucementImage);
    CGFloat length = [imageData length] / mLength;
    
    if (annoucementImage.size.width > 270 || annoucementImage.size.height >840 || length > 1) {
        [self.view makeToast:@"图片要求：JPG、PNG、小于270*840px、小于1M" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    NSString *const aliUploadPath = @"client_publish/resale_on_shelf";
    [SVProgressHUD show];
    [[JHAiyunOSSManager shareInstance] uopladTemplateImage:images returnPath:aliUploadPath finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
        [SVProgressHUD dismiss];
        UIImage *image = images.firstObject;
        _announcementImageView.image = image;
        _announcementImageView.height = image.size.height*_announcementImageView.frame.size.width/image.size.width;
        _imageUrl = imgKeys.firstObject;
        _rightNavItem.enabled = YES;
//        [_rightNavItem setTitle:@"上架" forState:UIControlStateNormal];
        [self.addAnnouncementButton setImage:UIImage.new forState:UIControlStateNormal];
    }];
}

@end
