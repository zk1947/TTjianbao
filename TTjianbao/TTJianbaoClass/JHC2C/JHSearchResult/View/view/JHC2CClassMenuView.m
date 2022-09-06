//
//  JHC2CClassMenuView.m
//  TTjianbao
//
//  Created by hao on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CClassMenuView.h"
#import "JHPublishCateModel.h"
#import "TTjianbaoHeader.h"

#import "JHC2CClassMenuTableViewCell.h"
#import "JHC2CClassMenuSubCollectionViewCell.h"


@interface JHC2CClassMenuView ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate,
UICollectionViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray <JHNewStoreTypeTableCellViewModel*>*dataArray;
@property (nonatomic, strong) JHNewStoreTypeTableCellViewModel *subStoreModel;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;
@property (nonatomic, assign) NSInteger selectFirstClassID;//选中的一级分类
@property (nonatomic, assign) NSInteger selectChildrenClassID;//选中的二级分类
@property (nonatomic, strong) UIButton *remakeBtn;//重置
@property (nonatomic, strong) UIView *tapView;
@property (nonatomic, assign) NSInteger lefTableViewRow;

@end

@implementation JHC2CClassMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self initSubviews];
    }
    return self;
}
#pragma mark - UI

- (void)initSubviews{
    [self layoutItems];
}


- (void)layoutItems{
    [self addSubview:self.leftTableView];
    [self addSubview:self.rightCollectionView];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.width.mas_offset(72);
        make.height.mas_offset(88);
    }];
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.left.equalTo(self.leftTableView.mas_right);
        make.height.equalTo(self.leftTableView);
    }];
    //重置按钮
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = UIColor.whiteColor;
    [self addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftTableView.mas_bottom);
        make.right.left.equalTo(self);
        make.height.mas_offset(44);
    }];
    [footerView addSubview:self.remakeBtn];
    [self.remakeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footerView).offset(-12);
        make.size.mas_offset(CGSizeMake(90, 30));
        make.centerY.equalTo(footerView);
    }];
    
    //点击背景是否隐藏
    [self addSubview:self.tapView];
    [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remakeBtn.mas_bottom).offset(7);
        make.left.right.bottom.equalTo(self);
        make.width.mas_offset(kScreenWidth);
    }];
    //点击背景是否隐藏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self.tapView addGestureRecognizer:tap];
    

}

#pragma mark - Action
///重置
- (void)clickRemakeBtnAction:(UIButton *)sender{
    self.selectChildrenClassID = -1;
    if (self.delegate && [self.delegate respondsToSelector:@selector(classViewDidSelect:selectAllClass:dismissView:)]) {
        [self.delegate classViewDidSelect:[JHNewStoreTypeTableCellViewModel new] selectAllClass:NO dismissView:NO];
    }
    //默认一级分类选中第一个
    self.lefTableViewRow = 0;
    self.subStoreModel = self.dataArray[0];
    if (self.dataArray.count > 0) {
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }

}
///分类收起
- (void)dismiss{
    if (self.delegate && [self.delegate respondsToSelector:@selector(classViewDidSelect:selectAllClass:dismissView:)]) {
        [self.delegate classViewDidSelect:[JHNewStoreTypeTableCellViewModel new] selectAllClass:NO dismissView:YES];
    }
}

- (void)setFromStatus:(NSInteger)fromStatus{
    _fromStatus = fromStatus;
}

- (void)setSubCateIds:(NSArray *)subCateIds{
    _subCateIds = subCateIds;
    [self loadData];
}

#pragma mark - LoadData
- (void)loadData {
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"ids"] = self.subCateIds.count > 0 ? self.subCateIds : @[];
    dicData[@"businessLineType"] = @"C2C";
    if (self.fromStatus == 1) {
        dicData[@"businessLineType"] = @"MALL";
    }
    [JHC2CSearchResultBusiness requestSearchCateListWithParams:dicData Completion:^(NSError * _Nullable error, NSArray<JHNewStoreTypeTableCellViewModel *> * _Nullable models) {
        if (!error) {
            if (models.count == 0) {
                [self.leftTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_offset(88+22);
                }];
            }
            else {
                if (models.count > 8) {
                    [self.leftTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(self).offset(-180-UI.bottomSafeAreaHeight + 22);
                    }];
                } else {
                    [self.leftTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_offset((models.count+1)*44 + 22);
                    }];
                }
            }
            [self.dataArray addObjectsFromArray:models];
            [self reloadData];
        }
    }];
    
}

- (void)reloadData{
    [self.leftTableView reloadData];
    //默认一级分类选中第一个
    self.subStoreModel = self.dataArray[0];
    if (self.dataArray.count > 0) {
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }

}
- (void)setSubStoreModel:(JHNewStoreTypeTableCellViewModel *)subStoreModel{
    _subStoreModel = subStoreModel;
    [self.rightCollectionView reloadData];

}


#pragma mark - Delegate
#pragma mark -- <UITableViewDelegate and UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHC2CClassMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHC2CClassMenuTableViewCell class]) forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"全部分类";
    }else{
        JHNewStoreTypeTableCellViewModel *viewModel = self.dataArray[indexPath.row];
        cell.viewModel = viewModel;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.lefTableViewRow = indexPath.row;
    self.subStoreModel = self.dataArray[indexPath.row];

}


#pragma mark -- UICollectionViewDatasource and delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.subStoreModel.children.count+1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHC2CClassMenuSubCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHC2CClassMenuSubCollectionViewCell class]) forIndexPath:indexPath];
   
    if (self.lefTableViewRow == 0) {//对应左侧列表的“全部分类”列
        collectionCell.titleLabel.text = @"";
    }else{
        if (indexPath.row == 0) {
            collectionCell.titleLabel.text = @"全部";
            //默认选中效果
            if ( self.subStoreModel.ID == self.selectFirstClassID) {
                collectionCell.titleLabel.textColor = HEXCOLOR(0xFFA319);
            } else {
                collectionCell.titleLabel.textColor = HEXCOLOR(0x666666);
            }
        }else{
            JHNewStoreTypeTableCellViewModel *childrenModel = self.subStoreModel.children[indexPath.row-1];
            collectionCell.viewModel = childrenModel;
            //默认选中效果
            if (childrenModel.ID == self.selectChildrenClassID) {
                collectionCell.titleLabel.textColor = HEXCOLOR(0xFFA319);
            } else {
                collectionCell.titleLabel.textColor = HEXCOLOR(0x666666);
            }
        }
    }
    
    return collectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
    JHNewStoreTypeTableCellViewModel *childrenModel;
    JHC2CClassMenuSubCollectionViewCell *cell = (JHC2CClassMenuSubCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        childrenModel = self.subStoreModel;
        //选中的一级分类
        self.selectFirstClassID = self.subStoreModel.ID;
        self.selectChildrenClassID = -1;
    }else{
        childrenModel = self.subStoreModel.children[indexPath.row-1];
        //选中的二级分类
        self.selectChildrenClassID = childrenModel.ID;
        self.selectFirstClassID = -1;
    }
    [cell setSelected:YES];
    [collectionView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(classViewDidSelect:selectAllClass:dismissView:)]) {
        [self.delegate classViewDidSelect:childrenModel selectAllClass:indexPath.row==0 ? YES : NO dismissView:NO];
    }

    
}

#pragma mark - Lazy
- (NSMutableArray<JHNewStoreTypeTableCellViewModel *> *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObject:[JHNewStoreTypeTableCellViewModel new]];
    }
    return _dataArray;
}
- (UITableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.rowHeight = 44;
        _leftTableView.backgroundColor = HEXCOLOR(0xF5F6FA);
        [_leftTableView registerClass:[JHC2CClassMenuTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHC2CClassMenuTableViewCell class])];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.showsHorizontalScrollIndicator = NO;
        _leftTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _leftTableView;
}

- (UICollectionView *)rightCollectionView{
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake((ScreenWidth-72)/4, 44);
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        _rightCollectionView.showsVerticalScrollIndicator = NO;
        _rightCollectionView.showsHorizontalScrollIndicator = NO;
        _rightCollectionView.backgroundColor = [UIColor whiteColor];

        [_rightCollectionView registerClass:[JHC2CClassMenuSubCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHC2CClassMenuSubCollectionViewCell class])];
        
    }
    return _rightCollectionView;
}

- (UIButton *)remakeBtn{
    if (!_remakeBtn) {
        _remakeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_remakeBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_remakeBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _remakeBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
        [_remakeBtn jh_cornerRadius:5.0 borderColor:HEXCOLOR(0xD8D8D8) borderWidth:0.5];
        [_remakeBtn addTarget:self action:@selector(clickRemakeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _remakeBtn;
}
- (UIView *)tapView{
    if (!_tapView) {
        _tapView = [[UIView alloc] init];
    }
    return _tapView;
}
@end
