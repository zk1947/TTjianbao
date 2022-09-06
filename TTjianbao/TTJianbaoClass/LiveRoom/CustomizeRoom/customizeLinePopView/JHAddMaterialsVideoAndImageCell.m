//
//  JHAddMaterialsVideoAndImageCell.m
//  TTjianbao
//
//  Created by apple on 2020/11/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAddMaterialsVideoAndImageCell.h"
#import "JHUIFactory.h"
#import <Photos/Photos.h>
#import "JHAddImageCollectionViewCell.h"
#import "TZImagePickerController/TZImagePickerController.h"
#import "JHImagePickerPublishManager.h"

#define  imageLimitCount1   9

@interface JHAddMaterialsVideoAndImageCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    
}
@property(nonatomic,strong)NSMutableArray *selectedPhotos;
@property(nonatomic,strong)NSMutableArray *selectedAssets;
@property(nonatomic,strong) JHAlbumPickerModel *videoAlbum;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton * addBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger  imageCount;
@property (nonatomic, assign) NSInteger  videoCount;


@end

@implementation JHAddMaterialsVideoAndImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HEXCOLOR(0xF5F6FA);
        [self creatCellSubView];
    }
    return self;
}

- (void)creatCellSubView{
    self.backView = [[UIView alloc] init];
    self.backView.layer.cornerRadius = 8;
    self.backView.clipsToBounds = YES;
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(136);
            make.left.right.mas_equalTo(0);
    }];
    
    self.titleLabel = [JHUIFactory createLabelWithTitle:@"原料影像" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(15) textAlignment:NSTextAlignmentLeft];
    [self.backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(21);
    }];
    
//    self.addBtn = [JHUIFactory createThemeBtnWithTitle:@"添加" cornerRadius:0 target:self action:@selector(addVideoAndImage:)];
//    [self.backView addSubview:self.addBtn];
//    self.addBtn.titleLabel.font = JHFont(12);
//    [self.addBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
//    self.addBtn.backgroundColor = [UIColor clearColor];
//    [self.addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.backView).offset(10);
//        make.height.mas_equalTo(27);
//        make.width.mas_equalTo(40);
//        make.right.mas_equalTo(-10);
//    }];

    [self configCollectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.backView);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(0);
        make.bottom.mas_equalTo(self.backView).offset(0);
    }];
}

- (void)configCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(75, 75);
    layout.minimumInteritemSpacing = 10.f;
    layout.minimumLineSpacing = 10.f;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//    _collectionView.scrollEnabled = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(15, 10, 15, 10);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.backView addSubview:_collectionView];
    [_collectionView registerClass:[JHAddImageCollectionViewCell class] forCellWithReuseIdentifier:@"JHAddImageCollectionViewCell"];
}
#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_selectedPhotos.count >= imageLimitCount1) {
        return _selectedPhotos.count;
    }
    
    return 1 + _selectedPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHAddImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHAddImageCollectionViewCell" forIndexPath:indexPath];
    
    cell.deleteBtn.hidden = NO;
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    cell.videoImageView.hidden = YES;
    if (indexPath.item == _selectedPhotos.count) {
        cell.imageView.image = [UIImage imageNamed:@"materialsAddImage"];
        cell.deleteBtn.hidden = YES;
    } else {
        cell.imageView.image = ((JHAlbumPickerModel *)_selectedPhotos[indexPath.item]).image;
        cell.asset = _selectedAssets[indexPath.item];
        cell.deleteBtn.hidden = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == _selectedPhotos.count) {
        [self addVideoAndImage:1];
    }else{
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.item];
        imagePickerVc.maxImagesCount = imageLimitCount1;
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.autoSelectCurrentWhenDone = NO;
        imagePickerVc.allowPickingOriginalPhoto = YES;
        imagePickerVc.allowPickingMultipleVideo = NO;
        imagePickerVc.showSelectedIndex = YES;
//            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
       
        [JHRootController presentViewController:imagePickerVc animated:YES completion:nil];
    }
    
}

- (void)addVideoAndImage:(NSInteger)type{

    NSInteger imageCount = self.imageCount;
    [JHImagePickerPublishManager showImagePickerViewWithType:type maxImagesCount:imageLimitCount1-imageCount assetArray:self.selectedAssets viewController:JHRootController photoSelectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
        [self.selectedPhotos removeAllObjects];
        [self.selectedAssets removeAllObjects];
        [self.uploadImagearray removeAllObjects];
        [self.selectedPhotos addObjectsFromArray:dataArray];
        
        for (JHAlbumPickerModel *asset in dataArray) {
            [self.selectedAssets addObject:asset.asset];
            [self.uploadImagearray addObject:asset.image];
        }
        [self.collectionView reloadData];
        
    } videoSelectedBlock:^(NSArray<JHAlbumPickerModel *> * _Nonnull dataArray) {
      
    }];
}
- (void)deleteBtnClik:(UIButton *)sender{

    [self.selectedAssets removeObjectAtIndex:sender.tag];
    [self.uploadImagearray removeObjectAtIndex:sender.tag];
    [self.selectedPhotos removeObjectAtIndex:sender.tag];
    [self.collectionView reloadData];
    
}

- (NSMutableArray *)selectedAssets{
    if (!_selectedAssets) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

- (NSMutableArray *)selectedPhotos{
    if (!_selectedPhotos) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
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
