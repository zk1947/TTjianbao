//
//  HomeTableViewHeader.m
//  TTjianbao
//
//  Created by jiangchao on 2018/11/27.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "JHMallHeaderView.h"
#import "SDCycleScrollView.h"
#import "NTESLogManager.h"
#import "STRIAPManager.h"
#import "JHPrinterManager.h"
#import "TTjianbaoBussiness.h"
#import "JHPrinterManager.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHWebViewController.h"
#import "JHUIFactory.h"
#import "JHOrderReturnViewController.h"
#import "JHBaseOperationView.h"
#import "JHBaseOperationAction.h"
#import "JHStoreCollectionController.h"
#import "JHOperationBanView.h"
#import <IQKeyboardManager.h>
#import "JHStoneSendGoodsViewController.h"
#import "NSString+AttributedString.h"
#import "JHLotteryRuleCell.h"
#import "JHMallRecommendViewController.h"


#define circlerate (float)115/355
@interface JHMallHeaderView ()<SDCycleScrollViewDelegate>
{
    float scrollViewimageRate;
    UIView * buttonsView;
}
@property(strong,nonatomic) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UILabel *countLabel;
@end
@implementation JHMallHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor=[UIColor clearColor];
        
        _contentView=[[UIView alloc]init];
        _contentView.backgroundColor=[UIColor clearColor];
        [self addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [self initCycleScrollView];
        [self initBottomView];
    }
    return self;
}

-(void)initCycleScrollView{
    
    _cycleScrollView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10,10,ScreenW-20,circlerate*(ScreenW-20))  delegate:self placeholderImage:[UIImage imageNamed:@""]];
    _cycleScrollView.delegate = self;
    _cycleScrollView.autoScrollTimeInterval=3;
    _cycleScrollView. infiniteLoop=YES;
    _cycleScrollView.layer.cornerRadius = 4;
    _cycleScrollView.layer.masksToBounds = YES;
    _cycleScrollView.clipsToBounds = YES;
    _cycleScrollView.backgroundColor=[UIColor whiteColor];
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.contentView addSubview:_cycleScrollView];
    
}
-(void)initBottomView{
    
    UIControl *bottom = [[UIControl alloc]init];
    bottom.backgroundColor=[UIColor clearColor];
    [self addSubview:bottom];
    bottom.userInteractionEnabled=YES;
    [bottom addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickBtn)]];
    bottom.backgroundColor=[CommHelp toUIColorByStr:@"ffffff"];
    bottom.layer.cornerRadius = 8;
//    bottom.layer.masksToBounds = YES;
    [self.contentView addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.offset(TipsHeight);
        make.top.equalTo(_cycleScrollView.mas_bottom).offset(10);
    }];
    bottom.backgroundColor = HEXCOLOR(0xFFFDF6);
    bottom.layer.shadowColor = HEXCOLOR(0xFFFDF6).CGColor;
    bottom.layer.shadowOffset = CGSizeMake(0, 0);
    bottom.layer.shadowOpacity = 0.5;
    bottom.layer.shadowRadius = 5;
    [bottom addTarget:self action:@selector(onClickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *bg = [UIImageView new];
    bg.image = [UIImage imageNamed:@"img_home_sale_tip"];
    bg.contentMode = UIViewContentModeScaleAspectFit;
    bg.clipsToBounds = YES;
    [bottom addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bottom).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    
    
    UILabel *countLabel = [UILabel new];
    [bottom addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.right.offset(-10);
    }];
    
    self.countLabel = countLabel;

}

- (void)setOrderCount:(NSString *)orderCount {
    _orderCount = orderCount;
    [self runCount:0];
}

- (void)runCount:(NSInteger)count {
    
    if (count >= [self.orderCount integerValue]) {
        count = [self.orderCount integerValue];
    } else {
        NSInteger space = ceil([self.orderCount integerValue]/100.);
        count = count + space;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self runCount:count];
        });
    }
    NSString *text = [NSString stringWithFormat:@"已为宝友把关 %zd 件", count];
    self.countLabel.attributedText = [text attributedSubString:[NSString stringWithFormat:@"%zd", count] font:[UIFont fontWithName:kFontBoldDIN size:14] color:kColor333 allColor:kColor666 allfont:[UIFont fontWithName:kFontNormal size:12]];


}

-(void)onClickBtn{
    
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.urlString = H5_BASE_STRING(@"/jianhuo/app/qualityControlLand/qualityControlLand.html");
    [self.viewController.navigationController pushViewController:webVC animated:YES];
    [JHGrowingIO trackEventId:JHTrackChannel_mind_rest_click_market];

    
}

-(void)setBanners:(NSArray *)banners{
    
    _banners=banners;
    
    NSMutableArray * imagesURLStrings=[NSMutableArray arrayWithCapacity:10];
    
    for (BannerCustomerModel * banner in _banners) {
        
        [imagesURLStrings addObject:banner.image];
    }
    self.cycleScrollView.imageURLStringsGroup=imagesURLStrings;
    
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{

    
    BannerCustomerModel *model = self.banners[index];
    [JHRootController toNativeVC:model.target.componentName withParam:model.target.params from:JHLiveFromhomeMarket];
    ///源头直播banner被点击埋点
    [JHGrowingIO trackEventId:JHTrackMarketSaleBannerItemClick from:JHTrackMarketSaleClickSellBanner];
}

@end

