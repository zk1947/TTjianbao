//
//  JHAnniversaryOrderBannerView.m
//  TTjianbao
//
//  Created by apple on 2020/3/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAnniversaryOrderBannerView.h"
#import "JHAnniversaryViewModel.h"
#import "SDCycleScrollView.h"
#import <YYKit.h>

@interface JHAnniversaryOrderBannerView ()

@property (nonatomic, copy) NSArray<BannerCustomerModel *> *modelArray;

@property (nonatomic, strong) SDCycleScrollView *scrollView;

@end

@implementation JHAnniversaryOrderBannerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

-(void)show
{
    [JHAnniversaryViewModel requestOrderBannerViewBlock:^(BOOL isSuccess, NSArray<BannerCustomerModel *> * _Nullable modelArray) {
        if(isSuccess)
        {
            self.modelArray = modelArray;
            [self updateBannerUI];
            self.hidden = NO;
        }
        else
        {
            self.hidden = YES;
        }
    }];
}

-(SDCycleScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:nil placeholderImage:[UIImage imageNamed:@""]];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.layer.cornerRadius = 4;
        _scrollView.clipsToBounds = YES;
        _scrollView.autoScrollTimeInterval = 3;
        _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _scrollView.hidesForSinglePage = YES;
        _scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _scrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [self addSubview:_scrollView];
        
        @weakify(self);
        _scrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            @strongify(self);
            NSLog(@"🔥%lu",currentIndex);
            BannerCustomerModel *model = self.modelArray[currentIndex];
            [JHRootController toNativeVC:model.target.componentName withParam:model.target.params from:@"JHAnniversaryOrderBannerView"];
        };
    }
    return _scrollView;
}

- (void)updateBannerUI{
    
    NSMutableArray *imgUrls = [NSMutableArray new];
    for (NSInteger i = 0; i < self.modelArray.count; i++) {
        BannerCustomerModel *data = self.modelArray[i];
        if ([data.image isNotBlank]) {
            [imgUrls addObject:data.image];
        }
    }
    _scrollView.imageURLStringsGroup = imgUrls;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

