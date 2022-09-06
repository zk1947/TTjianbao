//
//  JHHomeCollectionViewHeaer.m
//  TTjianbao
//
//  Created by jiangchao on 2019/2/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHHomeHeaderView.h"
#import "JHWebViewController.h"
#import "JHHomeHeaderAnchorView.h"
#import "JHHomeHeaderMainAnchorView.h"
#import "NSString+NTES.h"
#import "SDCycleScrollView.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoBussiness.h"
#import "JHSeckillPageViewController.h"
#import "JHOrderListViewController.h"
#import "LXTagsView.h"
#import "JHNimNotificationManager.h"
#import "JHHomeFreeAppraiseView.h"
#import "JHAnchorStyleViewController.h"
#import "JHWebViewController.h"
#import "JHOnlineAppraiseHeader.h"


@interface JHHomeHeaderView ()<SDCycleScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UIView * headerView;
    UIView * buttonsView;
    UIImageView * titleBack;
    UILabel  *countLabel;
    UILabel  *timeLabel;
    UILabel  *appraisalCount;
    NSTimer  * balanceLabelAnimationTimer;
    UIView  *footerTitleView;
}
@property(nonatomic,strong) UIView* contentView;
@property(nonatomic,strong) UIImageView * headerImageview;
@property(nonatomic,strong)  JHHomeHeaderMainAnchorView * bigAnchorView;
//@property(nonatomic,strong)  UIScrollView * appraisalAnchorView;
//@property (nonatomic, copy) NSMutableArray<JHHomeHeaderAnchorView*>* AppraisalAnchorViewArr;
@property (nonatomic, strong) NSMutableArray<JHLiveRoomMode*>* smallChanelModes;
@property(strong,nonatomic) SDCycleScrollView *cycleScrollView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) JHHomeFreeAppraiseView *appraiseView;

@end

@implementation JHHomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initHeaderView];
        [self initAppraiseView];
        [self initRecycleView];
        [self initCycleScrollView];
        
    }
    return self;
}

///头部大的鉴定师列表部分
-(void)initHeaderView {
    headerView = [[UIView alloc] init];
    headerView.backgroundColor = kColorFFF;
    _bigAnchorView = [[JHHomeHeaderMainAnchorView alloc] init];
    _bigAnchorView.backgroundColor = kColorFFF;
    _bigAnchorView.tag = 0;
    [_bigAnchorView addTarget:self action:@selector(anchourViewPress:) forControlEvents:UIControlEventTouchUpInside];
    @weakify(self);
    _bigAnchorView.clickButton = ^(UIButton * _Nonnull button, JHLiveRoomMode * _Nonnull mode) {
        @strongify(self);
        if (self.clickButton) {
            self.clickButton(button, mode);
        }
    };
    
    [self addSubview:headerView];
    [headerView addSubview:_bigAnchorView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self).offset(0);
    }];
    
    [_bigAnchorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(headerView).offset(5);
        make.height.offset(topImageHeight);
    }];
    
    [headerView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(self.bigAnchorView.mas_bottom).offset(9);
        make.height.offset(smallImageHeight);
    }];
}

///进入鉴定介绍界面
- (void)enterIntroducePage {
    ///点击免费在线鉴定服务埋点
    [JHGrowingIO trackEventId:JHClickFreeAppraiseIntroduce];

    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/controlToast.html");
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}

///免费鉴定部分
- (void)initAppraiseView {
    JHHomeFreeAppraiseView *appraiseView = [[JHHomeFreeAppraiseView alloc] init];
    appraiseView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:appraiseView];
    appraiseView.appraiseCount = [JHNimNotificationManager sharedManager].micWaitMode.waitCount;
    _appraiseView = appraiseView;
    [appraiseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerView);
        make.top.equalTo(self.collectionView.mas_bottom);
        make.height.offset(kFreeAppraisseHeight);
        make.bottom.equalTo(headerView).offset(0);
    }];
    @weakify(self);
    ///孙蕤去掉的
//    appraiseView.introduceBlock = ^{
//        @strongify(self);
//        [self enterIntroducePage];
//    };
    appraiseView.enterAppraiseBlock = ^{
        @strongify(self);
        [self enterSelectAppraisePage];
    };
}

-(UICollectionView*)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = kColorFFF;
        flowLayout.sectionInset = UIEdgeInsetsMake(0,12, 0,12);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[JHHomeHeaderAnchorView class] forCellWithReuseIdentifier:NSStringFromClass([JHHomeHeaderAnchorView class])];
    }
    return _collectionView;
}

///进入鉴定师选择界面
- (void)enterSelectAppraisePage {
    ///点击免费申请鉴定按钮埋点
    [JHGrowingIO trackEventId:JHClickFreeAppraiseBtn];
    if (self.selectLiveBlock) {
        self.selectLiveBlock();
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.smallChanelModes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHHomeHeaderAnchorView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHHomeHeaderAnchorView class]) forIndexPath:indexPath];
    [cell setLiveRoomMode:self.smallChanelModes[indexPath.item]];
    return cell;
}

#pragma mark FlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(smallImageWidth, smallImageHeight);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 9.;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedCell) {
        self.selectedCell(@(indexPath.row+1));
    }
}

-(void)initRecycleView {
    [self addSubview:self.recycleView];
    
    [self.recycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self.appraiseView.mas_bottom).offset(12);
        make.height.mas_equalTo(recycleHeight);
    }];
}
-(void)initCycleScrollView {
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@""]];
    _cycleScrollView.delegate = self;
    _cycleScrollView.autoScrollTimeInterval = 3;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView. infiniteLoop = YES;
    _cycleScrollView.layer.cornerRadius = 4;
    _cycleScrollView.layer.masksToBounds = YES;
    _cycleScrollView.clipsToBounds = YES;
    _cycleScrollView.backgroundColor = [UIColor whiteColor];
    _cycleScrollView.showPageControl = YES;
    _cycleScrollView.pageControlDotSize = CGSizeMake(4, 4);
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self addSubview:_cycleScrollView];
    
    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.top.equalTo(self.recycleView.mas_bottom).offset(0);
        make.height.offset(0);
    }];
}
- (void)updateAppraise {
    [_appraiseView updateAppraiseData];
}

- (void)bindRecycleData:(JHRecycleHomeGetRecyclePlateModel *__nullable)plateModel {
    if (!plateModel) {
        [self.recycleView setViewModel:nil];
        [self.recycleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.appraiseView.mas_bottom).offset(0);
            make.height.mas_equalTo(0.f);
        }];
    } else {
        [self.recycleView setViewModel:plateModel];
        [self.recycleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.appraiseView.mas_bottom).offset(12);
            make.height.mas_equalTo(recycleHeight);
        }];
    }
}

-(void)setChanneData:(JHChannelData *)channeData isCacheData:(BOOL)cache{
    if (!channeData) {
        return;
    }
    _channeData = channeData;
    _appraiseView.appraiseCount = [_channeData.appraiseTotal intValue];
    if (_channeData.channels.count > 0) {
        [self.bigAnchorView setLiveRoomMode:_channeData.channels[0]];
        self.smallChanelModes = [_channeData.channels mutableCopy];
        [self.smallChanelModes removeObjectAtIndex:0];
        [self.collectionView reloadData];
    }
}
-(void)setBanners:(NSArray *)banners{
    
    _banners = banners;
    
    NSMutableArray * imagesURLStrings = [NSMutableArray arrayWithCapacity:10];
    
    for (BannerCustomerModel * banner in _banners) {
        
        [imagesURLStrings addObject:banner.image];
    }
    self.cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    
    if (_banners.count>0) {
        [_cycleScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(bannerHeight);
            make.top.equalTo(self.recycleView.mas_bottom).offset(12);
        }];
    }
    [footerTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_cycleScrollView.mas_bottom).offset(0);
    }];
    
}
-(void)intorduce:(UIButton*)button{
    
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString =H5_BASE_STRING(@"/jianhuo/baogaoinfo.html");
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}
-(void)anchourViewPress:(UIView *)view{
    
    if (self.selectedCell) {
        self.selectedCell(@(view.tag));
    }
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    BannerCustomerModel *model = self.banners[index];
    [JHRootController toNativeVC:model.target.componentName withParam:model.target.params from:JHLiveFromhomeIdentify];
    
    ///在线鉴定banner被点击埋点
    [JHGrowingIO trackEventId:@"ad_in" variables:@{
        @"ad_place_id":@(index+1),
        @"paly_name":NONNULL_STR(model.title)
    }];
    [JHGrowingIO trackEventId:JHTrackMarketSaleBannerItemClick from:JHTrackMarketSaleClickIdentifyBanner];
    
    NSDictionary *dict = @{
        @"page_position" : @"在线鉴定",
        @"position_sort" : [NSString stringWithFormat:@"%@", @(index)],
        @"content_url" : model.target.recordComponentName ?: @"",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"bannerClick" params:dict type:JHStatisticsTypeSensors];
}

-(CGFloat)getHeaderHeight{
    
    [self layoutIfNeeded];
    return _contentView.height;
}
- (void)refreshThemeView:(BOOL)isActiveTheme
{
    [self.bigAnchorView refreshThemeView:isActiveTheme];
}
-(JHHomeHeaderMainAnchorView*)getNearlyAnchorView{
    
    for (UIView *obj in headerView.subviews) {
        if ([obj isKindOfClass:[JHHomeHeaderMainAnchorView class]]) {
            JHHomeHeaderMainAnchorView* view=(JHHomeHeaderMainAnchorView*)obj;
            CGRect rect = [view convertRect:view.bounds toView:self.viewController.view];
            if (rect.origin.y>=0 && rect.origin.y+rect.size.height <= ScreenH-UI.bottomSafeAreaHeight-49 - UI.statusAndNavBarHeight) {
                return view;
            }
        }
    }
    return nil;
}
- (void)setNumberTextOfLabel:(UILabel *)label WithAnimationForValueContent:(CGFloat)value
{
    CGFloat lastValue = [label.text floatValue];
    CGFloat delta = value - lastValue;
    if (delta == 0) {
        
        return;
    }
    
    if (delta > 0) {
        
        CGFloat ratio = value / 150.0;
        
        NSDictionary *userInfo = @{@"label" : label,
                                   @"value" : @(value),
                                   @"ratio" : @(ratio)
        };
        
        balanceLabelAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(setupLabel:) userInfo:userInfo repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:balanceLabelAnimationTimer forMode:NSRunLoopCommonModes];
    }
}
- (void)setupLabel:(NSTimer *)timer
{
    NSDictionary *userInfo = timer.userInfo;
    UILabel *label = userInfo[@"label"];
    CGFloat value = [userInfo[@"value"] floatValue];
    CGFloat ratio = [userInfo[@"ratio"] floatValue];
    
    static int flag = 1;
    CGFloat lastValue = [label.text floatValue];
    CGFloat randomDelta = (arc4random_uniform(2) + 1) * ratio;
    CGFloat resValue = lastValue + randomDelta;
    
    if ((resValue >= value) || (flag == 150)) {
        label.text = [NSString stringWithFormat:@"%.f", value];
        flag = 1;
        [timer invalidate];
        timer = nil;
        return;
    } else {
        label.text = [NSString stringWithFormat:@"%.f", resValue];
    }
    
    flag++;
}
- (JHRecycleCategoryView *)recycleView {
    if (!_recycleView) {
        _recycleView = [[JHRecycleCategoryView alloc] initWithFrame:CGRectZero];
    }
    return _recycleView;
}
@end

@interface JHHomeHeaderSegmentView   ()
{
}
@property (nonatomic, strong) UIImageView *indicateView;
@property (nonatomic, strong) UIScrollView *segmentScrollView;
@property (nonatomic, strong) UIButton *cateButton;
@property (nonatomic, strong) NSMutableArray<UIButton*>*buttonArr;
@property (nonatomic, strong) NSMutableArray<VideoCateMode*>*cateArr;
@end

@implementation JHHomeHeaderSegmentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonArr=[NSMutableArray arrayWithCapacity:10];
        self.cateArr=[NSMutableArray arrayWithCapacity:10];
        self.backgroundColor=[UIColor whiteColor];
        [self addSubview:self.segmentScrollView];
        [self.segmentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.height.equalTo(self);
            make.top.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
        }];
        //分类展开按钮
//        [self addSubview:self.cateButton];
//        [self.cateButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.right.equalTo(self);
//            make.width.mas_equalTo(70);
//        }];
    }
    return self;
}
-(void)setBackColor:(UIColor *)backColor{
    
    self.backgroundColor=backColor;
    
}
-(void)setUpSegmentView:(NSArray*)cates{
    self.cateArr=[cates mutableCopy];
    UIButton * lastView;
    for (int i=0; i<[cates count]; i++) {
        
        UIButton * button = [[UIButton alloc]init];
        [button setTitle:[[cates objectAtIndex:i]name] forState:UIControlStateNormal];
        button.tag=i;
        button.backgroundColor=[UIColor clearColor];
       // button.backgroundColor=HEXCOLOR(0xeeeeee);
        button.layer.cornerRadius = 14;
        button.layer.masksToBounds = YES;
        button.clipsToBounds = YES;
        
        button.titleLabel.font= [UIFont fontWithName:kFontNormal size:14];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.segmentScrollView addSubview:button];
        [self.buttonArr addObject:button];
        
        if (i==0) {
            button.selected=YES;
            button.titleLabel.font= [UIFont fontWithName:kFontMedium size:15];
            button.backgroundColor=HEXCOLOR(0xfee100);
        }
        
        CGSize titleSize=[[[cates objectAtIndex:i]name] stringSizeWithFont: [UIFont fontWithName:kFontMedium size:15]];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.segmentScrollView);
            make.height.offset(28);
            make.width.offset(titleSize.width+25);
            if (i==0) {
                make.left.equalTo(self.segmentScrollView).offset(10);
            }
            else{
                make.left.equalTo(lastView.mas_right).offset(8);
            }
            if (i==[cates count]-1) {
                make.right.equalTo(self.segmentScrollView);
            }
        }];
        
        lastView= button;
    }
    
}
-(UIScrollView*)segmentScrollView{
    
    if (!_segmentScrollView) {
        _segmentScrollView=[[UIScrollView alloc]init];
        _segmentScrollView.showsHorizontalScrollIndicator = NO;
        _segmentScrollView.showsVerticalScrollIndicator = NO;
        _segmentScrollView.backgroundColor = [UIColor clearColor];
        _segmentScrollView.scrollEnabled=YES;
        _segmentScrollView.alwaysBounceHorizontal = YES;
    }
    
    return _segmentScrollView;
}
- (UIButton *)cateButton
{
    if(!_cateButton)
    {
        _cateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cateButton setImage:[UIImage imageNamed:@"icon_cate_down"] forState:UIControlStateNormal];
        [_cateButton addTarget:self action:@selector(pressCateButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cateButton;
}
-(void)pressCateButton
{
    if (self.clickeHeader)
    {
        VideoCateMode* mode = [VideoCateMode new];
        mode.type = kHeaderTypeCateButton;
        self.clickeHeader(mode);
    }
}
-(void)buttonPress:(UIButton*)button{
    
    for ( UIView * view in self.segmentScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn=(UIButton*)view;
            btn.selected=NO;
            btn.titleLabel.font= [UIFont fontWithName:kFontNormal size:14];
            btn.backgroundColor=[UIColor clearColor];
           // btn.backgroundColor=HEXCOLOR(0xeeeeee);
        }
    }
      button.selected=YES;
     _type = button.tag;
    button.titleLabel.font= [UIFont fontWithName:kFontMedium size:15];
      button.backgroundColor=HEXCOLOR(0xfee100);
   

      [self scrollSegementView:button];
}
- (void)scrollSegementView:(UIButton*)selectButton{
    
    CGFloat selectedWidth = selectButton.frame.size.width;
    CGFloat offsetX = (ScreenW - selectedWidth) / 2;
    
    if (selectButton.frame.origin.x <= ScreenW / 2) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.segmentScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        } completion:^(BOOL finished) {
            
            if (self.clickeHeader) {
                self.clickeHeader(self.cateArr[selectButton.tag]);
            }
        }];
        
    } else if (CGRectGetMaxX(selectButton.frame) >= (self.segmentScrollView.contentSize.width - ScreenW / 2)) {
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.segmentScrollView setContentOffset:CGPointMake(self.segmentScrollView.contentSize.width - ScreenW, 0) animated:NO];
        } completion:^(BOOL finished) {
            
            if (self.clickeHeader) {
                self.clickeHeader(self.cateArr[selectButton.tag]);
            }
        }];
        
    } else {
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.segmentScrollView setContentOffset:CGPointMake(CGRectGetMinX(selectButton.frame) - offsetX, 0) animated:NO];
        } completion:^(BOOL finished) {
            
            if (self.clickeHeader) {
                self.clickeHeader(self.cateArr[selectButton.tag]);
            }
        }];
    }
}



@end
