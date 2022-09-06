//
//  HomeTableViewHeader.m
//  TTjianbao
//
//  Created by jiangchao on 2018/11/27.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "JHNewRankingHeaderView.h"
#import "SDCycleScrollView.h"
#import "BannerMode.h"

#define circlerate (float)  300/750
@interface JHNewRankingHeaderView ()<SDCycleScrollViewDelegate>
{
   
    float scrollViewimageRate;
    UIView * buttonsView;
}
@property(strong,nonatomic) SDCycleScrollView *cycleScrollView;
@end
@implementation JHNewRankingHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor=[UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
        _contentView=[[UIView alloc]init];
        _contentView.backgroundColor=[UIColor clearColor];
        [self addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.offset(roundf(ScreenW*circlerate));
        }];
       
        NSArray *imagesURLStrings = @[@""];
        [self initCycleScrollView:imagesURLStrings];
        
    }
    return self;
}

-(void)initCycleScrollView:(NSArray*)arr{
    
    _cycleScrollView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0,ScreenW,roundf(ScreenW*circlerate))  delegate:self placeholderImage:[UIImage imageNamed:@""]];
    _cycleScrollView.delegate = self;
    _cycleScrollView.autoScrollTimeInterval=3;
    _cycleScrollView. infiniteLoop=YES;
    _cycleScrollView.imageURLStringsGroup=arr;
    _cycleScrollView.backgroundColor=[UIColor clearColor];
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.contentView addSubview:_cycleScrollView];
    
}
-(void)setBanners:(NSArray *)banners{
    
    _banners=banners;
    NSMutableArray * imagesURLStrings=[NSMutableArray arrayWithCapacity:10];
    for (BannerMode * banner in _banners) {
        [imagesURLStrings addObject:banner.picUrl];
    }
     self.cycleScrollView.imageURLStringsGroup=imagesURLStrings;
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)imageIndex{
    
    NSLog(@"%ld",imageIndex);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerTap:)]) {
        [self.delegate bannerTap:self.banners[imageIndex]];
    }
}

@end


