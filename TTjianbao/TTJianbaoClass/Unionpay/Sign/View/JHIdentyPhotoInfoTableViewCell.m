//
//  JHIdentyPhotoInfoTableViewCell.m
//  TTjianbao
//
//  Created by lihui on 2020/4/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHIdentyPhotoInfoTableViewCell.h"
#import "JCCollectionViewWaterfallLayout.h"
#import "JHIdentyPhotoInfoHeader.h"
#import "JHIdentyPhotoInfoCollectionViewCell.h"
#import "JHUnionPayModel.h"

#import "TZImagePickerController.h"
#import "JHUnionPayManager.h"

#define kVerticalSpace 20
#define kHorizontalSpace 10
#define kLineSpace 10

@interface JHIdentyPhotoInfoTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger selectIndex;  ///选中的下标


@end

@implementation JHIdentyPhotoInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _selectIndex = 0;
        _clomnCount = 2;
        self.layer.cornerRadius = 4.f;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)setClomnCount:(NSInteger)clomnCount {
    _clomnCount = clomnCount;
    [_collectionView reloadData];
}

- (void)initViews {
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.minimumLineSpacing = kHorizontalSpace;
    flowlayout.minimumInteritemSpacing = kVerticalSpace;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.scrollEnabled = NO;
    [self.contentView addSubview:_collectionView];

    ///上传图片的header
    [_collectionView registerClass:[JHIdentyPhotoInfoHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kIdentyPhotoInfoHeaderIdentifer];

    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer"];

    ///上传图片的cell
    [_collectionView registerClass:[JHIdentyPhotoInfoCollectionViewCell class] forCellWithReuseIdentifier:kPhotoCollectionIdentifer];

    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark -
#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHIdentyPhotoInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCollectionIdentifer forIndexPath:indexPath];
    JHUnionPayUserPhotoModel *model = self.dataArray[indexPath.item];
    cell.photoModel = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_clomnCount == 2) {
        return CGSizeMake((self.contentView.width - kLineSpace*2-kVerticalSpace)/2, 103);
    }
    return CGSizeMake(self.contentView.width - kLineSpace*2, 130);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.width, 58);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        JHIdentyPhotoInfoHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kIdentyPhotoInfoHeaderIdentifer forIndexPath:indexPath];
        return header;
    }
    
    UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Footer" forIndexPath:indexPath];
    return footer;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _selectIndex = indexPath.item;
    [self addPhotos];
}

#pragma mark -
#pragma mark - 调用相册相关

- (void)addPhotos {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerView];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.navigationController.navigationBar.translucent = NO;
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = NO;
            picker.sourceType = sourceType;
            picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [[JHRootController currentViewController] presentViewController:picker animated:YES completion:nil];
        }else {
            NSLog(@"模拟器");
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil]];
    [[JHRootController currentViewController] presentViewController:alert animated:YES completion:nil];
}

#pragma mark UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (!image) {
        return;
    }
    @weakify(self);
    [[TZImageManager manager] savePhotoWithImage:image location:nil completion:^(PHAsset *asset, NSError *error){
        //已在主线程
        @strongify(self);
        if (!error) {
            JHUnionPayUserPhotoModel *model = self.dataArray[self.selectIndex];
            model.selectPhoto = image;
            [self displayPicInfo:model];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];

}

///从相册选择图片的方法
- (void)showImagePickerView {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.showSelectedIndex = YES;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowTakeVideo = NO;
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.showSelectBtn = YES;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    __weak TZImagePickerController* weakImagePickerVc = imagePickerVc;
    imagePickerVc.imagePickerControllerDidCancelHandle = ^{
        [weakImagePickerVc dismissViewControllerAnimated:YES completion:nil];
    };
    @weakify(self);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self);
        if (photos) {
            JHUnionPayUserPhotoModel *model = self.dataArray[self.selectIndex];
            model.selectPhoto = [photos firstObject];
            [self displayPicInfo:model];
        }
        [weakImagePickerVc dismissViewControllerAnimated:YES completion:nil];
    }];
    [[JHRootController currentViewController] presentViewController:imagePickerVc animated:YES completion:nil];
}

///获取选择的图片信息
- (void)displayPicInfo:(JHUnionPayUserPhotoModel *)model {
    [[JHUnionPayManager shareManager] configSelectPicByPicModel:model];
    NSIndexPath *itemPath = [NSIndexPath indexPathForItem:self.selectIndex inSection:0];
    [self.collectionView reloadItemsAtIndexPaths:@[itemPath]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
