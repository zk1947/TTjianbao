//
//  JHMasterpieceDetailViewController.m
//  TTjianbao
//
//  Created by user on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMasterpieceDetailViewController.h"
#import "JHMasterpieceNavView.h"
#import "JHMpBannerCollectionViewCell.h"
#import "JHMpInfoCollectionViewCell.h"
#import "JHCustomerApiManager.h"
#import "JHMasterPiectDetailModel.h"
#import "UIView+Toast.h"
#import "JHBaseOperationView.h"

@interface JHMasterpieceDetailViewController () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) JHMasterpieceNavView *navView;
@property (nonatomic, strong) UICollectionView *mpCollectionView;
@property (nonatomic, strong) NSMutableArray   *dataSourceArray;
@property (nonatomic, strong) UILabel          *reviewStatusView;
@end

@implementation JHMasterpieceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xffffff);
    [self setupNav];
    [self setupViews];
    [self loadData];
}

- (CGFloat)navViewHeight {
    CGFloat navHeight = UI.statusBarHeight + 60.f;
    return navHeight;
}

- (void)setupNav {
    self.navView = [[JHMasterpieceNavView alloc] init];
    self.navView.isAnchor = self.isAnchor;
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo([self navViewHeight]);
    }];
    @weakify(self);
    [self.navView masterpieceNavViewBtnAction:^(JHMasterpieceNavViewButtonStyle style) {
        @strongify(self);
        switch (style) {
            case JHMasterpieceNavViewButtonStyle_Back: {
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case JHMasterpieceNavViewButtonStyle_Share: {
                NSLog(@"分享按钮点击事件");
                /// 分享
                JHShareInfo* info = [JHShareInfo new];
                info.title = self.shareData.title;
                info.desc  = self.shareData.desc;
                info.shareType = ShareObjectTypeCustomizeNormal;
                info.url = self.shareData.url;
                info.img = self.shareData.img;
                [JHBaseOperationView showShareView:info objectFlag:nil];
            }
                break;
            case JHMasterpieceNavViewButtonStyle_Delete: { /// 删除
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"确认要删除么？" preferredStyle:UIAlertControllerStyleAlert];
                JH_WEAK(self)
                [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [alertVc addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    JH_STRONG(self)
                    [self deleteOpus];
                }]];
                [self presentViewController:alertVc animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }];
    
    [self.navView reloadMPMessage:self.userIcon name:self.userName subName:self.userDesc];
}

- (void)setupViews {
    [self.view addSubview:self.mpCollectionView];
    [self.mpCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    _reviewStatusView               = [[UILabel alloc] init];
    _reviewStatusView.textColor     = HEXCOLOR(0xFF4200);
    _reviewStatusView.backgroundColor = HEXCOLOR(0xFFEDE7);
    _reviewStatusView.textAlignment = NSTextAlignmentCenter;
    _reviewStatusView.font          = [UIFont fontWithName:kFontNormal size:12.f];
    _reviewStatusView.hidden        = YES;
    [self.view addSubview:_reviewStatusView];
    [_reviewStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
        make.height.mas_equalTo(26.f);
    }];
    
    if (self.status == 2) {
        self.reviewStatusView.hidden = NO;
        if (isEmpty(self.reason)) {
            self.reviewStatusView.text = @"审核未通过";
        } else {
            self.reviewStatusView.text = self.reason;
        }
    } else {
        self.reviewStatusView.hidden = YES;
    }

}









- (UICollectionView *)mpCollectionView {
    if (!_mpCollectionView) {
        UICollectionViewFlowLayout *layout               = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing                   = 0.f;
        layout.minimumLineSpacing                        = 0.f;
        layout.scrollDirection                           = UICollectionViewScrollDirectionVertical;
        _mpCollectionView                                = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _mpCollectionView.backgroundColor                = HEXCOLOR(0xffffff);
        _mpCollectionView.delegate                       = self;
        _mpCollectionView.dataSource                     = self;
        _mpCollectionView.showsHorizontalScrollIndicator = NO;
        [_mpCollectionView registerClass:[JHMpBannerCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMpBannerCollectionViewCell class])];
        [_mpCollectionView registerClass:[JHMpInfoCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMpInfoCollectionViewCell class])];
    }
    return _mpCollectionView;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)loadData {
    [self.dataSourceArray removeAllObjects];
    [self.dataSourceArray addObject:self.opusList];
    [self.dataSourceArray addObject:@{
        @"title":NONNULL_STR(self.titleText),
        @"desc":NONNULL_STR(self.desc)
    }];
    [self.mpCollectionView reloadData];
}

- (void)deleteOpus {
    @weakify(self);
    [JHCustomerApiManager deleteOpus:self.ID completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        [JHDispatch ui:^{
            @strongify(self);
            if (hasError) {
                [self.view makeToast:@"删除失败" duration:1.0 position:CSToastPositionCenter];
            } else {
                [self.view makeToast:@"删除成功" duration:1.0 position:CSToastPositionCenter];
                if (self.callbackMethod) {
                    self.callbackMethod();
                }
                [JHDispatch after:1.f execute:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }];
    }];
}


#pragma mark - Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        JHMpBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMpBannerCollectionViewCell class]) forIndexPath:indexPath];
        [cell setViewModel:self.dataSourceArray[0]];
        return cell;
    } else {
        JHMpInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMpInfoCollectionViewCell class]) forIndexPath:indexPath];
        [cell setViewModel:self.dataSourceArray[1]];
        return cell;
    }
}

#pragma mark - FlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return CGSizeMake(ScreenWidth, ScreenWidth);
    } else {
        return CGSizeMake(ScreenWidth, ScreenH - ScreenWidth - [self navViewHeight]);
    }
}


@end
