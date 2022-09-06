//
//  JHRecycleSquareHomeViewController.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleSquareHomeViewController.h"
#import "JHRecycleSquareHomeCell.h"
#import "JHRecycleUploadProductBusiness.h"
#import "JHRecycleMeAttentionViewController.h"
#import "JHRefreshGifHeader.h"
#import "JHRefreshNormalFooter.h"
#import "JHRecyclePriceController.h"
#import "JHRecycleDetailViewController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHRecycleSquareSelectMenuView.h"
#import "JHRecycleSquareSelectMenuModel.h"


static NSString *recycleSquareHomeTipsIsShowKey = @"recycleSquareHomeTipsIsShowKey";
@interface JHRecycleSquareHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView * collectionView;

@property(nonatomic, strong) NSMutableArray<JHRecycleSquareHomeListModel*> * resultList;

@property(nonatomic, strong) UIView * rightMenuView;

@property(nonatomic, strong) UIView * guideTipView;

@property(nonatomic, assign) NSInteger  pageNo;

@property(nonatomic, assign) BOOL  hasShowTips;

@property (nonatomic, strong) JHRecycleSquareSelectMenuView *selectMenuView;//筛选弹窗
@property (nonatomic, strong) JHRecycleSquareSelectMenuModel *selectMenuModel;
@property (nonatomic, copy) NSString *categoryId;//分类ID
@property (nonatomic, copy) NSString *highQualityId;//高货ID
@property (nonatomic, copy) NSString *sourceId;//来源ID
@property (nonatomic, strong) NSMutableArray *selectNameArray;//记录所选择内容
@property (nonatomic, assign) NSInteger index;//选择的index
@property (nonatomic, assign) NSInteger lastIndex;//上次选择的index
@property (nonatomic, strong) UIButton *selectButton;//最新点击的按钮

@end

@implementation JHRecycleSquareHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectNameArray = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
    [self setItems];
    [self layoutItems];
    [self isShowGuideTips];
    [self.collectionView.mj_header beginRefreshing];
    [self loadSelectMenuData];
    [self setupHeaderView];

}

- (void)setItems{
    self.pageNo = 1;
    self.title = @"回收广场";
    [self initRightButtonWithImageName:@"customize_desc_more_black" action:@selector(rightButtonActionWithSender:)];
    self.jhRightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 3, 0, -3);
    [self.view addSubview:self.collectionView];
}

- (void)layoutItems{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(@0);
        make.top.equalTo(self.jhNavView.mas_bottom).offset(44);
    }];
}
///头部筛选view
- (void)setupHeaderView{
    UIView *headerView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.view];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    for (int i = 0; i < 2; i ++) {
        UIView *lineView = [UIView jh_viewWithColor:HEXCOLOR(0xF2F2F2) addToSuperview:headerView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(i*43.5);
            make.left.right.equalTo(headerView);
            make.height.mas_equalTo(0.5);
        }];
    }
    NSArray *titleArray = @[@"分类",@"来源",@"是否高货"];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.textColor = HEXCOLOR(0x666666);
        [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(13);
        btn.tag = 100+i;
        [btn setImage:[UIImage imageNamed:@"recycle_square_down_icon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickSelectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.height.mas_equalTo(44);
            make.centerX.equalTo(headerView).offset(-ScreenW/4 + i*ScreenW/4);
        }];
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
    }
    
    [self.view addSubview:self.selectMenuView];
    [self.selectMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
}
///筛选
- (void)clickSelectBtnAction:(UIButton *)sender{
    self.index = sender.tag - 100;
    //按钮点击互斥
    static UIButton *lastBtn;
    if (lastBtn != sender) {
        sender.selected = YES;
        lastBtn.selected = NO;
        //记录最后一次点击
        self.lastIndex = lastBtn.tag - 100;
        //区分按钮选择后形态
        [self buttonSelected:sender];
        
        //判断上次筛选按钮是否选择了内容
        if ([self.selectNameArray[self.lastIndex] length] <= 0) {
            lastBtn.titleLabel.font = JHFont(13);
            [lastBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
            [lastBtn setImage:[UIImage imageNamed:@"recycle_square_down_icon"] forState:UIControlStateNormal];
        } else {
            lastBtn.titleLabel.font = JHBoldFont(13);
            [lastBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            [lastBtn setImage:[UIImage imageNamed:@"recycle_square_selected_down_icon"] forState:UIControlStateNormal];
        }

        lastBtn = sender;

    } else {//按钮重复点击
        sender.selected = !sender.selected;
        //判断筛选按钮是否选择了内容
        if ([self.selectNameArray[self.index] length] <= 0) {
            [self buttonSelected:sender];
        } else {
            sender.titleLabel.font = JHBoldFont(13);
            [sender setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            if (sender.selected) {
                [sender setImage:[UIImage imageNamed:@"recycle_square_up_icon"] forState:UIControlStateNormal];
                [self.selectMenuView show];
            } else {
                [sender setImage:[UIImage imageNamed:@"recycle_square_selected_down_icon"] forState:UIControlStateNormal];
                [self.selectMenuView dismiss];
            }
        }

    }
    self.selectButton = sender;

    //不同筛选数据赋值
    if (self.index == 0) {
        self.selectMenuView.selectListDataArray = self.selectMenuModel.categorys;
    }else if (self.index == 1){
        self.selectMenuView.selectListDataArray = self.selectMenuModel.sourceDicts;
    }else if (self.index == 2){
        self.selectMenuView.selectListDataArray = self.selectMenuModel.highQualityDicts;
    }
    //筛选后回调
    @weakify(self);
    self.selectMenuView.selectCompleteBlock = ^(NSInteger selectIndex, BOOL isDismiss) {
        @strongify(self);
        if (isDismiss) {//点击背景
            sender.selected = NO;
            if ([self.selectNameArray[self.index] length] <= 0) {
                [self buttonSelected:sender];
            } else {
                [sender setImage:[UIImage imageNamed:@"recycle_square_selected_down_icon"] forState:UIControlStateNormal];
                sender.titleLabel.font = JHBoldFont(13);
                [sender setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            }

        } else {
            //几个按钮筛选数据处理
            if (self.index == 0) {
                //遍历重置选中状态
                for (JHRecycleSquareSelectMenuListModel *listModel in self.selectMenuModel.categorys) {
                    listModel.selected = NO;
                }
                //记录选择状态
                self.selectMenuModel.categorys[selectIndex].selected = YES;
                //选中数据回调
                self.categoryId = self.selectMenuModel.categorys[selectIndex].code;
                [sender setTitle:self.selectMenuModel.categorys[selectIndex].name forState:UIControlStateNormal];
                //记录选择的内容数据
                [self.selectNameArray replaceObjectAtIndex:0 withObject:self.selectMenuModel.categorys[selectIndex].name];

            }else if (self.index == 1){
                for (JHRecycleSquareSelectMenuListModel *listModel in self.selectMenuModel.sourceDicts) {
                    listModel.selected = NO;
                }
                self.selectMenuModel.sourceDicts[selectIndex].selected = YES;
                self.sourceId = self.selectMenuModel.sourceDicts[selectIndex].code;
                [sender setTitle:self.selectMenuModel.sourceDicts[selectIndex].name forState:UIControlStateNormal];
                
                [self.selectNameArray replaceObjectAtIndex:1 withObject:self.selectMenuModel.sourceDicts[selectIndex].name];

            }else if (self.index == 2){
                for (JHRecycleSquareSelectMenuListModel *listModel in self.selectMenuModel.highQualityDicts) {
                    listModel.selected = NO;
                }
                self.selectMenuModel.highQualityDicts[selectIndex].selected = YES;
                self.highQualityId = self.selectMenuModel.highQualityDicts[selectIndex].code;
                [sender setTitle:self.selectMenuModel.highQualityDicts[selectIndex].name forState:UIControlStateNormal];
                
                [self.selectNameArray replaceObjectAtIndex:2 withObject:self.selectMenuModel.highQualityDicts[selectIndex].name];

            }
            //按钮形态改变
            sender.selected = NO;
            [sender setImage:[UIImage imageNamed:@"recycle_square_selected_down_icon"] forState:UIControlStateNormal];
            sender.titleLabel.font = JHBoldFont(13);
            [sender setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            [sender layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:4];
            
            //刷新数据
            [self.collectionView.mj_header beginRefreshing];

        }
        
    };

    
}

///选中按钮形态变化
- (void)buttonSelected:(UIButton *)sender{
    if (sender.selected) {
        [self.selectMenuView show];
        sender.titleLabel.font = JHBoldFont(13);
        [sender setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"recycle_square_up_icon"] forState:UIControlStateNormal];
    } else {
        [self.selectMenuView dismiss];
        sender.titleLabel.font = JHFont(13);
        [sender setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"recycle_square_down_icon"] forState:UIControlStateNormal];
    }
}

///点击其他区域弹窗收起
- (void)selectMenuViewDismiss{
    if (!self.selectMenuView.hidden) {
        [self.selectMenuView dismiss];
        self.selectButton.selected = NO;
        //判断筛选按钮是否选择了内容
        if ([self.selectNameArray[self.index] length] <= 0) {
            self.selectButton.titleLabel.font = JHFont(13);
            [self.selectButton setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
            [self.selectButton setImage:[UIImage imageNamed:@"recycle_square_down_icon"] forState:UIControlStateNormal];
        } else {
            self.selectButton.titleLabel.font = JHBoldFont(13);
            [self.selectButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            [self.selectButton setImage:[UIImage imageNamed:@"recycle_square_selected_down_icon"] forState:UIControlStateNormal];
        }
    }
}
- (void)rightButtonActionWithSender:(UIButton*)sender{
    //筛选弹窗收起
    [self selectMenuViewDismiss];
    
    if (self.hasShowTips) {
        [self.guideTipView removeFromSuperview];
        self.guideTipView = nil;
    }
    if (self.rightMenuView.superview) {
        [self removeMenuView:nil];
    }else{
        [self showMenuView];
    }
}

- (void)isShowGuideTips{
    ///是否展示
    if ([JHUserDefaults boolForKey:recycleSquareHomeTipsIsShowKey]) {
        [JHUserDefaults setBool:YES forKey:recycleSquareHomeTipsIsShowKey];
        self.hasShowTips = YES;
        [self.view addSubview:self.guideTipView];
        [self.guideTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0).offset(-15);
            make.size.mas_equalTo(CGSizeMake(260, 56));
            make.top.equalTo(self.jhNavView.mas_bottom).offset(-5);
        }];
    }
}
- (void)showMenuView{
    [self.view addSubview:self.rightMenuView];
    [self.rightMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.top.equalTo(self.jhNavView.mas_bottom);
    }];
}
- (void)removeMenuView:(UIGestureRecognizer*)sender{
    [self.rightMenuView removeFromSuperview];
}

//出价记录
- (void)topBtnActionSender:(UIButton*)sender{
//    出价记录的页面：
    JHRecyclePriceController *priceVc = [[JHRecyclePriceController alloc] init];
    [self.navigationController pushViewController:priceVc animated:YES];
    [self removeMenuView:nil];
}
//我的收藏
- (void)bottomBtnActionSender:(UIButton*)sender{
    JHRecycleMeAttentionViewController *VC = [JHRecycleMeAttentionViewController new];
    [self.navigationController pushViewController:VC animated:YES];
    [self removeMenuView:nil];
}

- (void)loadSelectMenuData{
    [JHRecycleUploadProductBusiness requestRecycleSquareSelectListWithParams:nil Completion:^(RequestModel *respondObject, NSError * _Nullable error) {
        if (!error) {
            self.selectMenuModel = [JHRecycleSquareSelectMenuModel mj_objectWithKeyValues:respondObject.data];
        }
    }];
}

- (void)refreshData{
    self.pageNo = 1;
    [self.collectionView.mj_footer resetNoMoreData];
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"pageNo"] = [NSNumber numberWithInteger:self.pageNo];
    par[@"pageSize"] = @20;
    par[@"imageType"] = @"s,m,b,o";
    par[@"categoryThirdId"] = self.categoryId;
    par[@"isHighQuality"] = self.highQualityId;
    par[@"source"] = self.sourceId;
    [JHRecycleUploadProductBusiness requestRecycleSquareHomeListWithParams:par Completion:^(NSError * _Nullable error, JHRecycleSquareHomeModel * _Nullable model) {
        [self.collectionView.mj_header endRefreshing];
        if (!error) {
            self.resultList = [NSMutableArray arrayWithArray:model.resultList];
            [self.collectionView jh_reloadDataWithEmputyView];
            if (!model.hasMore) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            self.pageNo += 1;
        }
    }];
}

- (void)addMoreData{
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"pageNo"] = [NSNumber numberWithInteger:self.pageNo];
    par[@"pageSize"] = @20;
    par[@"imageType"] = @"s,m,b,o";
    par[@"categoryThirdId"] = self.categoryId;
    par[@"isHighQuality"] = self.highQualityId;
    par[@"source"] = self.sourceId;
    [JHRecycleUploadProductBusiness requestRecycleSquareHomeListWithParams:par Completion:^(NSError * _Nullable error, JHRecycleSquareHomeModel * _Nullable model) {
        [self.collectionView.mj_footer endRefreshing];
        if (!error) {
            [self.resultList addObjectsFromArray:model.resultList];
            [self.collectionView jh_reloadDataWithEmputyView];
            if (!model.hasMore) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            self.pageNo += 1;
        }
    }];
}


#pragma mark -- <UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.resultList.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHRecycleSquareHomeListModel* listModel = self.resultList[indexPath.row];
    JHRecycleSquareHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(JHRecycleSquareHomeCell.class) forIndexPath:indexPath];
    if ([UI.recycleOrderIdSet containsObject:listModel.productId]) {
        [cell setHasRead];
    }
    [cell refreshWithHomeSquareModel:listModel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    JHRecycleSquareHomeCell *cell = (JHRecycleSquareHomeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setHasRead];
    JHRecycleSquareHomeListModel* listModel = self.resultList[indexPath.row];
    [UI.recycleOrderIdSet addObject:listModel.productId];
    JHRecycleDetailViewController *vc = [JHRecycleDetailViewController new];
    vc.identityType = 1;
    vc.productId = listModel.productId;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -- <set and get>
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 5;
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.itemSize = CGSizeMake((ScreenWidth-24-5)/2, (ScreenWidth-24-5)/2 + 77);
        flowLayout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HEXCOLOR(0xF5F5F8);
        [_collectionView registerClass:JHRecycleSquareHomeCell.class forCellWithReuseIdentifier:NSStringFromClass(JHRecycleSquareHomeCell.class)];
        @weakify(self);
        _collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self refreshData];
        }];
        _collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self addMoreData];
        }];

    }
    return _collectionView;
}

- (UIView *)rightMenuView{
    if (!_rightMenuView) {
        UIView* backView = [UIView new];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMenuView:)];
        [backView addGestureRecognizer:tap];
        UIView* menuView = [UIView new];
        [backView addSubview:menuView];
        [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0).offset(-5);
            make.right.equalTo(@0).offset(-15);
            make.size.mas_equalTo(CGSizeMake(72, 76));
        }];
        menuView.backgroundColor = HEXCOLORA(0x000000, 0.6);
        menuView.layer.cornerRadius = 2;
        
        UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topBtn.titleLabel.font = JHMediumFont(13);
        [topBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [menuView addSubview:topBtn];
        [topBtn addTarget:self action:@selector(topBtnActionSender:) forControlEvents:UIControlEventTouchUpInside];
        [topBtn setTitle:@"出价记录" forState:UIControlStateNormal];

        UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomBtn.titleLabel.font = JHMediumFont(13);
        [bottomBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [menuView addSubview:bottomBtn];
        [bottomBtn addTarget:self action:@selector(bottomBtnActionSender:) forControlEvents:UIControlEventTouchUpInside];
        [bottomBtn setTitle:@"我的收藏" forState:UIControlStateNormal];

        [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(@0);
            make.height.mas_equalTo(37);
        }];
        [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(@0);
            make.height.mas_equalTo(37);
        }];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = UIColor.whiteColor;
        [menuView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(36, 1));
        }];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_square_menu_arrow"]];
        [menuView addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(menuView.mas_top).offset(1);
            make.right.equalTo(menuView).offset(-6);
        }];

        _rightMenuView = backView;
    }
    return _rightMenuView;
}

- (UIView *)guideTipView{
    if (!_guideTipView) {
        UIView* backView = [UIView new];
        backView.backgroundColor = HEXCOLORA(0x000000, 0.6);
        backView.layer.cornerRadius = 2;
        UILabel *tipsLbl = [UILabel new];
        tipsLbl.font = JHFont(13);
        tipsLbl.numberOfLines = 0;
        tipsLbl.textColor = UIColor.whiteColor;
        NSString *baseStr = @"点击右上角“···”可查看您的出价记录及收藏记录哦！";
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:baseStr attributes:
                                             @{UIFontDescriptorNameAttribute : JHFont(13),
                                               NSForegroundColorAttributeName : UIColor.whiteColor}];
        [attStr setAttributes:@{UIFontDescriptorNameAttribute : JHFont(13),
                                NSForegroundColorAttributeName : UIColor.whiteColor} range:[baseStr rangeOfString:@"···"]];
        tipsLbl.attributedText = attStr;
        [backView addSubview:tipsLbl];
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_square_menu_arrow"]];
        [backView addSubview:arrow];
        [tipsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0).inset(10);
            make.top.bottom.equalTo(@0);
        }];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(backView.mas_top).offset(1);
            make.right.equalTo(backView).offset(-6);
        }];
        _guideTipView = backView;
    }
    return _guideTipView;
}

- (JHRecycleSquareSelectMenuView *)selectMenuView{
    if (!_selectMenuView) {
        _selectMenuView = [[JHRecycleSquareSelectMenuView alloc] init];
    }
    return _selectMenuView;
}

@end
