//
//  JHBrowserViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBrowserViewController.h"
#import "JHPlayerViewController.h"
#import "JHBrowserCell.h"
#import "JHNormalControlView.h"
#import "JHPlayerVerticalBigView.h"

@interface JHBrowserViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) JHPlayerViewController *playerController;
@property (nonatomic, strong) JHNormalControlView *normalPlayerControlView;
@property (nonatomic, strong) JHPlayerVerticalBigView *verticalPlayerControlView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation JHBrowserViewController

+ (void)showBrowser : (NSArray<JHBrowserModel *> *)dataSource currentIndex : (NSInteger)currentIndex from : (UIViewController *)fromVc {
    JHBrowserViewController *vc = [[JHBrowserViewController alloc]init];
    vc.dataSource = dataSource;
    vc.currentIndex = currentIndex;
    
    [fromVc presentViewController:vc animated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self registerCells];
    [self.collectionView reloadData];
    
    [self.view layoutIfNeeded];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:false];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.jhStatusHidden = true;
    [self removeNavView];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.jhStatusHidden = false;
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.jhNavView];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"IM 预览 释放 - ViewController-%@释放", [self class]);
}
#pragma mark - Event

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHBrowserModel *model = self.dataSource[indexPath.item];
    if (model.mediaUrl.length > 0 ) {
        if (self.playerController.isPLaying == false) {
            UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
            [self setupPlayWithView:cell];
            self.playerController.urlString = model.mediaUrl;
        }else {
            [self.playerController pause];
        }
    }
}

- (void)didClickClose : (UIButton *) sender {
    [self dismissViewControllerAnimated:false completion:nil];
}
- (void)setupPlayWithView : (UIView *)view {
    [view addSubview:self.playerController.view];
    self.playerController.view.frame = view.bounds;
    [self.playerController setControlView:self.normalPlayerControlView];
    [self.playerController setSubviewsFrame];
}

#pragma mark - UI
- (void)setupUI {
//    self.jhTitleLabel.text = @"";
    self.view.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.closeButton];
}
- (void)layoutViews {
    [self.closeButton jh_cornerRadius:self.closeButton.bounds.size.height / 2];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-UI.bottomSafeAreaHeight);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20 + UI.topSafeAreaHeight);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(70, 40));
    }];
}

- (void) registerCells {
    [self.collectionView registerClass:[JHBrowserCell class] forCellWithReuseIdentifier:@"JHBrowserCell" ];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.playerController.isPLaying) {
        [self.playerController pause];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHBrowserModel *model = self.dataSource[indexPath.item];
    
    JHBrowserCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHBrowserCell" forIndexPath:indexPath];
    item.model = model;
    return item;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
    return size;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

#pragma mark - Lazy

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.blackColor;
        _collectionView.pagingEnabled = true;
        _collectionView.showsHorizontalScrollIndicator = false;
    }
    return _collectionView;
}
- (JHPlayerViewController *)playerController {
    if (_playerController == nil) {
        _playerController = [[JHPlayerViewController alloc] init];
        _playerController.looping = false;
        _playerController.alwaysPlay = false;
        _playerController.fullScreenView = self.verticalPlayerControlView;
//        _playerController.fullScreenView = self.view;
        [self addChildViewController:_playerController];
    }
    return _playerController;
}
- (JHNormalControlView *)normalPlayerControlView {
    if (_normalPlayerControlView == nil) {
        _normalPlayerControlView = [[JHNormalControlView alloc] initWithFrame:self.playerController.view.bounds];
    }
    return _normalPlayerControlView;
}

- (JHPlayerVerticalBigView *)verticalPlayerControlView {
    if (_verticalPlayerControlView == nil) {
        _verticalPlayerControlView = [[JHPlayerVerticalBigView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//        @weakify(self);
//        _verticalPlayerControlView.actionBlock = ^(JHFullScreenControlActionType actionType) {
//            @strongify(self);
//            [self handleFullScreenControlAction:actionType];
//        };
    }
    return _verticalPlayerControlView;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        _closeButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:18];
        _closeButton.backgroundColor = HEXCOLORA(0x000000, 0.2);
        [_closeButton addTarget:self action:@selector(didClickClose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
@end
