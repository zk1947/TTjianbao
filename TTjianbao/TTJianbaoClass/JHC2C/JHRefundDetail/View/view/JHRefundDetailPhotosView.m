//
//  JHRefundDetailPhotosView.m
//  TTjianbao
//
//  Created by hao on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRefundDetailPhotosView.h"
#import "UITapImageView.h"

#define kPaddingLeft    (0.0)  //左右边距
#define kPhotoVerSpace  (10.0)     //图片纵向间距
#define kPhotoHorSpace  (10.0)   //图片横向间距
#define kPerLineCount  3   //每行显示X张图

#define MAX_IMAGE_COUNT  6


@interface JHRefundDetailPhotosView ()
@property (nonatomic, copy) void(^chooseBlock)(NSArray <UIImageView *>*sourceViews, NSInteger index);
@property (nonatomic, strong) NSMutableArray *photoViews;
@property (nonatomic, assign) CGFloat imageHeight;

@end

@implementation JHRefundDetailPhotosView

- (instancetype)initPhotosViewFrame:(CGRect)frame withImageHeight:(CGFloat)imageHeight clickPhotoBlock:(void(^)(NSArray *sourceViews, NSInteger index))clickPhotoBlock{
    self = [super initWithFrame:frame];
    if (self ) {
        _photoViews = [NSMutableArray new];
        _imageHeight = imageHeight;
        [self setupViews];
        if (clickPhotoBlock) {
            self.chooseBlock = ^(NSArray<UIImageView *> *sourceViews, NSInteger index) {
                clickPhotoBlock(sourceViews, index);
            };

        }
    }
    return self;
}

- (void)setupViews {
    CGFloat imgWH = _imageHeight;
    NSMutableArray *views = [NSMutableArray new];
    @weakify(self);
    
    for (NSInteger i = 0; i < MAX_IMAGE_COUNT; i++) {
        NSInteger columnIndex = i % kPerLineCount;
        NSInteger rowIndex = i / kPerLineCount;

        UITapImageView *imageView = [UITapImageView new];
        imageView.image = kDefaultCoverImage;
        imageView.top = rowIndex * (imgWH + kPhotoVerSpace);
        imageView.left = kPaddingLeft + columnIndex * (imgWH + kPhotoHorSpace);
        imageView.size = CGSizeMake(imgWH, imgWH);
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 8;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.exclusiveTouch = YES;
        [imageView addTapBlock:^(id  _Nonnull obj) {
            @strongify(self);
            [self didClickedImageAtIndex:i];
        }];
        [views addObject:imageView];
        [self addSubview:imageView];
    }
    
    _photoViews = [views mutableCopy];
}


- (void)didClickedImageAtIndex:(NSInteger)index {
    if (self.chooseBlock) {
        self.chooseBlock(_photoViews, index);
    }

}

- (void)setImages:(NSArray *)images {
    _images = images.mutableCopy;
    for (NSInteger i = images.count; i < _photoViews.count; i++) {
        UITapImageView *imageView = [_photoViews objectAtIndex:i];
        [imageView.layer cancelCurrentImageRequest];
        imageView.hidden = YES;
    }
    
    if (images.count == 0) {
        self.height = 0;
        return;
    }
    
    CGFloat imgWH = _imageHeight;
    [images enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger columnIndex = idx % kPerLineCount;
        NSInteger rowIndex = idx / kPerLineCount;
        UITapImageView *imageView = [_photoViews objectAtIndex:idx];
        imageView.hidden = NO;
        [imageView.layer removeAnimationForKey:@"contents"];
        
        imageView.top = rowIndex * (imgWH + kPhotoVerSpace);
        imageView.left = kPaddingLeft + columnIndex * (imgWH + kPhotoHorSpace);
        imageView.size = CGSizeMake(imgWH, imgWH);

        [imageView jh_setImageWithUrl:obj placeHolder:@"newStore_hoder_image"];
        if (idx == _photoViews.count - 1) {
            *stop = YES;
        }
    }];
    
}


@end
