//
//  JHCustomizeChooseMoneyView.m
//  TTjianbao
//
//  Created by user on 2020/11/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeChooseMoneyView.h"
#import "JHCustomizeChooseFlowLayout.h"
#import "JHCustomizeChooseModel.h"

@interface JHCustomizeChooseMoneyCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *moneyLabel;
- (void)setViewModel:(id)viewModel;
@end

@implementation JHCustomizeChooseMoneyCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {    
    _moneyLabel           = [[UILabel alloc] init];
    _moneyLabel.textColor = HEXCOLOR(0x333333);
    _moneyLabel.font      = [UIFont fontWithName:kFontMedium size:12.f];
    [self.contentView addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setViewModel:(id)viewModel {
    JHCustomizeChooseFeesModel *model = [JHCustomizeChooseFeesModel cast:viewModel];
    NSString *name = [NSString stringWithFormat:@"%@",model.name];
    NSString *minPrice = [NSString stringWithFormat:@"%@",model.minPrice];
    NSString *maxPrice = [NSString stringWithFormat:@"%@",model.maxPrice];
    if (!isEmpty(name) && !isEmpty(minPrice) && !isEmpty(maxPrice)) {
        self.moneyLabel.text = [NSString stringWithFormat:@"%@：%@-%@",NONNULL_STR(name),NONNULL_STR(minPrice),NONNULL_STR(maxPrice)];
    } else {
        self.moneyLabel.text = @"";
    }
}

@end


@interface JHCustomizeChooseMoneyView ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *moneyCollectionView;
@property (nonatomic, strong) NSMutableArray   *dataSourceArray;
@property (nonatomic, strong) UIButton         *showAllBtn; /// 展开按钮
@end

@implementation JHCustomizeChooseMoneyView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.moneyCollectionView.scrollEnabled = NO;
    [self addSubview:self.moneyCollectionView];
    [self.moneyCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _showAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showAllBtn setTitle:@"展开" forState:UIControlStateNormal];
    [_showAllBtn setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateNormal];
    [_showAllBtn addTarget:self action:@selector(showButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _showAllBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
    _showAllBtn.selected = NO;
    _showAllBtn.hidden = YES;
    [self addSubview:_showAllBtn];
    [_showAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10.f);
        make.bottom.equalTo(self.mas_bottom);
        make.height.mas_equalTo(17.f);
    }];
}

- (UICollectionView *)moneyCollectionView {
    if (!_moneyCollectionView) {
        UICollectionViewFlowLayout *layout                  = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing                      = 10.f;
        layout.minimumLineSpacing                           = 10.f;
//        /// layout约束这边必须要用estimatedItemSize才能实现自适应,使用itemSzie无效
//        layout.estimatedItemSize                            = CGSizeMake(20.f, 17.f);
        layout.scrollDirection                              = UICollectionViewScrollDirectionVertical;
//        layout.arrangeAlignment                             = JHArrangeAlignment_Left;
        _moneyCollectionView                                = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _moneyCollectionView.showsVerticalScrollIndicator   = NO;
        _moneyCollectionView.backgroundColor                = HEXCOLOR(0xffffff);
        _moneyCollectionView.delegate                       = self;
        _moneyCollectionView.dataSource                     = self;
        _moneyCollectionView.showsHorizontalScrollIndicator = NO;
        _moneyCollectionView.contentInset                   = UIEdgeInsetsMake(0, 10.f, 0.f, 10.f);
        [_moneyCollectionView registerClass:[JHCustomizeChooseMoneyCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCustomizeChooseMoneyCollectionCell class])];
    }
    return _moneyCollectionView;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)showButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.showAllBtn setTitle:sender.selected?@"收起":@"展开" forState:UIControlStateNormal];
    NSInteger index = ceil(self.dataSourceArray.count / 2.f);
    CGFloat height = 17.f *index + (index -1)*10.f + 37.f;
    if (self.showAllActionBlock) {
        self.showAllActionBlock(sender.isSelected,height);
    }
}

#pragma mark - Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((ScreenW-40 - 16)/2, 17.f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHCustomizeChooseMoneyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCustomizeChooseMoneyCollectionCell class]) forIndexPath:indexPath];
    [cell setViewModel:self.dataSourceArray[indexPath.row]];
    return cell;
}

- (void)setViewModel:(id)viewModel {
    NSArray *arr = [NSArray cast:viewModel];
    [self.dataSourceArray removeAllObjects];
    if (arr && arr.count >0) {
        [self.dataSourceArray addObjectsFromArray:arr];
    }
    if (self.dataSourceArray.count >2) {
        self.showAllBtn.hidden = NO;
    } else {
        self.showAllBtn.hidden = YES;
    }
    [self.moneyCollectionView reloadData];
}

@end
