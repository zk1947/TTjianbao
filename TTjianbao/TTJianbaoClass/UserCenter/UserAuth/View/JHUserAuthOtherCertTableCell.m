//
//  JHUserAuthOtherCertTableCell.m
//  TTjianbao
//
//  Created by lihui on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUserAuthOtherCertTableCell.h"
#import "JHUserAuthModel.h"
#import "JHPhotoBrowserManager.h"

#define itemWidth       ((ScreenW - 44 - 11)/2)
#define itemHeight      (100*itemWidth/160)
#define MAX_CERT_COUNT  10

@interface JHUserAuthOtherCertTableCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, assign) NSInteger contentSizeHeight;
@end

@implementation JHUserAuthOtherCertTableCell

- (NSMutableArray *)certImageArray {
    if (!_certImageArray) {
        _certImageArray = [NSMutableArray array];
    }
    return _certImageArray;
}

- (void)addSelfSubViews {
    
    self.contentView.backgroundColor = APP_BACKGROUND_COLOR;
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = kColorFFF;
    _bottomView.layer.cornerRadius = 8.f;
    _bottomView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bottomView];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"其他执照";
    tipLabel.font = [UIFont fontWithName:kFontMedium size:13.];
    tipLabel.textColor = kColor333;
    [_bottomView addSubview:tipLabel];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"注：有食品类商品销售的商家要上传食品经营许可证，有特殊品类商品销售的商家要上传特殊许可证（如猛犸象牙、珊瑚等非可售卖品类），照片需清晰可见，无水印，最多可上传10张";
    descLabel.font = [UIFont fontWithName:kFontNormal size:12.];
    descLabel.textColor = kColor999;
    descLabel.numberOfLines = 0;
    [_bottomView addSubview:descLabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((ScreenW - 20 - 11)/2, 100*(ScreenW - 20 - 11)/160);
    UICollectionView *ccView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    ccView.backgroundColor = kColorFFF;
    ccView.dataSource = self;
    ccView.delegate = self;
    ccView.scrollEnabled = NO;
    [_bottomView addSubview:ccView];
    self.collectionView = ccView;
    [ccView registerClass:[JHImageViewCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHImageViewCollectionCell class])];

    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 12, 0, 12));
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bottomView).offset(10);
    }];

    [ccView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView);
        make.bottom.equalTo(self.bottomView).offset(-10);
        make.height.equalTo(@(itemHeight));
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(10);
        make.right.equalTo(self.bottomView).offset(-10);
        make.top.equalTo(tipLabel.mas_bottom).offset(8);
        make.bottom.equalTo(ccView.mas_top).offset(-10);
    }];
    
    ///监听
    [ccView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        ///获取collectionView的contentSize并更新collectionView高度
        CGFloat contentSizeHeight = (NSInteger)self.collectionView.contentSize.height;
        if(_contentSizeHeight != contentSizeHeight) {
            _contentSizeHeight = contentSizeHeight;
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(contentSizeHeight));
            }];
            
            if (self.updateBlock) {
                self.updateBlock();
            }
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN(self.certImageArray.count + 1, 10);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHImageViewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHImageViewCollectionCell class]) forIndexPath:indexPath];
    if (indexPath.item < self.certImageArray.count) {
        cell.uploadImage = self.certImageArray[indexPath.item];
        cell.cellType = JHImageViewCollectionCellTypeImage;
        cell.hiddenDeleteBUtton = (self.authModel.authState == JHUserAuthStateChecking);
    }
    else {
        cell.cellType = JHImageViewCollectionCellTypeUpload;
    }
    
    @weakify(self);
    cell.deleteBlock = ^(id  _Nonnull img) {
        @strongify(self);
        if (self.authModel.authState != JHUserAuthStateChecking) {
            [self toDeleteSelectedPicture:img];
        }
    };
    return cell;
}

///选择后删除选中的照片
- (void)toDeleteSelectedPicture:(id)img {
    [self.certImageArray removeObject:img];
    [self.collectionView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(itemWidth, itemHeight);
}

- (BOOL)hasAuth {
    if ([self.authModel.idCardFrontImg isNotBlank] &&
        [self.authModel.idCardBackImg isNotBlank] &&
        [self.authModel.businessLicense isNotBlank]) {
        return YES;
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self hasAuth] && self.authModel.authState == JHUserAuthStateChecking) {
        JHImageViewCollectionCell *cell = (JHImageViewCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (indexPath.item < self.certImageArray.count) {
            id imgUrl = self.certImageArray[indexPath.item];
            if ([imgUrl isKindOfClass:[NSString class]]) {
                [JHPhotoBrowserManager showPhotoBrowserThumbImages:@[imgUrl] mediumImages:@[imgUrl] origImages:@[imgUrl] sources:@[cell.imgView] currentIndex:0 canPreviewOrigImage:NO showStyle:GKPhotoBrowserShowStyleZoom];
            }
        }
        return;
    }
    if (indexPath.item == self.certImageArray.count) {
        ///点击了点击上传的item 需要吊起选择图片
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
         [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self selectPictureFromAblum];
         }]];
         [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self selectPictureFromCamera];
         }]];
         
         [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         }]];
         [JHRootController.currentViewController presentViewController:alert animated:YES completion:nil];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

#pragma mark - //相册、相机调用方法
- (void)selectPictureFromCamera {
    NSLog(@"点击了拍照");
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [JHRootController.currentViewController dismissViewControllerAnimated:NO completion:nil];
        [JHRootController.currentViewController presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"模拟无效,请真机测试");
    }
}

- (void)selectPictureFromAblum
{
    NSLog(@"点击了从手机选择");
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.modalPresentationStyle  = UIModalPresentationCustom;
    [JHRootController.currentViewController dismissViewControllerAnimated:NO completion:nil];
    [JHRootController.currentViewController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]])
    {
        viewController.navigationController.navigationBar.translucent = NO;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self.certImageArray addObject:image];
    [self.collectionView reloadData];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
