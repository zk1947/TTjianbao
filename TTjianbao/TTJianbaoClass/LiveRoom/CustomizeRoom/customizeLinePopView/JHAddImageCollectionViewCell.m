//
//  JHAddImageCollectionViewCell.m
//  TTjianbao
//
//  Created by apple on 2020/11/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAddImageCollectionViewCell.h"
#import <Photos/Photos.h>
#import "TZImagePickerController/TZImagePickerController.h"

@implementation JHAddImageCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = HEXCOLOR(0xEEEEEE);
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 7;
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
        
        self.imageView.clipsToBounds = YES;
        
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.image = [UIImage tz_imageNamedFromMyBundle:@"MMVideoPreviewPlay"];
        _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _videoImageView.hidden = YES;
        [self.contentView addSubview:_videoImageView];
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"publish_close_icon"] forState:UIControlStateNormal];
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, -10);
        _deleteBtn.alpha = 0.6;
        [self.contentView addSubview:_deleteBtn];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    _deleteBtn.frame = CGRectMake(self.width - 36, 0, 36, 36);
    CGFloat width = self.width / 3.0;
    _videoImageView.frame = CGRectMake(width, width, width, width);
}

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    _videoImageView.hidden = asset.mediaType != PHAssetMediaTypeVideo;
}

- (void)setRow:(NSInteger)row {
    _row = row;
    _deleteBtn.tag = row;
}

- (UIView *)snapshotView {
    UIView *snapshotView = [[UIView alloc]init];
    
    UIView *cellSnapshotView = nil;
    
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [self snapshotViewAfterScreenUpdates:NO];
    } else {
        CGSize size = CGSizeMake(self.bounds.size.width + 20, self.bounds.size.height + 20);
        UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc]initWithImage:cellSnapshotImage];
    }
    
    snapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    
    [snapshotView addSubview:cellSnapshotView];
    return snapshotView;
}
@end
