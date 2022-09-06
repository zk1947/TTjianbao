//
//  JHRecommendPlateTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/11/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRecommendPlateTableCell.h"
#import "JHRecommendPlateCollectionCell.h"
#import "JHPlateListModel.h"
#import "TTjianbao.h"
#import "UIView+JHGradient.h"

#define MAX_LINE 3

@interface JHRecommendPlateTableCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UICollectionView *plateCollectionView;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation JHRecommendPlateTableCell

- (void)dealloc {
    NSLog(@"%s被释放了🔥🔥🔥🔥", __func__);
}

+ (CGFloat)cellHeight {
    return 290.f;
}

- (void)setPlateInfos:(NSArray<JHPlateListData *> *)plateInfos {
    _plateInfos = plateInfos;
    if (_plateInfos && _plateInfos.count > 0) {
        for (NSInteger i = 0; i< _plateInfos.count; i++) {
            JHPlateListData *m = _plateInfos[i];
            m.index = i + 1;
        }
        [_plateCollectionView reloadData];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    _titleLabel = ({
        UILabel *label = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:15.f] textColor:kColor333];
        label.text = @"来版块看更多有趣内容";
        label;
    });
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake((ScreenW - 122), 225.f);
    UICollectionView *ccView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    ccView.backgroundColor = [UIColor clearColor];
    ccView.showsHorizontalScrollIndicator = NO;
    
    ccView.delegate = self;
    ccView.dataSource = self;
    [self.contentView addSubview:ccView];
    _plateCollectionView = ccView;
    ///注册cell
    [_plateCollectionView registerClass:[JHRecommendPlateCollectionCell class] forCellWithReuseIdentifier:kRecommendPlateCollectionIdentifer];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = kColorF5F6FA;
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_plateCollectionView];
    [self.contentView addSubview:_bottomLine];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(10);
    }];
    
    [_plateCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.bottomLine.mas_top).offset(-10);
        make.left.right.equalTo(self.contentView);
    }];
    
    UIView *gradient = [[UIView alloc] init];
    [self.contentView addSubview:gradient];
    [gradient mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.plateCollectionView);
        make.width.mas_equalTo(46);
    }];
    [gradient layoutIfNeeded];
    [gradient jh_setGradientBackgroundWithColors:@[HEXCOLORA(0xFFFFFF, 0), HEXCOLORA(0xFFFFFF, 1.f)] locations:@[@0, @1] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
}

- (NSArray *)plateList:(NSInteger)row {
    NSInteger param = (row + 1);
    NSInteger number = (self.plateInfos.count >= param*MAX_LINE)
    ? MAX_LINE : self.plateInfos.count % MAX_LINE;
    return [self.plateInfos subarrayWithRange:NSMakeRange(row*MAX_LINE, number)];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHRecommendPlateCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecommendPlateCollectionIdentifer forIndexPath:indexPath];
    NSArray *arr = [self plateList:indexPath.item];
    cell.plateInfos = arr;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger plateCount = self.plateInfos.count;
    return plateCount/3 + plateCount%3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
