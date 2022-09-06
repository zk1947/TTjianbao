//
//  JHPhotoBrowserManager.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPhotoBrowserManager.h"
#import "YDCategoryKit/YDCategoryKit.h"
#import "UIView+JHGradient.h"
#import "NSObject+JHCdURLFileSize.h"
#import <SDWebImage/SDWebImage.h>

@interface JHPhotoTmpModel : NSObject

@property (nonatomic, copy) NSString *originUrl;

@property (nonatomic, copy) NSString *originSize;

@end

@implementation JHPhotoTmpModel

@end

@interface JHPhotoBrowserManager ()<GKPhotoBrowserDelegate>
@property (nonatomic, weak) GKPhotoBrowser *browser;
///查看原图按钮
@property (nonatomic, weak) UIButton *originBtn;
///下载按钮
@property (nonatomic, weak) UIButton *downloadBtn;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, weak) UILabel *pageLabel;

///原图 图片信息
@property (nonatomic, strong) NSMutableArray <JHPhotoTmpModel *>*originImagesInfo;
@property (nonatomic, assign) NSInteger currentIndex;
/// 隐藏下载
@property (nonatomic, assign) BOOL isHideDownload;
@end

@implementation JHPhotoBrowserManager
//查看大图
+ (void)showPhotoBrowserImages:(NSArray<NSString *> *)images
                       sources:(NSArray<UIImageView *> *__nullable)sources
                  currentIndex:(NSInteger)index
{
    NSMutableArray *photoList = [NSMutableArray new];
    [images enumerateObjectsUsingBlock:^(NSString * _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
        GKPhoto *photo = [GKPhoto new];
        photo.url = [NSURL URLWithString:url];
        photo.sourceImageView = sources[index]; //用同一个source
        [photoList addObject:photo];
    }];
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photoList currentIndex:index];
    browser.isStatusBarShow = YES; //开始时不隐藏状态栏，不然会有页面跳动问题
    browser.isScreenRotateDisabled = YES; //禁止横屏监测
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    [browser showFromVC:[JHRootController currentViewController]];
}

+ (void)showPhotoBrowserThumbImages:(NSArray<NSString *> *)images
                         origImages:(NSArray<NSString *> *)origImages
                            sources:(NSArray<UIImageView *> *__nullable)sources
                       currentIndex:(NSInteger)currenIndex
                canPreviewOrigImage:(BOOL)canPreviewOrigImage
                          showStyle:(GKPhotoBrowserShowStyle)showStyle
{
    [[JHPhotoBrowserManager alloc] browseOriginImage:images originImage:origImages imageSource:sources selectIndex:currenIndex canPreviewOrigImage:canPreviewOrigImage showStyle:showStyle];
}
+ (void)showPhotoBrowserThumbImages:(NSArray<NSString *> *)images
                         origImages:(NSArray<NSString *> *)origImages
                            sources:(NSArray<UIImageView *> *__nullable)sources
                       currentIndex:(NSInteger)currenIndex
                canPreviewOrigImage:(BOOL)canPreviewOrigImage
                          showStyle:(GKPhotoBrowserShowStyle)showStyle
                       hideDownload: (BOOL) hideDownload
{
    [[JHPhotoBrowserManager alloc] browseOriginImage:images originImage:origImages imageSource:sources selectIndex:currenIndex canPreviewOrigImage:canPreviewOrigImage showStyle:showStyle hideDownload : hideDownload];
}
+ (void)showPhotoBrowserThumbImages:(NSArray<NSString *> *)images
                       mediumImages:(NSArray<NSString *>*)mediumImages
                         origImages:(NSArray<NSString *> *)origImages
                            sources:(NSArray<UIImageView *> *__nullable)sources
                       currentIndex:(NSInteger)currenIndex
                canPreviewOrigImage:(BOOL)canPreviewOrigImage
                          showStyle:(GKPhotoBrowserShowStyle)showStyle
{
    [[JHPhotoBrowserManager alloc] browseOriginImage:images mediumImages:mediumImages originImage:origImages imageSource:sources selectIndex:currenIndex canPreviewOrigImage:canPreviewOrigImage showStyle:showStyle hideDownload:false];
}
+ (void)showPhotoBrowserThumbImages:(NSArray<NSString *> *)images
                       mediumImages:(NSArray<NSString *>*)mediumImages
                         origImages:(NSArray<NSString *> *)origImages
                            sources:(NSArray<UIImageView *> *__nullable)sources
                       currentIndex:(NSInteger)currenIndex
                canPreviewOrigImage:(BOOL)canPreviewOrigImage
                          showStyle:(GKPhotoBrowserShowStyle)showStyle
                       hideDownload: (BOOL) hideDownload
{
    [[JHPhotoBrowserManager alloc] browseOriginImage:images mediumImages:mediumImages originImage:origImages imageSource:sources selectIndex:currenIndex canPreviewOrigImage:canPreviewOrigImage showStyle:showStyle hideDownload:hideDownload];
}
- (void)browseOriginImage:(NSArray<NSString *>*)thumbImages
              originImage:(NSArray<NSString *>*)originImages
              imageSource:(NSArray<UIImageView *> *__nullable)imageSource
              selectIndex:(NSInteger)selectIndex
      canPreviewOrigImage:(BOOL)canPreviewOrigImage
                showStyle:(GKPhotoBrowserShowStyle)showStyle
{
    [self browseOriginImage:thumbImages mediumImages:nil originImage:originImages imageSource:imageSource selectIndex:selectIndex canPreviewOrigImage:canPreviewOrigImage showStyle:showStyle hideDownload:false];
}
- (void)browseOriginImage:(NSArray<NSString *>*)thumbImages
              originImage:(NSArray<NSString *>*)originImages
              imageSource:(NSArray<UIImageView *> *__nullable)imageSource
              selectIndex:(NSInteger)selectIndex
      canPreviewOrigImage:(BOOL)canPreviewOrigImage
                showStyle:(GKPhotoBrowserShowStyle)showStyle
             hideDownload: (BOOL) hideDownload
{
    [self browseOriginImage:thumbImages mediumImages:nil originImage:originImages imageSource:imageSource selectIndex:selectIndex canPreviewOrigImage:canPreviewOrigImage showStyle:showStyle hideDownload:hideDownload];
}
- (void)browseOriginImage:(NSArray<NSString *>*)thumbImages
             mediumImages:(NSArray<NSString *>*)mediumImages
              originImage:(NSArray<NSString *>*)originImages
              imageSource:(NSArray<UIImageView *> *__nullable)imageSource
              selectIndex:(NSInteger)selectIndex
      canPreviewOrigImage:(BOOL)canPreviewOrigImage
                showStyle:(GKPhotoBrowserShowStyle)showStyle
             hideDownload: (BOOL) hideDownload
{
    
    if(IS_ARRAY(originImages)) {
        for (NSString *url in originImages) {
            JHPhotoTmpModel *m = [JHPhotoTmpModel new];
            m.originUrl = url;
            [self.originImagesInfo addObject:m];
        }
    }
    _currentIndex = selectIndex;
        
    NSMutableArray *photos = [NSMutableArray new];
    for (int idx = 0; idx < thumbImages.count; idx ++) {
        GKPhoto *photo = [GKPhoto new];
        photo.sourceImageView = imageSource[idx]; //用同一个source
        if(mediumImages)
        {
            UIImage *image = [self imageWithUrl:thumbImages[idx]];
            if(image)
            {
                photo.placeholderImage = image;
            }
            photo.url = [NSURL URLWithString:mediumImages[idx]];
        }
        else
        {
            photo.url = [NSURL URLWithString:thumbImages[idx]];
        }
        
        photo.originUrl = [NSURL URLWithString:originImages[idx]];
        [photos addObject:photo];
    }
            
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:selectIndex];
    browser.showStyle = showStyle;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    browser.loadStyle = GKPhotoBrowserLoadStyleCustom;
    browser.originLoadStyle = GKPhotoBrowserLoadStyleCustom;
    browser.delegate = self;
    self.browser = browser;
    
    [self createTopView];
    self.isHideDownload = hideDownload;
    [self createBottomViewCanPreviewOrigImage:canPreviewOrigImage];
            
    _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)selectIndex+1, (long)thumbImages.count];
    [browser setupCoverViews:@[_topView,_bottomView] layoutBlock:^(GKPhotoBrowser * _Nonnull photoBrowser, CGRect superFrame) {
        [self setCoverFrame:superFrame];
    }];
    [browser showFromVC:[JHRootController currentViewController]];
}
- (UIImage*)imageWithUrl:(NSString *)url
{
    NSString* strUrl = url;

    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:strUrl]];

    SDImageCache* cache = [SDImageCache sharedImageCache];

    //此方法会先从memory中取。

    return [cache imageFromDiskCacheForKey:key];
}
    
- (void)setCoverFrame:(CGRect)superFrame {
    self.topView.frame = CGRectMake(0, 0, superFrame.size.width, UI.topSafeAreaHeight+82+40);
    [self.topView jh_setGradientBackgroundWithColors:@[HEXCOLORA(0x000000, .6f),HEXCOLORA(0x000000, 0)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    self.bottomView.frame = CGRectMake(0, ScreenH - (UI.bottomSafeAreaHeight+82+34), superFrame.size.width, UI.bottomSafeAreaHeight + 82+34);
    [self.bottomView jh_setGradientBackgroundWithColors:@[HEXCOLORA(0x000000, 0),HEXCOLORA(0x000000, 0.6f)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    self.pageLabel.frame = CGRectMake(0, 50, superFrame.size.width, 20);
    self.originBtn.frame = CGRectMake(15, _bottomView.height-UI.bottomSafeAreaHeight-84, 128, 32);
    self.downloadBtn.frame = CGRectMake(_bottomView.width - 62, _bottomView.height-UI.bottomSafeAreaHeight- 84, 32, 32);
}

- (void)createTopView {
    UIView *topView = [[UIView alloc] init];
    _topView = topView;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"0/0";
    label.font = [UIFont fontWithName:kFontNormal size:16];
    label.textColor = HEXCOLOR(0xffffff);
    label.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:label];
    _pageLabel = label;
}

- (void)createBottomViewCanPreviewOrigImage:(BOOL)canPreviewOrigImage{
    UIView *bottomView = [[UIView alloc] init];
    _bottomView = bottomView;
    
    if(canPreviewOrigImage) {
        UIButton *browseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        browseBtn.backgroundColor = HEXCOLORA(0x6B6B6B, .2f);
        [browseBtn setTitle:@"查看原图(0KB)" forState:UIControlStateNormal];
        [browseBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        browseBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        browseBtn.layer.cornerRadius = 18.f;
        browseBtn.layer.masksToBounds = YES;
        browseBtn.layer.borderWidth = 1.f;
        browseBtn.layer.borderColor = HEXCOLORA(0xffffff, .5f).CGColor;
        [browseBtn addTarget:self action:@selector(originImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:browseBtn];
        _originBtn = browseBtn;
        browseBtn.hidden = YES;
    }
    if (self.isHideDownload == true) { return; }
    UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadBtn setImage:[UIImage imageNamed:@"icon_pre_download"] forState:UIControlStateNormal];
    [downloadBtn setImage:[UIImage imageNamed:@"icon_pre_download"] forState:UIControlStateHighlighted];
    [downloadBtn addTarget:self action:@selector(downloadImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:downloadBtn];
    _downloadBtn = downloadBtn;
}

///查看原图
- (void)originImageAction:(id)sender {
    [self.browser loadCurrentPhotoImage];
}

///下载图片
- (void)downloadImageAction:(id)sender {
    GKPhoto *photo = self.browser.curPhotoView.photo;
    NSURL *imageUrl = photo.originFinished ? photo.originUrl : photo.url;
    [self toSaveImage:imageUrl];
}

///保存图片
- (void)toSaveImage:(NSURL *)url {
    if (!url) {
        return;
    }
    
    __block UIImage *img;
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
    [[SDImageCache sharedImageCache] diskImageExistsWithKey:key completion:^(BOOL isInCache) {
        if (isInCache) {
            img =  [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url.absoluteString];
        }
        else {
            //从网络下载图片
            NSData *data = [NSData dataWithContentsOfURL:url];
            img = [UIImage imageWithData:data];
        }
        
        if (img == nil) {
            [UITipView showTipStr:@"保存失败"];
        }else {
            // 保存图片到相册中
            UIImageWriteToSavedPhotosAlbum(img,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
        }
    }];
}

//保存图片完成之后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    // Was there an error?
    if (error != NULL) {
        [UITipView showTipStr:@"保存失败"];
    }
    else {  // No errors
        [UITipView showTipStr:@"保存成功"];
    }
}

#pragma mark - GKPhotoBrowserDelegate

- (void)photoBrowser:(GKPhotoBrowser *)browser loadImageAtIndex:(NSInteger)index progress:(float)progress isOriginImage:(BOOL)isOriginImage {
    
    if (isOriginImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *text = [NSString stringWithFormat:@"%.f%%", progress * 100];
            [self.originBtn setTitle:text forState:UIControlStateNormal];
            if (progress == 1.0) {
                [self.originBtn setTitle:@"已完成" forState:UIControlStateNormal];
                self.originBtn.hidden = YES;
            }
        });
    }
}

// 滚动到一半时索引改变
- (void)photoBrowser:(GKPhotoBrowser *)browser didChangedIndex:(NSInteger)index {
    _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)index+1, (long)self.originImagesInfo.count];
}
- (void)photoBrowser:(GKPhotoBrowser *)browser didSelectAtIndex:(NSInteger)index {
    GKPhoto *photo = browser.curPhotoView.photo;

    if (photo.originFinished) {
        self.originBtn.hidden = YES;
    }else {
    
        if(self.originImagesInfo.count > index)
        {
            JHPhotoTmpModel *m = self.originImagesInfo[index];
            if(m.originSize) {
                [self updateOriginTitle:m.originSize];
                self.originBtn.hidden = NO;
            }
            else {
                @weakify(m);
                [NSObject URLFileSizeWidthURL:m.originUrl fileSize:^(NSString * _Nonnull size) {
                    @strongify(m);
                    m.originSize = size;
                    [self updateOriginTitle:size];
                    self.originBtn.hidden = NO;
                }];
            }
        }
    }
}

- (void)updateOriginTitle:(NSString *)size {
    NSString *btnTitle = [NSString stringWithFormat:@"查看原图(%@)", size];
    [self.originBtn setTitle:btnTitle forState:UIControlStateNormal];
}

- (void)photoBrowser:(GKPhotoBrowser *)browser panBeginWithIndex:(NSInteger)index {
    self.topView.hidden = YES;
    self.bottomView.hidden = YES;
}

// 结束滑动时 disappear：是否消失
- (void)photoBrowser:(GKPhotoBrowser *)browser panEndedWithIndex:(NSInteger)index willDisappear:(BOOL)disappear {
    self.topView.hidden = disappear;
    self.bottomView.hidden = disappear;
}

- (NSMutableArray<JHPhotoTmpModel *> *)originImagesInfo {
    if(!_originImagesInfo) {
        _originImagesInfo = [NSMutableArray new];
    }
    return _originImagesInfo;
}
@end
