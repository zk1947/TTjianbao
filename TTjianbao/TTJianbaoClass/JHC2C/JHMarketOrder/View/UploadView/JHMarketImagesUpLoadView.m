//
//  JHMarketImagesUpLoadView.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketImagesUpLoadView.h"
#import "JHMarketImageUploadCell.h"
#import "TZImagePickerController.h"
#import "JHUploadManager.h"
#import "SDWebImageDownloader.h"
#import "UIImage+JHWebImage.h"
#import "MBProgressHUD.h"
@interface JHMarketImagesUpLoadView()<UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate>
/** 布局*/
@property (nonatomic, strong) UICollectionView *collectionView;
/** 最大数量*/
@property (nonatomic, assign) NSInteger maxCount;
@end
@implementation JHMarketImagesUpLoadView

- (instancetype)initWithMaxPhotos:(NSInteger)maxCount {
    if (self == [super init]) {
        self.maxCount = maxCount;
        self.backgroundColor = HEXCOLOR(0xffffff);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self configUI];
        });
    }
    return self;
}

- (void)setImagesUrlArray:(NSArray *)imagesUrlArray {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _imagesUrlArray = imagesUrlArray;
        self.imagesArray = [NSMutableArray arrayWithArray:imagesUrlArray];
        [self.collectionView reloadData];
        [self resetLayout];
    });
}

- (void)configUI {
    [self addSubview:self.collectionView];
    
    CGFloat itemW = (self.width - 10) / 3;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.height.mas_equalTo(itemW);
    }];
}

- (void)uploadImagesWithImages:(NSArray *)images {
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    NSMutableArray *pictureUrlArray = [NSMutableArray array];
    __block int m = 0;
    //创建线程队列上传图片
    dispatch_queue_t uploadQueue = dispatch_queue_create("upload", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t signal = dispatch_semaphore_create(3);//线程并发数3(保持3张图片同时上传)
    for (UIImage * image in images) {
        dispatch_group_enter(group);
        dispatch_async(uploadQueue, ^{
            dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
            m++;
            NSString * aliUploadPath = @"client_publish/c2c/comment";///评价图片地址
            UIImage *needUploadImage = image;
            CGFloat sp = 0.7;
            NSData* imageData = UIImageJPEGRepresentation(needUploadImage, sp);
            while (imageData.length/1024.0 > 500) {
                sp -= 0.1;
                imageData = UIImageJPEGRepresentation(needUploadImage, sp);
            }
            needUploadImage = [UIImage imageWithData:imageData];
            [[JHUploadManager shareInstance] uploadSingleImage:needUploadImage filePath:aliUploadPath finishBlock:^(BOOL isFinished, NSString * _Nonnull imgKey){
                if (isFinished){
                    [pictureUrlArray addObject:[NSString stringWithFormat:ALIYUNCS_FILE_BASE_STRING(@"/%@"), imgKey]];
                    dispatch_semaphore_signal(signal);
                    dispatch_group_leave(group);
                    NSLog(@"第%d次上传成功",m);
                }
            }];
        });
    }
    
    @weakify(self);
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
        [self.imagesArray addObjectsFromArray:pictureUrlArray];
        [self.collectionView reloadData];
        [self resetLayout];
    });
}

/// 选取图片
- (void)selectImagesAction {
    TZImagePickerController *picker = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCount - self.imagesArray.count delegate:self];
//    picker.selectedAssets = self.selectAssetsArray;
    picker.allowTakePicture = YES; // 在内部显示拍照按钮
    picker.alwaysEnableDoneBtn = NO;
    picker.allowTakeVideo = NO;
    picker.allowPickingVideo = NO;
    picker.sortAscendingByModificationDate = NO;
    picker.allowPreview = YES;
    picker.allowPickingImage = YES;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    picker.allowPickingGif = YES;
    picker.allowPickingOriginalPhoto = YES;
    [self.viewController presentViewController:picker animated:YES completion:nil];
}

#pragma mark -- <TZImagePickerControllerDelegate>
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    [self uploadImagesWithImages:photos];
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)resetLayout {
    CGFloat height = 0;
    CGFloat itemW = (self.width - 10) / 3;
    if (self.imagesArray.count < self.maxCount) {
        height = (self.imagesArray.count / 3 + 1) * itemW;
    }else {
        height = ((self.maxCount - 1) / 3 + 1) * itemW;
    }
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesArray.count < self.maxCount ? self.imagesArray.count + 1 : self.maxCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHMarketImageUploadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHMarketImageUploadCell" forIndexPath:indexPath];
    if (indexPath.row == self.imagesArray.count) {
        cell.pictureImageView.hidden = YES;
        cell.cancelButton.hidden = YES;
        cell.plusView.hidden = NO;
    } else {
        cell.pictureImageView.hidden = NO;
        cell.cancelButton.hidden = NO;
        cell.plusView.hidden = YES;
    }
    cell.plusLabel.text = [NSString stringWithFormat:@"(最多%ld张)", (long)self.maxCount];
    [cell.pictureImageView jh_setImageWithUrl:self.imagesArray[indexPath.row]];
    @weakify(self);
    cell.cancelBlock = ^{
        @strongify(self);
        [self.imagesArray removeObjectAtIndex:indexPath.row];
        [self.collectionView reloadData];
        [self resetLayout];
    };
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.imagesArray.count) {
        [self selectImagesAction];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemW = (self.width - 10) / 3;
    return CGSizeMake(itemW, itemW);
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;// 设置item的大小
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 0);
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[JHMarketImageUploadCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMarketImageUploadCell class])];
    }
    return _collectionView;
}

- (NSMutableArray *)imagesArray {
    if (_imagesArray == nil) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}



@end
