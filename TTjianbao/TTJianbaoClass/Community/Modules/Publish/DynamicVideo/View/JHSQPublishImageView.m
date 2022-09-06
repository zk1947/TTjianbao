//
//  JHSQPublishImageView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQPublishImageView.h"
#import "JHBaseListView.h"
#import "JHImagePickerPublishManager.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>
@interface JHSQPublishImageViewCell : JHBaseCollectionViewCell

@property (nonatomic, weak) UIImageView *photoView;

@property (nonatomic, weak) UIButton *deleteButton;

@property (nonatomic, copy) dispatch_block_t deleteActionBlock;

@end

@implementation JHSQPublishImageViewCell

-(void)addSelfSubViews
{
    _photoView = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_photoView jh_cornerRadius:8];
    _photoView.userInteractionEnabled = YES;
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _deleteButton = [UIButton jh_buttonWithImage:JHImageNamed(@"publish_close_icon") target:self action:@selector(closeAction) addToSuperView:self.photoView];
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.photoView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)closeAction
{
    if(_deleteActionBlock){
        _deleteActionBlock();
    }
}

+(CGSize)itemSize{
    return CGSizeMake((NSInteger)floorf(ScreenW - 60)/3, (NSInteger)floorf(ScreenW - 20)/3);
}
@end


@interface JHSQPublishImageView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, assign) int maxImage;
@end

@implementation JHSQPublishImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}

- (void)addUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    layout.itemSize = [JHSQPublishImageViewCell itemSize];
      _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
      [self addSubview:_collectionView];
      _collectionView.delegate = self;
      _collectionView.dataSource = self;
      _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = UIColor.whiteColor;
    [_collectionView registerClass:[JHSQPublishImageViewCell class] forCellWithReuseIdentifier:[JHSQPublishImageViewCell cellIdentifier]];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
      }];

}

- (void)setCustomizeNeedThis:(BOOL)customizeNeedThis {
    _customizeNeedThis = customizeNeedThis;
    if (_customizeNeedThis) {
        self.ViewHeight = [JHSQPublishImageViewCell itemSize].height;
    }
}

-(void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    if (self.customizeNeedThis) {
        self.ViewHeight = ([JHSQPublishImageViewCell itemSize].height) * ((dataArray.count)/3 + 1);
        if(self.maxImage <= dataArray.count){
            self.ViewHeight = ([JHSQPublishImageViewCell itemSize].height) * ((dataArray.count-1)/3 + 1);
        }
    }
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.customizeNeedThis) {
        return MIN(MAX(1, self.dataArray.count + 1),self.maxImage>0?self.maxImage:9);
    }
    if(IS_ARRAY(self.dataArray) && self.dataArray.count > 0) {
        return MIN(MAX(1, self.dataArray.count + 1),9);
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHSQPublishImageViewCell *cell = [JHSQPublishImageViewCell dequeueReusableCellWithCollectionView:collectionView indexPath:indexPath];
    JHAlbumPickerModel *model = SAFE_OBJECTATINDEX(self.dataArray,indexPath.item);
    cell.deleteButton.hidden = (indexPath.item >= self.dataArray.count);
    if(indexPath.item >= self.dataArray.count){
        cell.photoView.image = JHImageNamed(@"publish_add_photo");
        return cell;
    }
    if([model.image isKindOfClass:[UIImage class]]) {
        cell.photoView.image = model.image;
    }
    else{
        [cell.photoView jh_setImageWithUrl:model.image];
    }
    @weakify(self);
    cell.deleteActionBlock = ^{
        @strongify(self);
        if(self.dataArray && self.dataArray.count > indexPath.item)
        {
            if(self.deleteActionBlock)
            {
                self.deleteActionBlock(indexPath.item);
            }
        }
    };
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.dataArray.count > indexPath.item){
        [self previewPictureWithIndex:indexPath.row];
    }
    else
    {
        if(_addAlbumBlock)
        {
            _addAlbumBlock();
        }
    }
}

- (void)previewPictureWithIndex:(NSInteger)index {
    
    NSMutableArray *photoList = [NSMutableArray new];
    for (JHAlbumPickerModel *model in self.dataArray) {
        GKPhoto *photo = [GKPhoto new];
        if ([NSString has:model.image]) {
            photo.url = [NSURL URLWithString:model.image];
        } else {
            photo.image = model.image;
        }
        [photoList addObject:photo];
    }
        
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photoList currentIndex:index];
    browser.isStatusBarShow = YES;
    browser.isScreenRotateDisabled = YES;
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    [browser showFromVC:JHRootController];
}


+ (CGSize)viewSize
{
    return CGSizeMake(ScreenW, [JHSQPublishImageViewCell itemSize].height * 3 + 10);
}

- (void)hiddenAddImageBtn:(int)maxImage {
    self.maxImage = maxImage;
}
@end
