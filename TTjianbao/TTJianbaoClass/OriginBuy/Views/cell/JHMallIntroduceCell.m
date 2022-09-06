//
//  JHMallIntroduceCell.m
//  TTjianbao
//
//  Created by jiangchao on 2020/7/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallIntroduceCell.h"
#import "JHWebViewController.h"
#import "TTjianbaoMarcoUI.h"
#import "JHGrowingIO.h"
#import "CommHelp.h"
#import "UserInfoRequestManager.h"
#import "NSString+AttributedString.h"

#define TipsHeight ((int)ceil((58.*(ScreenW-40.))/335.+20.))

@interface JHMallIntroduceCell ()
@property (nonatomic, strong) UILabel *countLabel;
@end
@implementation JHMallIntroduceCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        UIControl *bottom = [[UIControl alloc]init];
        bottom.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:bottom];
        bottom.userInteractionEnabled=YES;
        [bottom addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickBtn)]];
        bottom.backgroundColor=[CommHelp toUIColorByStr:@"ffffff"];
        bottom.layer.cornerRadius = 8;
        //    bottom.layer.masksToBounds = YES;
        [self.contentView addSubview:bottom];
        [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.offset(TipsHeight);
            make.top.equalTo(self.contentView).offset(0);
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
        countLabel.font = [UIFont systemFontOfSize:12];
        countLabel.textColor = kColor666;
        countLabel.text = @"已为宝友把关件";
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.right.offset(-10);
        }];
        
        self.countLabel = countLabel;
    }
      return self;
}
- (void)setOrderCount:(NSString *)orderCount {
    if([UserInfoRequestManager sharedInstance].hiddenHomeSaleTips)
    {
        [self setHidden:YES]; //V342暂时隐藏
    }
    _orderCount = orderCount;
    [self runCount:0];
}

- (void)runCount:(NSInteger)count {
    
    if([_orderCount integerValue] <= 0)
    {
        self.countLabel.text = @"已为宝友把关0件";
        return;
    }
    
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
+(CGSize)viewSize
{
    if([UserInfoRequestManager sharedInstance].hiddenHomeSaleTips)
    {
        return CGSizeMake(ScreenW, 1); //V342暂时隐藏
    }
    else
    {
        return CGSizeMake(ScreenW, TipsHeight);
    }
}
@end
