//
//  JHHotListBoxView.m
//  TaodangpuAuction
//
//  Created by yuyue_mp1517 on 2020/8/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHLine.h"
#import "JHHotListBoxView.h"
#import "JHBoxViewCell.h"
#import "JHSQApiManager.h"
#import "UIScrollView+JHEmpty.h"
#import "MBProgressHUD.h"

@interface JHHotListBoxView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UIButton *lastBtn;
@property(nonatomic,strong)UIButton *nextBtn;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,assign)NSInteger indexItem;
@property (nonatomic, copy) NSString *lastDateString;

@property (nonatomic, weak) UIView *tipView;
@property (nonatomic, weak) JHBoxViewCell *listCell;

/// 向上临界一次
@property (nonatomic, assign) BOOL upOnce;

@end
@implementation JHHotListBoxView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.whiteColor;
        
        [[UIView jh_viewWithColor:HEXCOLOR(0xEAEAEE) addToSuperview:self]
         mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(14);
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(3);
        }];
        
        _lastDateString = [CommHelp getCurrentTime:@"yyyy-MM-dd"];
        [self collectionView];
        [self lastBtn];
        [self nextBtn];
        self.lastBtn.hidden = NO;
        self.nextBtn.hidden = YES;
        self.indexItem = 0;
        [self loadHotListData];
//        [self addTableViewScrollObserver];
    }
    return self;
}

- (void)addTableViewScrollObserver{
    @weakify(self);
    [RACObserve(self.collectionView, contentOffset) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.dataArr.count > 0) return;
        
        CGPoint offset = [x CGPointValue];
        CGFloat scrollY = offset.y;
        //向上临界一次
        if (!self.upOnce && scrollY>30) {
            self.upOnce = YES;
            if (self.headScrollBlock) {
                self.headScrollBlock(YES);
            }
        }
        //向下临界一次
        if (self.upOnce && scrollY<=0) {
            self.upOnce = NO;
            if (self.headScrollBlock) {
                self.headScrollBlock(NO);
            }
        }
    }];
}

-(void)clickLast
{
    ///340埋点-热帖点击加在前一天数据
    [JHGrowingIO trackEventId:JHTracSQkHotPreviousDayClick];
    [self loadHotListData];
}
-(void)clickNext
{
    ///340埋点-热帖点击加在下一天数据
    [JHGrowingIO trackEventId:JHTrackSQHotNextDayClick];

    self.indexItem--;
    if (self.indexItem == 0)
    {
        self.nextBtn.hidden = YES;

    }
    if(self.dataArr.count > self.indexItem)
    {
        [self.dataArr removeLastObject];
        JHHotListModel *model = self.dataArr.lastObject;
        if(model)
        {
            _lastDateString = model.last_date;
        }
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.indexItem inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        
        [self.collectionView jh_reloadDataWithEmputyView];
    }
}
- (void)loadHotListData
{
    [self beginLoading];
    @weakify(self);
    [JHSQApiManager getHotPostList:_lastDateString completeBlock:^(JHHotListModel *model, BOOL hasError) {
        [self endLoading];
        @strongify(self);
        if (!hasError) {
            self.lastDateString = model.last_date;
            [self.dataArr addObject:model];
            [self.collectionView jh_reloadDataWithEmputyView];
            
//            if (self.dataArr.count == 0) {
//                [self dealNoDataScroll];
//            }
            
            if(self.dataArr.count > 1) {
                self.indexItem ++;
                self.nextBtn.hidden = NO;
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.indexItem inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            }
            
            if (model.is_begin) {
                [self showTipView];
            }
        }
        else {
            [self.collectionView jh_reloadDataWithEmputyView];
//            [self dealNoDataScroll];
        }
    }];
}

- (void)dealNoDataScroll{
    _collectionView.scrollEnabled = YES;
    _collectionView.contentSize = CGSizeMake(self.width, self.height+100);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.dataArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHBoxViewCell *cell = [JHBoxViewCell dequeueReusableCellWithCollectionView:collectionView indexPath:indexPath];
    JHHotListModel *model = self.dataArr[indexPath.item];
    [cell updateWithModel:model];
    cell.isRefresh = (indexPath.item == 0);
    @weakify(self);
    cell.headScrollBlock = ^(BOOL isUp) {
        @strongify(self);
        if (self.headScrollBlock) {
            self.headScrollBlock(isUp);
        }
    };
    _listCell = cell;
    return cell;
}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.itemSize = CGSizeMake(kScreenWidth, kScreenHeight-UI.tabBarHeight-UI.statusAndNavBarHeight-30);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flow];
        [self addSubview:_collectionView];
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
//        _collectionView.alwaysBounceVertical = YES;  // 垂直
        [_collectionView registerClass:[JHBoxViewCell class] forCellWithReuseIdentifier:[JHBoxViewCell cellIdentifier]];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return _collectionView;
}
-(UIButton *)lastBtn
{
    if(!_lastBtn)
    {
        _lastBtn = [UIButton jh_buttonWithImage:@"home_hot_icon_old" target:self action:@selector(clickLast) addToSuperView:self];
        //MARK: SQRedPacketToBottom：265 -> JHSQHomePageController第105行红包按钮距离底部的高度，5:间距
        CGFloat height = SQRedPacketToBottom + 5 - UI.navBarHeight;
        [_lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20.f);
            make.bottom.equalTo(self).offset(-height);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(35);
        }];
        
        JHGradientView *line = [JHGradientView new];
        [line setGradientColor:@[(__bridge id)RGB(254, 225, 0).CGColor,(__bridge id)RGB(255, 194, 66).CGColor] orientation:JHGradientOrientationHorizontal];
        [self insertSubview:line belowSubview:_lastBtn];
        [line jh_cornerRadius:17.5];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.lastBtn);
        }];
        RACChannelTo(line, hidden) = RACChannelTo(_lastBtn, hidden);
        
//        if ([CommHelp isFirstForName:@"home_hot_button_appear"])
        {
            _lastBtn.jh_titleColor(RGB515151).jh_title(@" 看前一天").jh_fontNum(15);
            [_lastBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(96);
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.lastBtn.jh_title(@"");
                [UIView animateWithDuration:0.2 animations:^{
                    [self.lastBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(35);
                    }];
                    [self layoutIfNeeded];
                }];
                
            });
        }
    }
    return _lastBtn;
}
-(UIButton *)nextBtn
{
    if(!_nextBtn)
    {
        _nextBtn = [UIButton jh_buttonWithImage:@"home_hot_icon_new" target:self action:@selector(clickNext) addToSuperView:self];
        [_nextBtn jh_cornerRadius:17.5];
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.lastBtn.mas_top).offset(-15.f);
            make.right.height.equalTo(self.lastBtn);
            make.width.mas_equalTo(35);
        }];
        
        JHGradientView *line = [JHGradientView new];
        [line setGradientColor:@[(__bridge id)RGB(254, 225, 0).CGColor,(__bridge id)RGB(255, 194, 66).CGColor] orientation:JHGradientOrientationHorizontal];
        [self insertSubview:line belowSubview:_lastBtn];
        [line jh_cornerRadius:17.5];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.nextBtn);
        }];
        RACChannelTo(line, hidden) = RACChannelTo(_nextBtn, hidden);
    }
    return _nextBtn;
}

-(NSMutableArray *)dataArr
{
    if(!_dataArr)
    {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)showTipView
{
    if(!_tipView)
    {
        _tipView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
        [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        UIView *backgroundView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:_tipView];
        [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.tipView).insets(UIEdgeInsetsMake(60, 20, 0, 20));
        }];
        
        UIImageView *imageView = [UIImageView jh_imageViewWithImage:@"img_default_page" addToSuperview:backgroundView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backgroundView).offset(100);
            make.centerX.equalTo(backgroundView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(89, 71));
        }];
        
        UILabel *textLabel = [UILabel jh_labelWithText:@"再往前没有内容了，还是看看新鲜事吧" font:13 textColor:HEXCOLOR(0xa7a7a7) textAlignment:1 addToSuperView:backgroundView];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(10);
            make.centerX.equalTo(imageView.mas_centerX);
        }];
        
        UIButton *button = [UIButton jh_buttonWithTitle:@"返回今天" fontSize:15 textColor:UIColor.blackColor target:self action:@selector(scrollViewToTopMethod) addToSuperView:backgroundView];
        [button jh_cornerRadius:22.f];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backgroundView);
            make.top.equalTo(textLabel.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(174, 44));
        }];
        
        JHGradientView *line = [JHGradientView new];
        [line setGradientColor:@[(__bridge id)RGB(254, 225, 0).CGColor,(__bridge id)RGB(255, 194, 66).CGColor] orientation:JHGradientOrientationHorizontal];
        [backgroundView insertSubview:line belowSubview:button];
        [line jh_cornerRadius:22.f];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(button);
        }];
    }
}

- (void)scrollViewToTopMethod
{
    ///340埋点- 热帖点击返回今天
    [JHGrowingIO trackEventId:JHTrackSQHotTodayClick];
    
    _indexItem = 0;
    self.nextBtn.hidden = YES;
    if(self.dataArr.count > 0)
    {
        [self.dataArr removeObjectsInRange:NSMakeRange(1, self.dataArr.count - 1)];
        JHHotListModel *model = self.dataArr.firstObject;
        _lastDateString = model.last_date;
        [self.collectionView reloadData];
        [self.tipView removeFromSuperview];
        self.tipView = nil;
    }
}

- (void)viewDidDisappearMethod
{
    [self.listCell viewDidDisappearMethod];
}
@end

