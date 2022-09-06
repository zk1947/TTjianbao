//
//  JHAuthenticateRecordView.m
//  TTjianbao
//
//  Created by Donto on 2020/7/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAuthenticateRecordView.h"
#import "JHAuthenticateRecordViewCell.h"

@interface JHAuthenticateRecordView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) CGSize itemSize;
//! 头像
@property (nonatomic, strong) UIImageView *profileImageView;
//! 昵称
@property (nonatomic, strong) UILabel *nameLabel;
//! 鉴定简介
@property (nonatomic, strong) UILabel *desLabel;
//! 关闭按钮
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JHAuthenticateRecordView

+ (instancetype)authenticateRecord {
    
    JHAuthenticateRecordView *rView = [JHAuthenticateRecordView new];
    rView.backgroundColor = UIColor.whiteColor;

    CGRect screenBounds = UIScreen.mainScreen.bounds;
    CGFloat itemWidth = (screenBounds.size.width-30)/3.0;
    rView.itemSize = CGSizeMake(itemWidth, itemWidth);
    rView.frame = CGRectMake(0, screenBounds.size.height, screenBounds.size.width, itemWidth*2.0+95);
    [rView addContents];

    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:rView.bounds byRoundingCorners: UIRectCornerTopLeft  | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    rView.layer.mask = maskLayer;
    return rView;
}


- (void)addContents {
    CGSize screenSize = UIScreen.mainScreen.bounds.size;

    UIImageView *profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    profileImageView.layer.cornerRadius = 25;
    profileImageView.layer.masksToBounds = YES;
    _profileImageView = profileImageView;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(profileImageView.right + 6, 17, screenSize.width - 100, 16)];

    nameLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor colorWithRGBHex:0X333333];
    _nameLabel = nameLabel;
    
    UILabel *desLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom + 5, screenSize.width - nameLabel.left - 10, 16)];

    desLabel.font = [UIFont systemFontOfSize:11];
    desLabel.textColor = [UIColor colorWithRGBHex:0X999999];
    _desLabel = desLabel;
    
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(screenSize.width - 36, 0, 36, 36)];
    [closeButton setImage:[UIImage imageNamed:@"jh_authenticate_record_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    _closeButton = closeButton;

    UICollectionViewFlowLayout *flowLayOut = [UICollectionViewFlowLayout new];
    flowLayOut.itemSize = self.itemSize;
    flowLayOut.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    flowLayOut.minimumInteritemSpacing = 5.0;
    flowLayOut.minimumLineSpacing = 5.0;

    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 70, screenSize.width, self.itemSize.height*2.0) collectionViewLayout:flowLayOut];
    collectionView.backgroundColor = UIColor.whiteColor;
    [collectionView registerClass:[JHAuthenticateRecordViewCell class] forCellWithReuseIdentifier:@"JHAuthenticateRecordViewCell"];
    collectionView.dataSource = self;
    _collectionView = collectionView;
    
    [self addSubview:profileImageView];
    [self addSubview:nameLabel];
    [self addSubview:desLabel];
    [self addSubview:closeButton];
    [self addSubview:collectionView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recordModel.reportList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHAuthenticateRecordViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHAuthenticateRecordViewCell"  forIndexPath:indexPath];
    cell.model = [self.recordModel.reportList objectAtIndex:indexPath.row];
    return cell;
}

- (void)closeAction {
    [self hiddenAlert];
}

- (void)showAlert {

    [self layoutSubviews];
    CGRect rect = self.frame;
    rect.origin.y = ScreenH - rect.size.height;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
    
}

- (void)hiddenAlert{
    CGRect rect = self.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
    self.recordModel = JHAnchorRecordModel.new;
}

- (void)setRecordModel:(JHAnchorRecordModel *)recordModel {
    _recordModel = recordModel;
    if (recordModel) {
        NSString *customerName = _recordModel.customerName?:@"";
        _profileImageView.backgroundColor = kColor999;
        [_profileImageView jhSetImageWithURL:[NSURL URLWithString:recordModel.customerImg] placeholder:nil];
        _nameLabel.text = customerName;
        
        NSString *text = [NSString stringWithFormat:@"上次鉴定时间：%@    累计鉴定次数：%ld次",recordModel.lastAppraiseDateFormat?:@"",recordModel.total];
        _desLabel.text = text;
        [self.collectionView reloadData];
    }
    
}
@end
