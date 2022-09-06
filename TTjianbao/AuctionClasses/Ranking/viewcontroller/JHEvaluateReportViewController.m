//
//  JHEvaluateReportViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/3/4.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHEvaluateReportViewController.h"
#import "JHCircleDrawView.h"
#import "JHRankingModel.h"
#import "JHOrderAppraisalVideoViewController.h"
#import "EnlargedImage.h"
#import "NSString+AttributedString.h"
#import "JHWebViewController.h"
#import "JHEvaluateReportModel.h"
#import "JHEvaluateReportView.h"
#import "JHBaseOperationView.h"
#import "JHEvaluateReportDetailView.h"

@interface JHEvaluateReportViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *orderCover;
@property (weak, nonatomic) IBOutlet UILabel *appraiserName;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet JHCircleDrawView *circleView;

@property (weak, nonatomic) IBOutlet UILabel *videoTitle;

@property (weak, nonatomic) IBOutlet UILabel *videoDuring;
@property (weak, nonatomic) IBOutlet UIImageView *videoCover;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoCoverRate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *propertyHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toTopHeihgt;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *desScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreCost; //(number, optional): 性价比分值 ,
@property (weak, nonatomic) IBOutlet UILabel *scoreCraft;// (number, optional): 工艺分值 ,
@property (weak, nonatomic) IBOutlet UILabel *scoreHedging;// (number, optional): 保值空间分值 ,
@property (weak, nonatomic) IBOutlet UILabel *scoreRare;// (number, optional): 稀有度分值 ,

@property (weak, nonatomic) IBOutlet UIView *propertyView;

@property (strong, nonatomic) JHRankingNewModel *model;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UILabel *updateTime;

@property (assign, nonatomic) NSInteger beginTime;
@property (strong, nonatomic) UIView* evaluateTopView;
@property (strong, nonatomic) UIView* evaluateView;
@property (strong, nonatomic) UILabel* evaluateTitleLabel;
@property (strong, nonatomic) UIButton* helpfulBtn;
@property (strong, nonatomic) UIButton* unhelpfulBtn;
@property (strong, nonatomic) UIButton* seeEvaluateDetailBtn;
@property (strong, nonatomic) JHEvaluateReportModel* evaluateReportModel;
@property (strong, nonatomic) JHEvaluateReportView* evaluateReportView;
@property (strong, nonatomic) JHEvaluateReportDetailView* evaluateReportDetailView;
@property (nonatomic, copy) NSString* evaluateReportId; //评估报告评价操作专用
@end

@implementation JHEvaluateReportViewController

- (void)dealloc {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"from"] = self.from;
    if (self.beginTime) {
        dic[@"duration"] = @((time(NULL) - self.beginTime)*1000);
    } else {
        dic[@"duration"] = @(0);
    }
    [JHGrowingIO trackEventId:JHtrackorder_report_detail_duration variables:dic];
    NSLog(@"%@*************被释放",[self class])

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.from = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.beginTime = time(NULL);
    self.view.backgroundColor = HEXCOLOR(0xeeeeee);
    self.scrollView.backgroundColor = APP_BACKGROUND_COLOR;
//    [self  initToolsBar];
//    [self.navbar setTitle:@"评估报告"];
//    self.navbar.titleLbl.textColor = HEXCOLOR(0x222222);
//    self.navbar.ImageView.hidden = YES;
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    self.navbar.backgroundColor = HEXCOLOR(0xeeeeee);
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.toTopHeihgt.constant = UI.statusAndNavBarHeight;
//    [self.navbar addrightBtn:@"" withImage:[UIImage imageNamed:@"report_icon_share"] withHImage:[UIImage imageNamed:@"report_icon_share"] withFrame:CGRectMake(ScreenW-44,0,44,44)];
//    
//    [self.navbar.rightBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"评估报告";
    self.jhTitleLabel.textColor = HEXCOLOR(0x222222);
    self.jhNavView.backgroundColor = HEXCOLOR(0xeeeeee);
    [self initRightButtonWithImageName:@"report_icon_share" action:@selector(shareAction:)];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(44);
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
    [self requestData];
    self.scrollView.hidden = YES;
    [self drawEvaluateView];
//    [self showDefaultImageWithView:self.view];
//    self.likeBtn.layer.cornerRadius = 2;
    self.likeBtn.layer.masksToBounds = YES;
    self.likeBtn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
    self.likeBtn.layer.borderWidth = 0.5;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigImage)];
    self.orderCover.userInteractionEnabled = YES;
    [self.orderCover addGestureRecognizer:tap];
    
    [JHGrowingIO trackEventId:JHtrackorder_report_detail_in from:self.from];
}

- (void)setModel:(JHRankingNewModel *)model {
    _model = model;
    [self.userIcon jhSetImageWithURL:[NSURL URLWithString:model.buyerImg] placeholder:kDefaultAvatarImage];
    self.userName.text = model.buyerName;
    self.timeLabel.text = model.appraiseDate;
    self.titleLabel.text = model.reportGoodsName;
    self.appraiserName.text = [NSString stringWithFormat:@"鉴定师：%@", model.anchorName];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.originOrderPrice];
    [self.orderCover jhSetImageWithURL:[NSURL URLWithString:ThumbMiddleByOrginal(model.goodsUrl)] placeholder:kDefaultCoverImage];
    
    if (model.isLaud) {
        [self.likeBtn setSelected:YES];
    }
    else{
        [self.likeBtn setSelected:NO];
    }
    [self.likeBtn setTitle:[@" " stringByAppendingString:OBJ_TO_STRING(_model.lauds)] forState:UIControlStateNormal];
    
    [self.circleView drawCicleWithRate:model.scoreAverage/100.];
    NSString *score = [NSString stringWithFormat:@"%.2f",model.scoreAverage];

    self.scoreLabel.attributedText = [[NSString stringWithFormat:@"%@分",score] attributedSubString:[score substringFromIndex:score.length-3] subString:@"分" font:[UIFont fontWithName:kFontBoldDIN size:38] color:HEXCOLOR(0xFF0000) sfont:[UIFont fontWithName:@"PingFangSC-Semibold" size:25] scolor:HEXCOLOR(0xFF0000) allColor:HEXCOLOR(0xFF0000) allfont:[UIFont fontWithName:kFontBoldDIN size:46]];
    
    self.desScoreLabel.text = model.overshoot;
    self.scoreRare.text = [NSString stringWithFormat:@"%.2f", model.scoreRare];
    self.scoreCost.text =  [NSString stringWithFormat:@"%.2f", model.scoreCost];
    self.scoreCraft.text =  [NSString stringWithFormat:@"%.2f", model.scoreCraft];
    self.scoreHedging.text =  [NSString stringWithFormat:@"%.2f", model.scoreHedging];
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dic = @{@"fieldName":@"种类",@"score":@0,@"fieldValue":model.cateName};
    [array addObject:dic];
    [array addObjectsFromArray:model.reportRecordScoreFieldList];
    NSInteger count = array.count;
    self.propertyHeight.constant = count *50;
    CGFloat maxH = 0.;
    CGFloat hh = 50;
     [self.propertyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < count; i++) {
        NSDictionary *dic = array[i];
      
        UIView *_v = [[UIView alloc] initWithFrame:CGRectMake(0, maxH, self.propertyView.mj_w, hh)];
        _v.backgroundColor = i%2?HEXCOLOR(0xf7f7f7):HEXCOLOR(0xffffff);
        [self.propertyView addSubview:_v];
        UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(24, 0, 56, hh)];
        l1.textColor = HEXCOLOR(0x666666);
        l1.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];
        l1.text = dic[@"fieldName"];
        [_v addSubview:l1];
        UILabel *l3 = [[UILabel alloc] initWithFrame:CGRectMake(_v.mj_w-80, 0, 68, hh)];
        l3.textColor = HEXCOLOR(0x666666);
        l3.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        NSNumber *string = dic[@"score"];
        if ([string floatValue] == 0.0) {
            l3.text = @"";
        }else {
             l3.text = [NSString stringWithFormat:@"%.2f", [string floatValue]];
        }
       
        l3.textAlignment = NSTextAlignmentRight;
        [_v addSubview:l3];

        UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, _v.mj_w-80-90, hh)];
        l2.textColor = HEXCOLOR(0x666666);
        l2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        l2.numberOfLines = 0;
        l2.lineBreakMode = NSLineBreakByCharWrapping;
        l2.text = dic[@"fieldValue"];
        [_v addSubview:l2];
        
        maxH += hh;
    }
    
    self.videoTitle.text = model.reportGoodsName;
    self.videoDuring.text = [CommHelp getHMSWithSecond:_model.videoDuration];

    [self.videoCover jhSetImageWithURL:[NSURL URLWithString:ThumbMiddleByOrginal(model.videoCoverImg)] placeholder:kDefaultCoverImage];
    self.updateTime.text = model.updateDate;
    

}
- (void)requestData {
    if (!self.orderId && !self.appraiseRecordId) {
        [self.view makeToast:@"评估报告不存在"];
    }
    NSInteger type = 0;
    if (self.orderId) {
        type = 1;
    }

    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/report/authoptional/reportDetail/order") Parameters:@{@"id":type==1?self.orderId:self.appraiseRecordId,@"type":@(type),@"source":@"order"} successBlock:^(RequestModel *respondObject) {
        self.model = [JHRankingNewModel mj_objectWithKeyValues:respondObject.data];
         if(self.model.appraiseRecordId)
         {
             self.evaluateReportId = self.model.appraiseRecordId;
         }
        self.scrollView.hidden = NO;
        [self hiddenDefaultImage];
        //刷新订单详情鉴定报告已读状态
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];
        [self refreshEvaluateView];
    
         
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}

- (UIView *)evaluateView
{
    if(!_evaluateView)
    {
        _evaluateView = [UIView new];
        _evaluateView.backgroundColor = HEXCOLOR(0xFFFFFF);
    }
    return _evaluateView;
}

- (void)drawEvaluateView
{
    //修改现有约束
//    [self.appraiserName mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.videoCover);
//        make.bottom.equalTo(self.timeLabel);
//    }];
    //给个初始值,其实这么给值是有问题的
    if(self.appraiseRecordId)
        self.evaluateReportId = self.appraiseRecordId;
    else
        self.evaluateReportId = self.orderId;
    //评价view
    [self.scrollView addSubview:self.evaluateView];
    
    ///底部色条
    [[UIView jh_viewWithColor:APP_BACKGROUND_COLOR addToSuperview:self.scrollView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scrollView);
        make.left.right.equalTo(self.evaluateView);
        make.height.mas_equalTo(UI.bottomSafeAreaHeight + 84);
    }];

    [self.likeBtn removeFromSuperview];
    [self.shareBtn removeFromSuperview];
    [self.scrollView addSubview:self.likeBtn];
    [self.likeBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scrollView).offset(- 19 - UI.bottomSafeAreaHeight);
        make.left.equalTo(self.scrollView).offset(25);
        make.height.mas_equalTo(44);
    }];
    [self.scrollView addSubview:self.shareBtn];
    [self.shareBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.likeBtn.mas_right).offset(10);
        make.width.bottom.equalTo(self.likeBtn);
        make.right.equalTo(self.scrollView).offset(-25);
        make.height.mas_equalTo(44);
    }];
    
    [self.evaluateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.scrollView);
        make.height.mas_equalTo(118);
        make.bottom.mas_equalTo(self.likeBtn.mas_top).offset(-21 - UI.bottomSafeAreaHeight);
        make.top.mas_equalTo(self.videoCover.mas_bottom).offset(20+10+10 + UI.bottomSafeAreaHeight);
    }];
    
    ///顶部色条
    self.evaluateTopView = [UIView jh_viewWithColor:APP_BACKGROUND_COLOR addToSuperview:self.scrollView];
    [self.evaluateTopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.evaluateView.mas_top);
        make.left.right.equalTo(self.evaluateView);
        make.height.mas_equalTo(10);
    }];
    
    //title
    self.evaluateTitleLabel = [UILabel new];
    self.evaluateTitleLabel.font = JHMediumFont(22);
    self.evaluateTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.evaluateTitleLabel.textColor = HEXCOLOR(0x333333);
    self.evaluateTitleLabel.text = @"本次鉴定是否对你有帮助";
    [self.evaluateView addSubview:self.evaluateTitleLabel];
    [self.evaluateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.evaluateView).offset(15);
        make.height.mas_equalTo(30);
    }];
    
    UILabel* nameLabel = [UILabel new];
    nameLabel.font = JHFont(12);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = HEXCOLOR(0x666666);
    nameLabel.text = @"匿名";
    nameLabel.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
    nameLabel.layer.borderWidth = 0.5;
    nameLabel.layer.cornerRadius = 4;
    [self.evaluateView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.evaluateTitleLabel).offset(8);
        make.left.mas_equalTo(self.evaluateTitleLabel.mas_right).offset(10);
        make.width.mas_equalTo(34);
        make.height.mas_equalTo(18);
    }];
    
    CGFloat offset = (ScreenWidth - 85*2 - 63)/2.0;
    //button
    self.helpfulBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.helpfulBtn setTitle:@"有帮助" forState:UIControlStateNormal];
    [self.helpfulBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    self.helpfulBtn.titleLabel.font = JHFont(14);
    self.helpfulBtn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
    self.helpfulBtn.layer.borderWidth = 0.5;
    self.helpfulBtn.layer.cornerRadius = 14;
    [self.helpfulBtn addTarget:self action:@selector(helpfulAction) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluateView addSubview:self.helpfulBtn];
    [self.helpfulBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.evaluateTitleLabel.mas_bottom).offset(22);
        make.left.equalTo(self.evaluateView).offset(offset);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(85);
    }];
    
    self.unhelpfulBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.unhelpfulBtn setTitle:@"没帮助" forState:UIControlStateNormal];
    [self.unhelpfulBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    self.unhelpfulBtn.titleLabel.font = JHFont(14);
    self.unhelpfulBtn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
    self.unhelpfulBtn.layer.borderWidth = 0.5;
    self.unhelpfulBtn.layer.cornerRadius = 14;
    [self.unhelpfulBtn addTarget:self action:@selector(unhelpfulAction) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluateView addSubview:self.unhelpfulBtn];
    [self.unhelpfulBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.helpfulBtn);
        make.left.mas_equalTo(self.helpfulBtn.mas_right).offset(63);
        make.width.height.mas_equalTo(self.helpfulBtn);
    }];
    
    UIImageView* helpfulImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_evaluate_report_good"]];
//    helpfulImg.contentMode = UIViewContentModeScaleAspectFit;
    helpfulImg.backgroundColor = [UIColor clearColor];
    helpfulImg.userInteractionEnabled = NO;
    [self.evaluateView addSubview:helpfulImg];
    [helpfulImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.helpfulBtn).offset(-13);
        make.top.equalTo(self.helpfulBtn).offset(-2);
        make.size.mas_equalTo(CGSizeMake(32, 33));
    }];
    
    UIImageView* unhelpfulImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_evaluate_report_bad"]];
//    unhelpfulImg.contentMode = UIViewContentModeScaleAspectFit;
    unhelpfulImg.backgroundColor = [UIColor clearColor];
    unhelpfulImg.userInteractionEnabled = NO;
    [self.evaluateView addSubview:unhelpfulImg];
    [unhelpfulImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.unhelpfulBtn).offset(-13);
        make.top.equalTo(self.unhelpfulBtn).offset(2);
        make.size.mas_equalTo(CGSizeMake(32, 33));
    }];
    
    RAC(helpfulImg, hidden) = RACObserve(_helpfulBtn, hidden);
    RAC(unhelpfulImg, hidden) = RACObserve(_unhelpfulBtn, hidden);
    //查看评价
    _seeEvaluateDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_seeEvaluateDetailBtn setTitle:@"查看评价 >" forState:UIControlStateNormal];
    [_seeEvaluateDetailBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _seeEvaluateDetailBtn.titleLabel.font = JHFont(14);
    [_seeEvaluateDetailBtn addTarget:self action:@selector(evaluateDetailAction) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluateView addSubview:_seeEvaluateDetailBtn];
    [_seeEvaluateDetailBtn setHidden:YES];
    [_seeEvaluateDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.helpfulBtn.mas_bottom).offset(23);
        make.centerX.equalTo(self.evaluateView).offset(0);
        make.height.mas_equalTo(20);
    }];
}

- (void)refreshEvaluateView
{
    CGFloat offset = (ScreenWidth - 85*2 - 63)/2.0;
    if(self.model.showComment)
    {
        [self.evaluateView setHidden:NO];
        [self.evaluateTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.evaluateView.mas_top);
            make.left.right.equalTo(self.evaluateView);
            make.height.mas_equalTo(10);
        }];
        if([self.model.commentHelpful isEqualToString:@"1"] ||
           [self.model.commentHelpful isEqualToString:@"2"])
        {
            [_seeEvaluateDetailBtn setHidden:NO];
            [self.evaluateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                 make.left.right.equalTo(self.scrollView);
                 make.height.mas_equalTo(159);
                 make.bottom.mas_equalTo(self.likeBtn.mas_top).offset(-21);
                 make.top.mas_equalTo(self.videoCover.mas_bottom).offset(20+10+10);
             }];
            if([self.model.commentHelpful isEqualToString:@"1"])
            {
                [self.unhelpfulBtn setHidden:YES];
                [self.helpfulBtn setHidden:NO];
                [self.helpfulBtn removeTarget:self action:@selector(helpfulAction) forControlEvents:UIControlEventTouchUpInside];
                self.helpfulBtn.backgroundColor = HEXCOLOR(0xFFFDF1);
                self.helpfulBtn.layer.borderColor = HEXCOLORA(0xFEE100, 1).CGColor;
                [self.helpfulBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                       make.top.mas_equalTo(self.evaluateTitleLabel.mas_bottom).offset(22);
                       make.centerX.mas_equalTo(self.evaluateView).offset(0);
                       make.height.mas_equalTo(28);
                       make.width.mas_equalTo(85);
                   }];
            }
            else
            {
                [self.unhelpfulBtn setHidden:NO];
                [self.helpfulBtn setHidden:YES];
                [self.unhelpfulBtn removeTarget:self action:@selector(unhelpfulAction) forControlEvents:UIControlEventTouchUpInside];
                self.unhelpfulBtn.backgroundColor = HEXCOLOR(0xFFFDF1);
                self.unhelpfulBtn.layer.borderColor = HEXCOLORA(0xFEE100, 1).CGColor;
                [self.unhelpfulBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.helpfulBtn);
                    make.centerX.mas_equalTo(self.evaluateView).offset(0);
                    make.width.height.mas_equalTo(self.helpfulBtn);
                }];
            }
        }
        else
        {
            [_seeEvaluateDetailBtn setHidden:YES];
            [self.evaluateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                 make.left.right.equalTo(self.scrollView);
                 make.height.mas_equalTo(118);
                 make.bottom.mas_equalTo(self.likeBtn.mas_top).offset(-21);
                 make.top.mas_equalTo(self.videoCover.mas_bottom).offset(20+10+10);
             }];
            [self.unhelpfulBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.helpfulBtn);
                make.left.mas_equalTo(self.helpfulBtn.mas_right).offset(63);
                make.width.height.mas_equalTo(self.helpfulBtn);
            }];
            [self.helpfulBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.evaluateTitleLabel.mas_bottom).offset(22);
                make.left.equalTo(self.evaluateView).offset(offset);
                make.height.mas_equalTo(28);
                make.width.mas_equalTo(85);
            }];
            [self.unhelpfulBtn setHidden:NO];
            [self.helpfulBtn setHidden:NO];
            [self.helpfulBtn addTarget:self action:@selector(helpfulAction) forControlEvents:UIControlEventTouchUpInside];
            [self.unhelpfulBtn addTarget:self action:@selector(unhelpfulAction) forControlEvents:UIControlEventTouchUpInside];
            self.helpfulBtn.backgroundColor = HEXCOLOR(0xFFFFFF);
            self.helpfulBtn.layer.borderColor = HEXCOLORA(0xBDBFC2, 1).CGColor;
            self.unhelpfulBtn.backgroundColor = HEXCOLOR(0xFFFFFF);
            self.unhelpfulBtn.layer.borderColor = HEXCOLORA(0xBDBFC2, 1).CGColor;
        }
    }
    else
    {
        [self.evaluateView setHidden:YES];
        [self.evaluateTopView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.evaluateView.mas_top);
            make.left.right.equalTo(self.evaluateView);
            make.height.mas_equalTo(0);
        }];
        [self.evaluateView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.scrollView);
            make.height.mas_equalTo(0);
            make.bottom.mas_equalTo(self.videoCover.mas_bottom).offset(20+10+10 + UI.bottomSafeAreaHeight);
            make.top.mas_equalTo(self.videoCover.mas_bottom).offset(20+10+10 + UI.bottomSafeAreaHeight);
        }];
    }
}

- (JHEvaluateReportModel *)evaluateReportModel
{
    if(!_evaluateReportModel)
    {
        _evaluateReportModel = [JHEvaluateReportModel new];
    }
    return _evaluateReportModel;
}

- (JHEvaluateReportView *)evaluateReportView
{
    if(!_evaluateReportView)
    {
        _evaluateReportView = [JHEvaluateReportView new];
        JH_WEAK(self)
        _evaluateReportView.callbackAction = ^(JHEvaluateReportModel* model) {
            JH_STRONG(self)
            [self submitReport:model];
        };
    }
    return _evaluateReportView;
}

- (JHEvaluateReportDetailView *)evaluateReportDetailView
{
    if(!_evaluateReportDetailView)
    {
        _evaluateReportDetailView = [JHEvaluateReportDetailView new];
    }
    return _evaluateReportDetailView;
}
         
- (void)helpfulAction
{
    [JHGrowingIO trackPublicEventId:JHClickOrderEvaluateListHelpClick];
    JH_WEAK(self)
    [self.evaluateReportModel requestEvaluateDetailAppraiseId:self.evaluateReportId helpful:@"1" response:^(JHEvaluateReportModel* model, NSString* msg) {
        JH_STRONG(self)
        if(msg)
            [SVProgressHUD showErrorWithStatus:msg];
        else if(model)
            [self.evaluateReportView preLoadData:model helpful:YES];
        else
            [SVProgressHUD showErrorWithStatus:@"无数据"];
    }];
}

- (void)unhelpfulAction
{
    [JHGrowingIO trackPublicEventId:JHClickOrderEvaluateListNohelpClick];
    JH_WEAK(self)
    [self.evaluateReportModel requestEvaluateDetailAppraiseId:self.evaluateReportId helpful:@"0" response:^(JHEvaluateReportModel* model, NSString* msg) {
        JH_STRONG(self)
        if(msg)
            [SVProgressHUD showErrorWithStatus:msg];
        else if(model)
            [self.evaluateReportView preLoadData:model helpful:NO];
        else
            [SVProgressHUD showErrorWithStatus:@"无数据"];
    }];
}

- (void)submitReport:(JHEvaluateReportModel*)model
{
    [self.evaluateReportModel requestSaveEvaluateAppraiseId:self.evaluateReportId report:model response:^(NSString* msg) {
        if(msg)
        {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"评价成功"];
            [self requestData]; //刷新页面
        }
    }];
}

- (void)evaluateDetailAction
{
    NSString* helpful = @"1";
    if([self.model.commentHelpful isEqualToString:@"1"])
    {
        helpful = @"1";
    }
    else if([self.model.commentHelpful isEqualToString:@"2"])
    {
        helpful = @"0";
    }
    JH_WEAK(self)
    [self.evaluateReportModel requestEvaluateDetailAppraiseId:self.evaluateReportId helpful:helpful response:^(JHEvaluateReportModel* model, NSString* msg) {
        JH_STRONG(self)
        if(msg)
            [SVProgressHUD showErrorWithStatus:msg];
        else if(model)
            [self.evaluateReportDetailView preLoadData:model helpful:[helpful integerValue]];
        else
            [SVProgressHUD showErrorWithStatus:@"无数据"];
        
    }];
}

- (IBAction)toVideo:(id)sender {
    
   
    JHOrderAppraisalVideoViewController * appraisalVideo=[[JHOrderAppraisalVideoViewController alloc]initWithStreamUrl:self.model.videoUrl];
    if (self.orderId) {
        appraisalVideo.from = 3;
    }else {
        if (self.appraiseRecordId) {
            appraisalVideo.from = 1;
        }
    }
    appraisalVideo.liveId = self.model.originRecordId;
    appraisalVideo.videoId = self.model.channelRecordId;
    [self.navigationController pushViewController:appraisalVideo animated:YES];
}
- (IBAction)likeAction:(id)sender {

    if ([self isLgoin]) {
        UIButton * button=(UIButton*)sender;
        NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/video/auth/viewerChangeStatusNew?channelRecordId=%@&status=%@"),self.model.channelRecordId ,@(!button.selected)];
        [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [self.likeBtn setSelected:!button.selected];
           [self.likeBtn setTitle:[@" " stringByAppendingString:[NSString stringWithFormat:@"%@",respondObject.data[@"countStr"]]] forState:UIControlStateNormal];
            
        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [UITipView showTipStr:respondObject.message];
            
        }];
        [SVProgressHUD show];
    }
}

- (IBAction)shareAction:(id)sender {
    
    if ([self isLgoin]){
        
//        User *user = [UserInfoRequestManager sharedInstance].user;
//        NSString *text = [NSString stringWithFormat:@"看看这个，%@价值%@元，评分%@分，专家免费给鉴定", self.model.reportGoodsName,self.model.originOrderPrice,[NSString stringWithFormat:@"%.2f",self.model.scoreAverage]];
        
        NSString *title = [NSString stringWithFormat:@"我在天天鉴宝买的%@，综合评分%.2f分。%@",self.model.reportGoodsName, self.model.scoreAverage, self.model.overshoot];
//        [[UMengManager shareInstance] showShareWithTarget:nil title:title text:ShareOrderReportText thumbUrl:nil webURL:[NSString stringWithFormat:@"%@id=%@",[UMengManager shareInstance].shareSaleReporterUrl,self.model.Id] type:ShareObjectTypeSaleReport object:self.model.Id];
        JHShareInfo* info = [JHShareInfo new];
        info.title = title;
        info.desc = ShareOrderReportText;
        info.shareType = ShareObjectTypeSaleReport;
        info.url = [NSString stringWithFormat:@"%@id=%@",[UMengManager shareInstance].shareSaleReporterUrl,self.model.Id];
        [JHBaseOperationView showShareView:info objectFlag:self.model.Id]; //TODO:Umeng share
    }
}
-(BOOL)isLgoin{
    
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result){
                
            }
        }];
        
        return  NO;
    }
    return  YES;
}

- (void)showBigImage {
    if (self.model.goodsUrl) {
        [[EnlargedImage sharedInstance] enlargedImage:self.orderCover enlargedTime:0.3 images:@[self.model.goodsUrl].mutableCopy andIndex:0 result:^(NSInteger index) {
            
        }];
        
    }

}

- (IBAction)helpAction:(id)sender {
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.titleString = @"鉴定说明";
    vc.urlString =H5_BASE_STRING(@"/jianhuo/baogaoinfo.html");
    [self.navigationController pushViewController:vc animated:YES];

}

@end
