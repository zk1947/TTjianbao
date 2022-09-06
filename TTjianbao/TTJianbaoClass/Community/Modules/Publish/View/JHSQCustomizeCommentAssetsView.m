//
//  JHSQCustomizeCommentAssetsView.m
//  TTjianbao
//
//  Created by user on 2020/11/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQCustomizeCommentAssetsView.h"
#import "JHBaseListView.h"
#import "JHImagePickerPublishManager.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>
#import "UIView+JHGradient.h"
#import <AVKit/AVKit.h>


@interface JHSQCustomizeCommentAssetsViewCell : JHBaseCollectionViewCell
@property (nonatomic,   weak) UIImageView              *photoView;
@property (nonatomic, strong) UIView                   *videoCoverView;
@property (nonatomic,   weak) UIImageView              *videoIconImageView;
@property (nonatomic,   weak) UIButton                 *deleteButton;
@property (nonatomic,   copy) dispatch_block_t          deleteActionBlock;
@end

@implementation JHSQCustomizeCommentAssetsViewCell

- (void)addSelfSubViews {
    _photoView = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_photoView jh_cornerRadius:8];
    _photoView.userInteractionEnabled = YES;
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _videoCoverView = [[UIView alloc] init];
    [_videoCoverView jh_cornerRadius:8.f];
    [self.contentView addSubview:_videoCoverView];
    [_videoCoverView jh_setGradientBackgroundWithColors:@[HEXCOLORA(0x000000,0.f), HEXCOLORA(0x000000,0.4f)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    _videoCoverView.hidden = YES;
    [_videoCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _videoIconImageView = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_videoIconImageView jh_cornerRadius:8];
    _videoIconImageView.image = JHImageNamed(@"icon_video_play");
    _videoIconImageView.userInteractionEnabled = YES;
    [_videoIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.height.mas_equalTo(24.f);
    }];
    _videoIconImageView.hidden = YES;
    
    _deleteButton = [UIButton jh_buttonWithImage:JHImageNamed(@"publish_close_icon") target:self action:@selector(closeAction) addToSuperView:self.videoCoverView];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.photoView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)closeAction {
    if(self.deleteActionBlock){
        self.deleteActionBlock();
    }
}

+ (CGSize)itemSize {
    return CGSizeMake((NSInteger)floorf(ScreenW - 10*4)/3, (NSInteger)floorf(ScreenW - 10*4)/3);
}

@end


@interface JHSQCustomizeCommentAssetsView ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@end

@implementation JHSQCustomizeCommentAssetsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}

- (void)addUI {
    UICollectionViewFlowLayout *layout           = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing               = 5;
    layout.minimumLineSpacing                    = 5;
    layout.itemSize                              = [JHSQCustomizeCommentAssetsViewCell itemSize];
    _collectionView                              = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
      [self addSubview:_collectionView];
    _collectionView.delegate                     = self;
    _collectionView.dataSource                   = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor              = UIColor.whiteColor;
    [_collectionView registerClass:[JHSQCustomizeCommentAssetsViewCell class] forCellWithReuseIdentifier:[JHSQCustomizeCommentAssetsViewCell cellIdentifier]];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    JHAlbumPickerModel *model = SAFE_OBJECTATINDEX(self.dataArray,0);
    if (model.isVideo) {
        return 1;
    }
    return MIN(MAX(1, self.dataArray.count + 1),9);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHSQCustomizeCommentAssetsViewCell *cell = [JHSQCustomizeCommentAssetsViewCell dequeueReusableCellWithCollectionView:collectionView indexPath:indexPath];
    JHAlbumPickerModel *model = SAFE_OBJECTATINDEX(self.dataArray,indexPath.item);
    cell.deleteButton.hidden = (indexPath.item >= self.dataArray.count);
    if (indexPath.item >= self.dataArray.count) {
        cell.photoView.image           = JHImageNamed(@"publish_add_photo");
        cell.videoIconImageView.hidden = YES;
        cell.videoCoverView.hidden     = YES;
        return cell;
    }
    if ([model.image isKindOfClass:[UIImage class]]) {
        cell.photoView.image = model.image;
    } else {
        [cell.photoView jh_setImageWithUrl:model.image];
    }
    
    cell.videoIconImageView.hidden = !model.isVideo;
    cell.videoCoverView.hidden     = cell.videoIconImageView.hidden;
    
    @weakify(self);
    cell.deleteActionBlock = ^{
        @strongify(self);
        if (self.dataArray && self.dataArray.count > indexPath.item) {
            if(self.deleteActionBlock) {
                self.deleteActionBlock(indexPath.item);
            }
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.dataArray.count > indexPath.item){
        [self previewPictureWithIndex:indexPath.row];
    } else {
        if(_addAlbumBlock) {
            _addAlbumBlock();
        }
    }
}

- (void)previewPictureWithIndex:(NSInteger)index {
    JHAlbumPickerModel *model = self.dataArray[index];
    if (model.isVideo) {
        NSURL *url = [NSURL fileURLWithPath:model.videoPath];
        AVPlayerViewController *ctrl = [AVPlayerViewController new];
        ctrl.player = [[AVPlayer alloc]initWithURL:url];
        [JHRootController presentViewController:ctrl animated:YES completion:nil];
        return;
    }
    NSMutableArray *photoList = [NSMutableArray new];
    BOOL needRecountIndex = NO;
    for (JHAlbumPickerModel *model in self.dataArray) {
        if (model.isVideo) {
            needRecountIndex = YES;
            continue;
        }
        GKPhoto *photo = [GKPhoto new];
        photo.image = model.image;
        [photoList addObject:photo];
    }
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photoList currentIndex:needRecountIndex?index-1:index];
    browser.isStatusBarShow = YES;
    browser.isScreenRotateDisabled = YES;
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    [browser showFromVC:JHRootController];
}


+ (CGSize)viewSize {
    return CGSizeMake(ScreenW, [JHSQCustomizeCommentAssetsViewCell itemSize].height * 3 + 10.f);
}


@end
