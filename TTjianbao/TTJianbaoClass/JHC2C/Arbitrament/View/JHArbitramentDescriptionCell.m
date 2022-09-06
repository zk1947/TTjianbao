//
//  JHArbitramentDescriptionCell.m
//  TTjianbao
//
//  Created by lihui on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHArbitramentDescriptionCell.h"
#import "JHArbitramentDescriptionImgCell.h"

#define kItemIconSize       CGSizeMake(80, 80)
#define kDefaultImgHeight   100.
#define kMaxImageCount      6

@interface JHArbitramentDescriptionCell () <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UILabel *starLabel;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation JHArbitramentDescriptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    ///标题
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = kColor333;
    titleLabel.font = [UIFont fontWithName:kFontNormal size:14.];
    titleLabel.text = @"补充描述和凭证";
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    UIView *grayView = [[UIView alloc] init];
    grayView.backgroundColor = HEXCOLOR(0xFAFAFA);
    grayView.layer.cornerRadius = 5.f;
    grayView.layer.masksToBounds = YES;
    [self.contentView addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    _contentTextView = [[UITextView alloc] init];
    _contentTextView.backgroundColor = HEXCOLOR(0xFAFAFA);
    _contentTextView.text = @"为更好解决您的问题，请描述具体的问题以及您的期望；凭证可上传，如收货时的商品图，聊天记录截图，快照单照片的等有效证据";
    _contentTextView.delegate = self;
    _contentTextView.textColor = kColor999;
    [grayView addSubview:_contentTextView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = kItemIconSize;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = HEXCOLOR(0xFAFAFA);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[JHArbitramentDescriptionImgCell class] forCellWithReuseIdentifier:NSStringFromClass([JHArbitramentDescriptionImgCell class])];
    [grayView addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayView).offset(10);
        make.right.equalTo(grayView).offset(-10);
        make.bottom.equalTo(grayView).offset(-10);
        make.height.mas_equalTo(kDefaultImgHeight);
    }];
    
    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayView).offset(10);
        make.right.equalTo(grayView).offset(-10);
        make.top.equalTo(grayView).offset(10);
        make.bottom.equalTo(self.collectionView.mas_top).offset(-10);
    }];
}

#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imageArray.count < kMaxImageCount) {
        return self.imageArray.count + 1;
    }
    return self.imageArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHArbitramentDescriptionImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHArbitramentDescriptionImgCell class]) forIndexPath:indexPath];
    if (indexPath.item < self.imageArray.count) {
        ///最后一个为添加图片的cell
        cell.imageSource = self.imageArray[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}


+ (CGFloat)cellHeight {
    return 224.f;
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
