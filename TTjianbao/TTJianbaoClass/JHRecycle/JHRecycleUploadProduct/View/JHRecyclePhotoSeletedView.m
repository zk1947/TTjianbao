//
//  JHRecyclePhotoSeletedView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePhotoSeletedView.h"
#import "JHRecyclePhotoInfoModel.h"
#import "TZImageManager.h"
#import "JHUploadManager.h"
#import "JHDefaultProcessView.h"

@interface JHRecyclePhotoSeletedView()
@property(nonatomic, strong) UIButton * bottomBtn;
@property(nonatomic, strong) UIButton * closeBtn;
@property(nonatomic, strong) UIImageView * bottomImageView;
@property(nonatomic, strong) UIImageView * playImageView;

@end

@implementation JHRecyclePhotoSeletedView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    [self addSubview:self.bottomImageView];
    [self addSubview:self.bottomBtn];
    [self addSubview:self.closeBtn];
}

- (void)layoutItems{
    [self.bottomImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.bottomBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.closeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.type == JHRecyclePhotoSeletedViewType_Product || self.type == JHRecyclePhotoSeletedViewType_B2CVideo) {
            make.centerX.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_top);
        }else if(self.type == JHRecyclePhotoSeletedViewType_Arbitration){
            make.top.equalTo(self);
            make.right.equalTo(self);
        }
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

#pragma mark -- <action>
- (void)tapActionWithSender:(UIButton*)sender{
    if (self.tapImageBlock) {
        self.tapImageBlock(self);
    }
}
- (void)deletePhotoButtonAction:(UIButton*)sender{
    if (self.deleteBlock) {
        self.deleteBlock(self);
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL inside = [super pointInside:point withEvent:event];
    if (!inside) {
        point = [self convertPoint:point toView:self.closeBtn];
        inside = [self.closeBtn pointInside:point withEvent:event];
    }
    return inside;
}
- (void)setModel:(JHRecyclePhotoInfoModel *)model{
    _model = model;
        ///视频
    if (model.mediaType == PHAssetMediaTypeVideo) {
        ///申请视频并上传
        [self requestVideoWithAsset:model.asset];
        [self insertSubview:self.playImageView belowSubview:self.bottomBtn];
        [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
        }];
    }else{
        ///图片
        [self requestImageWIthAsset:model.asset];
    }
}

- (void)setEditModel:(JHIssueGoodsEditImageItemModel *)editModel{
    _editModel = editModel;
    ///视频
    if (_editModel.type == 1) {
        ///申请视频并上传
        [self.bottomImageView jhSetImageWithURL:[NSURL URLWithString:_editModel.detailVideoCoverUrl] placeholder:JHImageNamed(@"newStore_default_avatar_placehold")];
        [self insertSubview:self.playImageView belowSubview:self.bottomBtn];
        [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
        }];
    }else{
        ///图片
        [self.bottomImageView jhSetImageWithURL:[NSURL URLWithString:_editModel.middleUrl] placeholder:JHImageNamed(@"newStore_default_avatar_placehold")];
    }
}

- (void)requestImageWIthAsset:(PHAsset*)asset{
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    CGSize size = CGSizeMake(1080, CGFLOAT_MAX);
//    CGSize size = PHImageManagerMaximumSize;
    [imageManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:nil
    resultHandler:^(UIImage *photo, NSDictionary *info) {
        BOOL
        downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        if (downloadFinined && asset.mediaType == PHAssetMediaTypeImage) {
            if (photo) {
                self.bottomImageView.image = photo;
                self.model.originalImage = photo;
            }
            if (self.uploadQueue) {
                @weakify(self);
                NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
                    @strongify(self);
                    [self upLoadImage];
                }];
                [self.uploadQueue addOperation:blockOp];
            }else{
                [self upLoadImage];
            }
        }
    }];
}
- (void)requestVideoWithAsset:(PHAsset*)asset{
    PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
        AVURLAsset *videoAsset = (AVURLAsset*)avasset;
        UIImage *videoImage = [self getLocationVideoPreViewImage:videoAsset];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (videoImage) {
                self.bottomImageView.image = videoImage;
                self.model.originalImage = videoImage;
            }
        });
        [[TZImageManager manager] startExportVideoWithVideoAsset:videoAsset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
            if (self.uploadQueue) {
                @weakify(self);
                NSBlockOperation *blockOp = [NSBlockOperation blockOperationWithBlock:^{
                    @strongify(self);
                    [self upLoadVideo:outputPath];
                }];
                [self.uploadQueue addOperation:blockOp];
            }else{
                [self upLoadVideo:outputPath];
            }

        } failure:^(NSString *errorMessage, NSError *error) {
            
        }];
    }];
}

- (UIImage*)getLocationVideoPreViewImage:(AVURLAsset *)asset{
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}
#pragma mark -- <uploadImage>

- (void)upLoadImage{
    NSString * aliUploadPath = @"client_publish/recovery/apply_arbitration";///仲裁图片地址
    if (self.type == JHRecyclePhotoSeletedViewType_Product) {
        aliUploadPath = @"client_publish/recovery/uploadProduct";///回收商品图片地址
    }else if (self.type == JHRecyclePhotoSeletedViewType_C2CProduct){
        aliUploadPath = @"client_publish/c2c/uploadProduct";///c2c商品图片地址
    }
    @weakify(self);
    UIImage *needUploadImage = self.model.originalImage;
    CGFloat sp = 0.7;
    NSData* imageData = UIImageJPEGRepresentation(needUploadImage, sp);
    while (imageData.length/1024.0 > 500) {
        sp -= 0.1;
        imageData = UIImageJPEGRepresentation(needUploadImage, sp);
    }
    needUploadImage = [UIImage imageWithData:imageData];
    [[JHUploadManager shareInstance] uploadSingleImage:needUploadImage filePath:aliUploadPath finishBlock:^(BOOL isFinished, NSString * _Nonnull imgKey){
        @strongify(self);
        if (isFinished){
            self.model.aliossUrl = [@"/" stringByAppendingString:imgKey];
        }else{
            [self upLoadImage];
        }
    }];
}

- (void)upLoadVideo:(NSString*)videoUrl{
    @weakify(self);
    if (self.type == JHRecyclePhotoSeletedViewType_C2CProduct) {
        [[JHUploadManager shareInstance] uploadC2CVideoByPath:videoUrl uploadProgress:^(CGFloat progress) {
            
        } finishBlock:^(BOOL isFinished, NSString * _Nonnull videoKey) {
            @strongify(self);
            if (isFinished) {
                self.model.aliossUrl = [@"/" stringByAppendingString:videoKey];
                self.model.videoLocalUrl = videoUrl;
            }else{
                [self upLoadVideo:videoUrl];
            }
        }];

    }else if(self.type == JHRecyclePhotoSeletedViewType_B2CVideo){
//        [[JHDefaultProcessView shareInstance] showProgressHUDSuperView:self];
        [[JHUploadManager shareInstance] uploadRecycleVideoByPath:videoUrl uploadProgress:^(CGFloat progress) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[JHDefaultProcessView shareInstance] showProgressHUDWithProgress:progress];
//            });
            
        } finishBlock:^(BOOL isFinished, NSString * _Nonnull videoKey) {
//            [[JHDefaultProcessView shareInstance] hideProgressHUD];
            @strongify(self);
            if (isFinished && videoKey.length) {
                self.model.aliossUrl = [@"/" stringByAppendingString:videoKey];
                self.model.videoLocalUrl = videoUrl;
            }else{
                [self upLoadVideo:videoUrl];
            }
        }];
    }
    else{
        [[JHUploadManager shareInstance] uploadRecycleVideoByPath:videoUrl uploadProgress:^(CGFloat progress) {
            
        } finishBlock:^(BOOL isFinished, NSString * _Nonnull videoKey) {
            @strongify(self);
            if (isFinished && videoKey.length) {
                self.model.aliossUrl = [@"/" stringByAppendingString:videoKey];
                self.model.videoLocalUrl = videoUrl;
            }else{
                [self upLoadVideo:videoUrl];
            }
        }];
    }
}



#pragma mark -- <set and get>

- (void)setType:(JHRecyclePhotoSeletedViewType)type{
    _type = type;
    NSString *imageName = @"icon_cover_close";
    if (type == JHRecyclePhotoSeletedViewType_Arbitration) {
        imageName = @"recycle_Arbitration_close";
    }else if(type == JHRecyclePhotoSeletedViewType_Product){
        imageName = @"icon_cover_close";
    }
    [self.closeBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self layoutItems];
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(deletePhotoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"icon_cover_close"] forState:UIControlStateNormal];
        _closeBtn = btn;
    }
    return _closeBtn;
}
- (UIButton *)bottomBtn{
    if (!_bottomBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(tapActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _bottomBtn = btn;
    }
    return _bottomBtn;
}

- (UIImageView *)bottomImageView{
    if (!_bottomImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.cornerRadius = 5;
        [imageView.layer setMasksToBounds:YES];
        _bottomImageView = imageView;
    }
    return _bottomImageView;
}

- (UIImageView *)playImageView{
    if (!_playImageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sq_video_icon_play"]];
        _playImageView = imageView;
    }
    return _playImageView;
}

- (void)dealloc{
    NSLog(@"dealloc");
}
@end
