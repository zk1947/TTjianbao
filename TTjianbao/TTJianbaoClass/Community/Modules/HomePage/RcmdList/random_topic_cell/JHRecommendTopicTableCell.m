//
//  JHRecommendTopicTableCell.m
//  TTjianbao
//
//  Created by lihui on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecommendTopicTableCell.h"
#import "JHRecommendTopicCollectionCell.h"
#import "UIButton+ImageTitleSpacing.h"
#import "TTjianbao.h"
#import "UIView+JHGradient.h"

#define MAX_LINE  3

#define CELL_WIDTH  (ScreenW*278/375)

@interface JHRecommendTopicTableCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UILabel *titleLabel;
///换一批按钮
@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation JHRecommendTopicTableCell

- (void)dealloc {
    NSLog(@"%s被释放了🔥🔥🔥🔥", __func__);
}

+ (CGFloat)cellHeight {
    return 245.f;
}

- (void)setTopicArray:(NSArray<JHTopicInfo *> *)topicArray {
    if (!topicArray || topicArray.count == 0) {
        return;
    }
    _topicArray = topicArray;
    [_collectionView reloadData];
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
        label.text = @"热门话题";
        label;
    });
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeButton setTitle:@"换一批" forState:UIControlStateNormal];
    [changeButton setTitleColor:kColor999 forState:UIControlStateNormal];
    [changeButton setTitleColor:kColor999 forState:UIControlStateHighlighted];
    [changeButton setImage:[UIImage imageNamed:@"icon_sq_change"] forState:UIControlStateNormal];
    [changeButton setImage:[UIImage imageNamed:@"icon_sq_change"] forState:UIControlStateHighlighted];
    changeButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12.];
    [changeButton addTarget:self action:@selector(__handleChangeButtonActionEvent) forControlEvents:UIControlEventTouchUpInside];
    _changeButton = changeButton;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(CELL_WIDTH, 174.);
    UICollectionView *ccView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    ccView.backgroundColor = [UIColor clearColor];
    ccView.showsHorizontalScrollIndicator = NO;
    
    ccView.delegate = self;
    ccView.dataSource = self;
    [self.contentView addSubview:ccView];
    _collectionView = ccView;
    ///注册cell
    [_collectionView registerClass:[JHRecommendTopicCollectionCell class] forCellWithReuseIdentifier:kJHRecommendTopicCollectionCellIdentifer];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = kColorF5F6FA;
    
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_changeButton];
    [self.contentView addSubview:_collectionView];
    [self.contentView addSubview:_bottomLine];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [_changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.titleLabel);
    }];

    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(10);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.bottomLine.mas_top).offset(-10);
    }];
    
    UIView *gradient = [[UIView alloc] init];
    [self.contentView addSubview:gradient];
    [gradient mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.collectionView);
        make.width.mas_equalTo(46);
    }];
    [gradient layoutIfNeeded];
    [gradient jh_setGradientBackgroundWithColors:@[HEXCOLORA(0xFFFFFF, 0), HEXCOLORA(0xFFFFFF, 1.f)] locations:@[@0, @1] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    ///设置换一换按钮图片和文字的位置
    [_changeButton layoutIfNeeded];
    [_changeButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
}

- (NSArray *)topicList:(NSInteger)row {
    NSInteger param = (row + 1);
    NSInteger number = (self.topicArray.count >= param*MAX_LINE)
    ? MAX_LINE : self.topicArray.count % MAX_LINE;
    return [self.topicArray subarrayWithRange:NSMakeRange(row*MAX_LINE, number)];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHRecommendTopicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kJHRecommendTopicCollectionCellIdentifer forIndexPath:indexPath];
    NSArray *arr = [self topicList:indexPath.item];
    cell.topicArray = arr;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger topicCount = self.topicArray.count;
    return topicCount / 3 + topicCount % 3;
    return 3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

///换一换点击事件
- (void)__handleChangeButtonActionEvent {
    self.collectionView.contentOffset = CGPointMake(0, 0);
    
    if (self.changeBlock) {
        self.changeBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
