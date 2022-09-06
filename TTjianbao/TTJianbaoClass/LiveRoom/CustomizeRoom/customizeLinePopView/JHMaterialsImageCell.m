//
//  JHMaterialsImageCell.m
//  TTjianbao
//
//  Created by apple on 2020/11/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMaterialsImageCell.h"
#import "JHUIFactory.h"
#import "JHAddImageCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "JHPhotoBrowserManager.h"

@interface JHMaterialsImageCell ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)NSArray *imageArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation JHMaterialsImageCell

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
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(161);
    }];
    
    self.titleLabel = [JHUIFactory createLabelWithTitle:@"可定制标准示例" titleColor:HEXCOLOR(0x333333) font:JHMediumFont(15) textAlignment:NSTextAlignmentLeft];
    [self.backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(21);
    }];
    self.descLabel = [JHUIFactory createLabelWithTitle:@"请查看示例上传原料影像" titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
    [self.backView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(17);
            make.left.mas_equalTo(10);
    }];

    [self configCollectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.backView);
        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(0);
        make.bottom.mas_equalTo(self.backView).offset(0);
    }];
    
}
- (void)reloadCellData:(NSArray *)imageArray{
    self.imageArray = imageArray;
    [self.collectionView reloadData];
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
    
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHAddImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHAddImageCollectionViewCell" forIndexPath:indexPath];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.item]] placeholderImage:[UIImage imageNamed:@"cover_default_list"]];
    cell.deleteBtn.hidden = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell1 = [collectionView cellForItemAtIndexPath:indexPath];
    JHAddImageCollectionViewCell * cell = (JHAddImageCollectionViewCell *)cell1;
    [JHPhotoBrowserManager showPhotoBrowserThumbImages:self.imageArray mediumImages:self.imageArray origImages:self.imageArray sources:@[cell.imageView] currentIndex:indexPath.item canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleZoom];
}

- (void)setCellToShowSample{
    

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
