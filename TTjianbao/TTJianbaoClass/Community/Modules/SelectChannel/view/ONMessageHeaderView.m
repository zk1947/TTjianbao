//
//  ONMessageHeaderView.m
//  TTjianbao
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "ONMessageHeaderView.h"
#import "JHUserFocusModel.h"
#import "JHDiscoverFocusListCollectionViewCell.h"
#import "JHDiscoverChannelViewModel.h"
#import "JHDiscoverChannelModel.h"
#import "TTjianbaoMarcoNotification.h"
#import "JHAnchorPageViewController.h"
#import "TTjianbaoHeader.h"



#define ONCellWidth 119
#define ONCellHight 167
@interface ONMessageHeaderView()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic)UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger visitorPage;

/*
 
 旋转图标
 */
@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;

@end

@implementation ONMessageHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [CommHelp toUIColorByStr:@"#f7f7f7"];
        [self setUpChildView];
        // 获取访客细心记录
        //        _visitorPage = 1;
        //        [self InitVisitData];
    }
    return self;
}
- (void)setUpChildView{
    //布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ONCellWidth, ONCellHight);
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    //访客
    UICollectionView * visiterV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    visiterV.backgroundColor = [UIColor clearColor];
    visiterV.showsHorizontalScrollIndicator = NO;
    self.collectionView = visiterV;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"JHDiscoverFocusListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"OSSHeaderFocusIdentifer"];
    
//    [self.collectionView registerNib:[UINib nibWithNibName:@"JHDiscoverFocusListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JHDiscoverFocusListCollectionViewCell"];
    visiterV.delegate = self;
    visiterV.dataSource = self;
    [self addSubview:visiterV];
    [visiterV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)onClickLookMore {
    NSLog(@"查看更多。。。。。");
    if (self.jumpBlock) {
        self.jumpBlock();
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _visitorRecordArray.count;
}

- (UICollectionViewCell * )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"OSSHeaderFocusIdentifer";
    JHUserFocusModel *user = _visitorRecordArray[indexPath.row];
    JHDiscoverFocusListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    
    [cell setModel:user];
    
    JH_WEAK(self)
    __weak typeof(cell)weakCell = cell;
    cell.focusBlock = ^(JHUserFocusModel * _Nonnull model, BOOL isFocus) {
        JH_STRONG(self)
        if (![JHRootController isLogin]) {
            [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {
                if (result) {
                    [self focusRecommentuser:model isFocus:isFocus focusCell:weakCell];
                }
            }];
        }
        else{
            [self focusRecommentuser:model isFocus:isFocus focusCell:weakCell];
        }
    };
    
    cell.deleteBlock = ^(JHUserFocusModel * _Nonnull model) {
        JH_STRONG(self)
        if (![JHRootController isLogin]) {
            [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {
                
                if (result) {
                    [self deleteRecommentUser:model];
                }
            }];
        }
        else{
            [self deleteRecommentUser:model];
        }
    };
    
    cell.jumpUserBlock = ^(JHUserFocusModel * _Nonnull model) {
        JH_STRONG(self)
        if (model.is_ban > 0) {
            return;
        }
        if (user.role == 1) {
            JHAnchorPageViewController *vc = [[JHAnchorPageViewController alloc] init];
            vc.finishFollow = ^(NSString * _Nonnull anchorId, BOOL isFollow) {
                //被关注了，应该从当前collectionview移除
                if (isFollow) {
                    [self.visitorRecordArray removeObject:model];
                    [self.collectionView reloadData];
                    if (_visitorRecordArray.count == 0) {//刷新首页关注，去掉headerArray数据
                        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshFocucCateNoticeName object:nil];
                    }
                }
            };
            vc.anchorId = [NSString stringWithFormat:@"%ld", (long)model.user_id];
            [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
            
        } else {
            ///进入个人主页界面
            [self enterUserInfoPage:user];
        }
    };
    return cell;
}

- (void)deleteRecommentUser:(JHUserFocusModel *)model {
    [JHDiscoverChannelViewModel deleteRecommentUserWithItem_type:JHItemType_Friend item_id:[NSString stringWithFormat:@"%ld", (long)model.user_id] entry_type:1 entry_id:[NSString stringWithFormat:@"%ld", (long)self.cateModel.channel_id] success:^(RequestModel * _Nonnull request) {
        [_visitorRecordArray removeObject:model];
        [self.collectionView reloadData];
        if (_visitorRecordArray.count == 0) {//刷新首页关注，去掉headerArray数据
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshFocucCateNoticeName object:nil];
        }
    } failure:^(RequestModel * _Nonnull request) {
        [SVProgressHUD showErrorWithStatus:@"删除失败"];
    }];
}

- (void)focusRecommentuser:(JHUserFocusModel *)model isFocus:(BOOL)isFocus focusCell:(JHDiscoverFocusListCollectionViewCell *)cell {
    NSString *userId = [NSString stringWithFormat:@"%ld", (long)model.user_id];
    if (isFocus) {
        ///按钮的状态是选中状态 用户点击后目的是取消关注  所以用delete协议
        [JHDiscoverChannelViewModel cancleFocusRecommentUserWithUserId:userId fans_count:0 success:^(RequestModel * _Nonnull request) {
            ///不需要刷新cell
            model.is_follow = NO;
            [cell setModel:model];
//            [cell changeFocusButtonStatus:NO];
        } failure:^(RequestModel * _Nonnull request) {
            NSString *message = request.message ? request.message : @"取消关注失败";
            [SVProgressHUD showErrorWithStatus:message];
        }];
    }
    else {
        [JHDiscoverChannelViewModel focusRecommentUserWithUserId:[NSString stringWithFormat:@"%ld", (long)model.user_id] fans_count:0 success:^(RequestModel * _Nonnull request) {
        //        [_visitorRecordArray removeObject:model];
            //改变关注按钮的状态
            model.is_follow = YES;
            [cell setModel:model];

//            if (_visitorRecordArray.count == 0) {//刷新首页关注，去掉headerArray数据
//                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshFocucCateNoticeName object:nil];
//            }
        } failure:^(RequestModel * _Nonnull request) {
            NSString *message = request.message ? request.message : @"取消关注失败";
            [SVProgressHUD showErrorWithStatus:message];
        }];
        [Growing track:@"follow" withVariable:@{@"value":@"首页推荐宝友"}];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //查看详情
    NSLog(@"跳转个人主页。。。。");
    JH_WEAK(self)
    JHUserFocusModel *user = self.visitorRecordArray[indexPath.item];
    if (user.is_ban > 0) {
        return;
    }
    if (user.role == 1) {
        //鉴定师
        JHAnchorPageViewController *vc = [[JHAnchorPageViewController alloc] init];
        vc.anchorId = [NSString stringWithFormat:@"%ld", user.user_id];
        vc.finishFollow = ^(NSString * _Nonnull anchorId, BOOL isFollow) {
            JH_STRONG(self)
            //被关注了，应该从当前collectionview移除
            if (isFollow) {
                [self.visitorRecordArray removeObject:user];
                [self.collectionView reloadData];
                if (_visitorRecordArray.count == 0) {//刷新首页关注，去掉headerArray数据
                    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshFocucCateNoticeName object:nil];
                }
            }
        };
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    
    } else {
        ///进入个人主页界面
        [self enterUserInfoPage:user];
    }
}

#pragma mark - 进入个人主页界面

- (void)enterUserInfoPage:(JHUserFocusModel *)user {
    @weakify(self);
    [JHRootController enterUserInfoPage:@(user.user_id).stringValue from:@"" resultBlock:^(NSString * _Nonnull userId, BOOL isFollow) {
        @strongify(self);
        //被关注了，应该从当前collectionview移除
        if (isFollow) {
            [self.visitorRecordArray removeObject:user];
            [self.collectionView reloadData];
            if (_visitorRecordArray.count == 0) {//刷新首页关注，去掉headerArray数据
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshFocucCateNoticeName object:nil];
            }
        }
    }];
}

- (BOOL)isLgoin{
    
    if (![JHRootController isLogin]) {
        
        [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {
        }];
        
        return NO;
    }
    return YES;
}

- (void)setVisitorRecordArray:(NSArray *)visitorRecordArray{
    _visitorRecordArray = [NSMutableArray arrayWithArray:visitorRecordArray];
    [_collectionView reloadData];
}

#if 0
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView == self.collectionView){
        //检测左测滑动,开始加载更多
        NSLog(@"scrollView.contentOffset.x = %.2f, scrollView.width = %.2f, scrollView.contentSize.width = %.2f", scrollView.contentOffset.x, scrollView.width, scrollView.contentSize.width);
        if(scrollView.contentOffset.x +scrollView.width - scrollView.contentSize.width >30){
            NSLog(@"scrollview.contentOffset.x-->%f,scrollview.width-->%f,scrollview.contentsize.width--%f",scrollView.contentOffset.x,scrollView.width,scrollView.contentSize.width);
            if (self.indicatorView == nil) {
                UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(scrollView.width - 20, scrollView.mj_y + scrollView.height/2 - 10, 20, 20)];
                indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                indicatorView.hidesWhenStopped = YES;
                self.indicatorView = indicatorView;
                [self.indicatorView stopAnimating];
                //                [scrollView.superview addSubview:self.indicatorView];
                
            }
            if (!self.indicatorView.isAnimating) {
                scrollView.mj_x = -30;
                
                [self.indicatorView startAnimating];
                [self loadMoreTopic];
            }
            
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDragging");
}

/**
 
 加载更多专题
 */
- (void)loadMoreTopic {
    
    self.visitorPage ++;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 0.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.collectionView.mj_x = 0;
            [self.indicatorView stopAnimating];
        });
        
        NSMutableArray *arrar = [NSMutableArray arrayWithArray:self.visitorRecordArray];
        
        for (int i = 0; i < 10; i++) {
            JHUserFocusModel *userModel = [JHUserFocusModel new];
            userModel.userUrlStr = @"https://jianhuo-test.nos-eastchina1.126.net/user_dir/apply_appraisal/15520447260497745.jpg";
            userModel.userName = [NSString stringWithFormat:@"小强%d", i + 10];
            userModel.userDetail = [NSString stringWithFormat:@"小强详情%d", i + 10];
            [arrar addObject:userModel];
        }
        self.visitorRecordArray = arrar;
        [self.collectionView reloadData];
    });
}
#endif

@end
