//
//  JHRushPurChaseSectionHeader.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/9/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRushPurChaseSectionHeader.h"
#import "JHRushPurChaseButton.h"
#import "JHRushPurHeaderCell.h"

@interface JHRushPurChaseSectionHeader()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) JHStoreDetailCountdownView *countdownView;

@property(nonatomic, strong) UIView * leftSeleView;

@property(nonatomic, strong) JHRushPurChaseButton * leftBtn;

@property(nonatomic, strong) UICollectionView * collectionView;

@property(nonatomic, strong) UICollectionViewFlowLayout * layout;

/// title
@property(nonatomic, strong) UILabel * nameLbl;

@property(nonatomic, assign) NSInteger  seleRow;

@property(nonatomic, strong) NSTimer * timer;

@property(nonatomic, assign) NSInteger  second;

@end

@implementation JHRushPurChaseSectionHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 114.f)];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xF5F5F8);
        self.seleRow = NSIntegerMax;
        [self setItems];
        [self layoutItems];
        [self refreshPurChaseButtonStatusSele:YES];
    }
    return self;
}

- (void)setTimeSecond:(NSInteger)second{
    [self.timer invalidate];
    self.second = second;
    [self tiemrRefresh];
    @weakify(self);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^{
        @strongify(self);
        [self tiemrRefresh];
    } repeats:YES];
    [NSRunLoop.currentRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)setSeckillTimeList:(NSArray<JHRushPurChaseSeckillTimeModel *> *)seckillTimeList{
    _seckillTimeList = seckillTimeList;
    [self refershSelBtn];
    [self.collectionView reloadData];
}
- (void)setSeckillCountdownDesc:(NSString *)seckillCountdownDesc{
    _seckillCountdownDesc = seckillCountdownDesc;
    if (seckillCountdownDesc.length) {
        self.nameLbl.text = [seckillCountdownDesc stringByAppendingString:@":"];
    }
}

- (void)setSeckillCountdown:(NSInteger)seckillCountdown{
    _seckillCountdown = seckillCountdown/1000;
    [self setTimeSecond:_seckillCountdown];
}

- (void)tiemrRefresh{
    self.second -= 1;
    if (self.second >= 0) {
        self.countdownView.timeStamp = self.second;
        if (self.second == 0) {
            [self.timer invalidate];
            [NSNotificationCenter.defaultCenter postNotificationName:@"JHRushPurChaseViewController_RefershData" object:nil];
        }
    }
}

- (void)refershSelBtn{
    if (self.seckillTimeList.count) {
        JHRushPurChaseSeckillTimeModel * model = self.seckillTimeList[0];
        self.leftBtn.titleLbl.text = model.timeDesc;
        self.leftBtn.bottomLbl.text = model.statusDesc;
    }
}

- (void)setItems{
    [self addSubview:self.collectionView];
    [self addSubview:self.nameLbl];
    [self addSubview:self.countdownView];
    [self addSubview:self.leftSeleView];
    self.countdownView.timeStamp = 0;
}

- (void)layoutItems{
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0).offset(13);
        make.bottom.equalTo(@0).offset(-10);
    }];
    [self.countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLbl.mas_right).offset(8);
        make.centerY.equalTo(self.nameLbl);
    }];
    [self.leftSeleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@0);
        make.height.equalTo(@82.f);
        make.width.equalTo(@83.f);
    }];
}

#pragma mark -- <UITableViewDelegate and UITableViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.seckillTimeList.count - 1;
//    return 30;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.seleRow == indexPath.row) {return;}
    self.seleRow = indexPath.row;
    self.seletedIndex = indexPath.row + 1;
    [self refreshPurChaseButtonStatusSele:NO];
    [self.collectionView reloadData];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHRushPurHeaderCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(JHRushPurHeaderCell.class) forIndexPath:indexPath];
    JHRushPurChaseSeckillTimeModel * model = self.seckillTimeList[indexPath.row + 1];
    [cell refreshTitle:model.timeDesc andDesTitle:model.statusDesc];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.seleRow) {
        return CGSizeMake(64.f, 62.f);
    }else{
        return CGSizeMake(58.f, 56.f);
    }
}

- (void)leftPurChaseButtonAction:(UIButton*)sender{
    if (!sender.isSelected) {
        self.seletedIndex = 0;
        [self refreshPurChaseButtonStatusSele:YES];
    }
}

- (void)refreshPurChaseButtonStatusSele:(BOOL)sele{
    if (sele) {
        self.leftBtn.selected = YES;
        self.seleRow = NSIntegerMax;
        [self.collectionView reloadData];
        [self.leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(64.f, 62.f));
            make.centerY.equalTo(@0);
            make.left.equalTo(@0).offset(13);
        }];
    }else{
        self.leftBtn.selected = NO;
        [self.leftBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(58.f, 56.f));
            make.centerY.equalTo(@0);
            make.left.equalTo(@0).offset(14);
        }];

    }
}

#pragma mark -- <Set and get>

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 82.f) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HEXCOLOR(0xF5F5F8);
        [_collectionView  registerNib:[UINib nibWithNibName:NSStringFromClass([JHRushPurHeaderCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(JHRushPurHeaderCell.class)];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 83, 0, 13);
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UILabel *)nameLbl{
    if (!_nameLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(15);
        label.textColor = HEXCOLOR(0x333333);
        label.text = @"本场还剩:";
        _nameLbl = label;
    }
    return _nameLbl;
}

- (JHStoreDetailCountdownView *)countdownView {
    if (!_countdownView) {
        _countdownView = [[JHStoreDetailCountdownView alloc] initCountDownViewWithType:JHStoreDetailCountdownView_Type_MiaoSha];
    }
    return _countdownView;
}

- (UIView *)leftSeleView{
    if (!_leftSeleView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xF5F5F8);
        [view addSubview:self.leftBtn];
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(58.f, 56.f));
            make.centerY.equalTo(@0);
            make.left.equalTo(@0).offset(14);
        }];
        _leftSeleView = view;
    }
    return _leftSeleView;
}

- (JHRushPurChaseButton *)leftBtn{
    if (!_leftBtn) {
        JHRushPurChaseButton *btn = [JHRushPurChaseButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(leftPurChaseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn = btn;
    }
    return _leftBtn;
}
@end
