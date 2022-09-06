//
//  JHMallBaseViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2020/7/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallBaseViewController.h"

@interface JHMallBaseViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property  (nonatomic, strong) UICollectionViewFlowLayout *customLayout;
@end

@implementation JHMallBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeNavView]; //无基类navbar
     [self showBackTopImage];
     [self.view bringSubviewToFront:self.backTopImage];
     self.backTopImage.hidden = YES;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 9;
        flowLayout.minimumLineSpacing = 9;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
         self.customLayout = flowLayout;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [CommHelp toUIColorByStr:@"#F5F6FA"];
        JH_WEAK(self)
        _collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            JH_STRONG(self)
           [self loadData];
        }];
        _collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            JH_STRONG(self)
            [self loadMoreData];
        }];
        _collectionView.mj_footer.hidden = YES;
        
    }
    return _collectionView;
}
-(void)loadNewData{
    //子类继承
}
-(void)loadMoreData{
    //子类继承
}
-(void)refreshData:(NSInteger)currentIndex {
    //子类继承
}

-(void)shutdownPlayStream{
     //子类继承
}
-(void)beginPullSteam{
     //子类继承
}
-(void)srollToTop{
     //子类继承
}
-(BOOL)isRefreshing{
    
    if ([self.collectionView.mj_header isRefreshing]||self.collectionView.mj_header.state== MJRefreshStatePulling||[self.collectionView.mj_footer isRefreshing]||self.collectionView.mj_footer.state== MJRefreshStatePulling) {
        
        return YES;
    }
    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
