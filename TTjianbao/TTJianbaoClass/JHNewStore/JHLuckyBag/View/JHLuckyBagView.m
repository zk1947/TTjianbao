//
//  JHLuckyBagView.m
//  TTjianbao
//
//  Created by zk on 2021/11/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLuckyBagView.h"
#import "UILabel+edgeInsets.h"
#import "JHRecycleCameraViewController.h"
#import "JHRecyclePhotoInfoModel.h"
#import "JHRecyclePhotoSeletedView.h"
#import "JHPickerView.h"
#import "JHLuckyBagRewardVC.h"
#import "JHLuckyBagRewardListView.h"
#import "JHMyCompeteCountdownView.h"
#import "CommAlertView.h"
#import "JHLuckyBagBusiniss.h"
#import "JHBrowserViewController.h"
#import "JHBrowserModel.h"
#import "JHAiyunOSSManager.h"
#import "JHEnvVariableDefine.h"
#import "MBProgressHUD.h"

@interface JHLuckyBagView ()<UITextFieldDelegate,UITextViewDelegate,STPickerSingleDelegate>

@property (nonatomic, assign) JHLuckyBagShowType showType;

@property(nonatomic,strong) UIButton *maskView;//遮罩
@property(nonatomic,strong) UIButton *closeBtn;//关闭按钮

@property(nonatomic,strong) UIView *headView;//头部
@property(nonatomic,strong) UIButton *tabBtn1;//福袋设置
@property(nonatomic,strong) UIButton *tabBtn2;//奖励列表
@property(nonatomic,strong) UIView *pageCtrl;//指示器
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property(nonatomic,strong) UIView *bagSetView;//福袋设置视图
@property(nonatomic,strong) UILabel *sExpLab;//已发数量
@property(nonatomic,strong) UIButton *sPhotoBtn;
@property(nonatomic, strong) NSMutableArray<JHRecyclePhotoSeletedView*> * imageViewArr;// 图片数组
@property (nonatomic, strong) UILabel *sTitExpLab;
@property(nonatomic,strong) UITextField *sTitTxtf;
@property(nonatomic,strong) UIButton *sGoodsClassBtn;
@property(nonatomic,strong) UILabel *sGoddsClassLab;
@property(nonatomic,strong) UITextField *sNumTxtf;
@property(nonatomic,strong) UILabel *sMaxNumLab;
@property(nonatomic,strong) UILabel *sTimeLab;
@property(nonatomic,strong) UIView *sPwdTxtV;
@property(nonatomic,strong) UITextView *sPwdTxtf;
@property(nonatomic,strong) UILabel *sPwdPlaceLab;
@property(nonatomic,strong) UILabel *sPwdNumLab;
@property(nonatomic,strong) UIButton *sSendBtn;
@property(nonatomic,strong) NSArray *pickerDataArray;//宝贝类别分组
@property (nonatomic, strong) JHPickerView *picker;
@property (nonatomic, strong) NSDictionary *selectedCate;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;
@property (nonatomic, strong) UILabel *sClassExpLab;
@property (nonatomic, strong) UILabel *sNumExpLab;
@property (nonatomic, strong) UILabel *sTimeExpLab;
@property (nonatomic, strong) UILabel *sPwdExpLab;

//查看UI
@property(nonatomic,strong) UIView *bagLookView;//福袋查看视图
@property(nonatomic,strong) UILabel *lExpLab;//已发数量
@property (nonatomic, strong) UIImageView *lGoodsImgV;
@property (nonatomic, strong) UILabel *lTitExpLab;
@property (nonatomic, strong) UILabel *lTitLab;
@property (nonatomic, strong) UILabel *lClassExpLab;
@property (nonatomic, strong) UILabel *lClassLab;
@property (nonatomic, strong) UILabel *lNumExpLab;
@property (nonatomic, strong) UILabel *lNumLab;
@property(nonatomic,strong) UILabel *lMaxNumLab;
@property (nonatomic, strong) UILabel *lTimeExpLab;
@property (nonatomic, strong) UILabel *lTimeLab;
@property (nonatomic, strong) UILabel *lPwdExpLab;
@property (nonatomic, strong) UILabel *lPwdTxtLab;
@property(nonatomic,strong) UIButton *lSendBtn;
@property (nonatomic, strong) JHMyCompeteCountdownView *countdownView; /// 倒计时视图
@property (nonatomic, strong) CommAlertView *downBagAlert;

@property (nonatomic, strong) UIView *listView;//奖励列表
@property (nonatomic, strong) JHLuckyBagRewardListView *luckListview;

@property (nonatomic, strong) JHLuckyBagModel *bagMsgModel;

@end

@implementation JHLuckyBagView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
        [self getCateAll];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    [self jh_cornerRadius:5];
    self.frame = CGRectMake(0, 0, 245, 536);
    self.center = [UIApplication sharedApplication].keyWindow.center;
    [self addSubview:self.headView];
    [self addSubview:self.bagSetView];
    [self addSubview:self.bagLookView];
    [self addSubview:self.listView];
}

- (UIView *)headView{
    if (!_headView) {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 50)];
        
        _tabBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _tabBtn1.frame = CGRectMake(self.width/2-80, 12, 75, 30);
        [_tabBtn1 setTitle:@"福袋设置" forState:UIControlStateNormal];
        [_tabBtn1 setTitleColor:kColor222 forState:UIControlStateNormal];
        _tabBtn1.titleLabel.font = JHMediumFont(15);
        [_tabBtn1 addTarget:self action:@selector(tabBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _tabBtn1.tag = 2021;
        [headView addSubview:_tabBtn1];
        
        _tabBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _tabBtn2.frame = CGRectMake(self.width/2+5, 12, 75, 30);
        [_tabBtn2 setTitle:@"奖励列表" forState:UIControlStateNormal];
        [_tabBtn2 setTitleColor:kColor666 forState:UIControlStateNormal];
        _tabBtn2.titleLabel.font = JHFont(15);
        [_tabBtn2 addTarget:self action:@selector(tabBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _tabBtn2.tag = 2022;
        [headView addSubview:_tabBtn2];
        
        _pageCtrl = [[UIView alloc]initWithFrame:CGRectMake(_tabBtn1.left+37.5, _tabBtn1.bottom-3, 15, 4)];
        [_pageCtrl jh_cornerRadius:2];
        [self addSubview:_pageCtrl];
        [self addGradualColor:_pageCtrl];
        
        _headView = headView;
    }
    return _headView;
}

- (void)tabBtnAction:(UIButton *)btn{
    if (btn.tag == 2021) {
        [self setInitUI];
    }else{
        [_tabBtn2 setTitleColor:kColor222 forState:UIControlStateNormal];
        _tabBtn2.titleLabel.font = JHMediumFont(15);
        [_tabBtn1 setTitleColor:kColor666 forState:UIControlStateNormal];
        _tabBtn1.titleLabel.font = JHFont(15);
        [UIView animateWithDuration:0.3 animations:^{
            _pageCtrl.left =_tabBtn2.left+30;
        }];
        //显示列表
        self.listView.hidden = NO;
        self.luckListview.pageIndex = 1;
        [self.luckListview loadData];
        self.bagSetView.hidden = YES;
    }
}

- (void)setInitUI{
    [_tabBtn1 setTitleColor:kColor222 forState:UIControlStateNormal];
    _tabBtn1.titleLabel.font = JHMediumFont(15);
    [_tabBtn2 setTitleColor:kColor666 forState:UIControlStateNormal];
    _tabBtn2.titleLabel.font = JHFont(15);
    [UIView animateWithDuration:0.3 animations:^{
        _pageCtrl.left =_tabBtn1.left+30;
    }];
    //显示列表
    self.listView.hidden = YES;
    if (self.showType == JHLuckyBagShowTypeSet) {
        self.bagSetView.hidden = NO;
        self.bagLookView.hidden = YES;
    }else{
        self.bagSetView.hidden = YES;
        self.bagLookView.hidden = NO;
    }
}

- (void)addGradualColor:(UIView *)view{
    if (!self.gradientLayer) {
        self.gradientLayer = [CAGradientLayer layer];
        self.gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xFEE100).CGColor, (__bridge id)HEXCOLOR(0xFFC242).CGColor];
        self.gradientLayer.startPoint = CGPointMake(0, 0);
        self.gradientLayer.endPoint = CGPointMake(0, 1.0);
        self.gradientLayer.frame = view.bounds;
        [view.layer addSublayer:self.gradientLayer];
    }
}

-(void)show{
    [self getBagMessageData];
}

- (void)addAlertToView{
    [[JHRootController currentViewController].view addSubview:self.maskView];
    [[JHRootController currentViewController].view addSubview:self];
    [[JHRootController currentViewController].view addSubview:self.closeBtn];
}

- (void)remove{
    [_maskView removeFromSuperview];
    [_closeBtn removeFromSuperview];
    [self removeFromSuperview];
}

- (void)removeKeyboard{
    [self endEditing:YES];
}

- (void)changeUIHeight:(CGFloat)height{
    if (height>0) {
        self.transform = CGAffineTransformMakeTranslation(0, -height);
        self.closeBtn.transform = CGAffineTransformMakeTranslation(0, -height);
    }else{
        self.transform = CGAffineTransformIdentity;
        self.closeBtn.transform = CGAffineTransformIdentity;
    }
}

- (UIView *)bagSetView{
    if (!_bagSetView) {
        UIView *bagSetView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.width, self.height-50)];
        
        //数量说明
        [bagSetView addSubview:self.sExpLab];
        [self.sExpLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(3);
            make.height.mas_equalTo(46);
        }];
        
        //选取照片
        [bagSetView addSubview:self.sPhotoBtn];
        [self.sPhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(_sExpLab.mas_bottom).offset(10);
            make.width.height.mas_equalTo(80);
        }];
        
        //福袋标题
        self.sTitExpLab = [self creatSetNomalLable:@"福袋标题"];
        [bagSetView addSubview:self.sTitExpLab];
        [self.sTitExpLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.sExpLab.mas_bottom).offset(100);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(60);
        }];
        
        [bagSetView addSubview:self.sTitTxtf];
        [self.sTitTxtf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.sTitExpLab.mas_right).offset(5);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(self.sTitExpLab.mas_top);
            make.height.mas_equalTo(18);
        }];

        self.line1 = [UIView new];
        self.line1.backgroundColor = kColorEEE;
        [bagSetView addSubview:self.line1];
        [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.sTitTxtf);
            make.top.mas_equalTo(self.sTitTxtf.mas_bottom).offset(7);
            make.height.mas_equalTo(1);
        }];
        
        //选择类别
        self.sClassExpLab = [self creatSetNomalLable:@"选择类别"];
        [bagSetView addSubview:self.sClassExpLab];
        [self.sClassExpLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.sTitExpLab.mas_bottom).offset(19);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(60);
        }];
        
        [bagSetView addSubview:self.sGoodsClassBtn];
        [self.sGoodsClassBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.sClassExpLab.mas_right).offset(5);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(self.sClassExpLab.mas_top);
            make.height.mas_equalTo(18);
        }];

        [self.sGoddsClassLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
        }];

        UIView *goodsClassImg = [self.sGoodsClassBtn viewWithTag:2021];
        [goodsClassImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-3));
            make.centerY.equalTo(self.sClassExpLab);
            make.width.equalTo(@5);
            make.height.equalTo(@10);
        }];

        self.line2 = [UIView new];
        self.line2.backgroundColor = kColorEEE;
        [bagSetView addSubview:self.line2];
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.sGoodsClassBtn);
            make.top.mas_equalTo(self.sGoodsClassBtn.mas_bottom).offset(7);
            make.height.mas_equalTo(1);
        }];
        
        //奖励个数
        self.sNumExpLab = [self creatSetNomalLable:@"奖励个数"];
        [bagSetView addSubview:self.sNumExpLab];
        [self.sNumExpLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.sClassExpLab.mas_bottom).offset(19);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(60);
        }];
        
        [bagSetView addSubview:self.sNumTxtf];
        [self.sNumTxtf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.sNumExpLab.mas_right).offset(5);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(self.sNumExpLab.mas_top);
            make.height.mas_equalTo(18);
        }];

        self.line3 = [UIView new];
        self.line3.backgroundColor = kColorEEE;
        [bagSetView addSubview:self.line3];
        [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.sNumTxtf);
            make.top.mas_equalTo(self.sNumTxtf.mas_bottom).offset(7);
            make.height.mas_equalTo(1);
        }];
        
        [bagSetView addSubview:self.sMaxNumLab];
        [self.sMaxNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.sNumExpLab.mas_bottom).offset(12);
            make.height.mas_equalTo(17);
        }];
        
        //福袋时间
        self.sTimeExpLab = [self creatSetNomalLable:@"福袋时间"];
        [bagSetView addSubview:self.sTimeExpLab];
        [self.sTimeExpLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.sMaxNumLab.mas_bottom).offset(10);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(60);
        }];
        
        self.sTimeLab = [self creatSetNomalLable:@"00:00"];
        [bagSetView addSubview:self.sTimeLab];
        [self.sTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.sTimeExpLab.mas_right).offset(5);
            make.top.mas_equalTo(self.sTimeExpLab);
            make.height.mas_equalTo(18);
        }];
        
        //参与口令
        self.sPwdExpLab = [self creatSetNomalLable:@"参与口令"];
        [bagSetView addSubview:self.sPwdExpLab];
        [self.sPwdExpLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.sTimeExpLab.mas_bottom).offset(10);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(60);
        }];
        
        [bagSetView addSubview:self.sPwdTxtV];
        [self.sPwdTxtV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(self.sPwdExpLab.mas_bottom).offset(10);
            make.height.mas_equalTo(71);
        }];

        [self.sPwdTxtV addSubview:self.sPwdTxtf];
        [self.sPwdTxtf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(5);
            make.right.bottom.mas_equalTo(-10);
        }];

        [self.sPwdTxtV addSubview:self.sPwdPlaceLab];
        [self.sPwdPlaceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(10);
            make.height.mas_equalTo(21);
        }];

        [self.sPwdTxtV addSubview:self.sPwdNumLab];
        [self.sPwdNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(-5);
            make.height.mas_equalTo(17);
        }];
        
        [bagSetView addSubview:self.sSendBtn];
        [self.sSendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-20);
            make.left.mas_equalTo(22);
            make.right.mas_equalTo(-22);
            make.height.mas_equalTo(35);
        }];
        
        _bagSetView = bagSetView;
    }
    return _bagSetView;
}

- (UIView *)bagLookView{
    if (!_bagLookView) {
        UIView *bagLookView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.width, self.height-50)];
                
        //数量说明
        [bagLookView addSubview:self.lExpLab];
        [self.lExpLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(3);
            make.height.mas_equalTo(46);
        }];
        
        //展示照片
        [bagLookView addSubview:self.lGoodsImgV];
        [self.lGoodsImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.lExpLab.mas_bottom).offset(10);
            make.width.height.mas_equalTo(80);
        }];
        
        //福袋标题
        self.lTitExpLab = [self creatSetNomalLable:@"福袋标题"];
        [bagLookView addSubview:self.lTitExpLab];
        [self.lTitExpLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.lExpLab.mas_bottom).offset(100);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(60);
        }];
        
        self.lTitLab = [self creatSetNomalLable:@"福袋标题"];
        self.lTitLab.numberOfLines = 0;
        [bagLookView addSubview:self.lTitLab];
        [self.lTitLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.lTitExpLab.mas_right).offset(5);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(self.lTitExpLab.mas_top);
        }];

        //选择类别
        self.lClassExpLab = [self creatSetNomalLable:@"选择类别"];
        [bagLookView addSubview:self.lClassExpLab];
        [self.lClassExpLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.lTitLab.mas_bottom).offset(10);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(60);
        }];

        self.lClassLab = [self creatSetNomalLable:@"选择类别"];
        [bagLookView addSubview:self.lClassLab];
        [self.lClassLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.lClassExpLab.mas_right).offset(5);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(self.lClassExpLab.mas_top);
            make.height.mas_equalTo(18);
        }];

        //奖励个数
        self.lNumExpLab = [self creatSetNomalLable:@"奖励个数"];
        [bagLookView addSubview:self.lNumExpLab];
        [self.lNumExpLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.lClassExpLab.mas_bottom).offset(10);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(60);
        }];

        self.lNumLab = [self creatSetNomalLable:@"奖励个数"];
        [bagLookView addSubview:self.lNumLab];
        [self.lNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.lNumExpLab.mas_right).offset(5);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(self.lNumExpLab.mas_top);
            make.height.mas_equalTo(18);
        }];

        [bagLookView addSubview:self.lMaxNumLab];
        [self.lMaxNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.lNumExpLab.mas_bottom).offset(10);
            make.height.mas_equalTo(17);
        }];

        //福袋时间
        self.lTimeExpLab = [self creatSetNomalLable:@"福袋时间"];
        [bagLookView addSubview:self.lTimeExpLab];
        [self.lTimeExpLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.lMaxNumLab.mas_bottom).offset(10);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(60);
        }];

        self.lTimeLab = [self creatSetNomalLable:@"00:00"];
        [bagLookView addSubview:self.lTimeLab];
        [self.lTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.lTimeExpLab.mas_right).offset(5);
            make.top.mas_equalTo(self.lTimeExpLab);
            make.height.mas_equalTo(18);
        }];

        //参与口令
        self.lPwdExpLab = [self creatSetNomalLable:@"参与口令"];
        [bagLookView addSubview:self.lPwdExpLab];
        [self.lPwdExpLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.lTimeExpLab.mas_bottom).offset(10);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(60);
        }];

        self.lPwdTxtLab = [self creatSetNomalLable:@"参与口令"];
        self.lPwdTxtLab.numberOfLines = 0;
        [bagLookView addSubview:self.lPwdTxtLab];
        [self.lPwdTxtLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.lPwdExpLab.mas_right).offset(5);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(self.lPwdExpLab.mas_top);
        }];

        [bagLookView addSubview:self.lSendBtn];
        [self.lSendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lPwdTxtLab.mas_bottom).offset(20);
            make.left.mas_equalTo(22);
            make.right.mas_equalTo(-22);
            make.height.mas_equalTo(35);
        }];

        [bagLookView addSubview:self.countdownView];
        [self.countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-20);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(18);
        }];
            
        _bagLookView = bagLookView;
    }
    return _bagLookView;
}

#pragma mark -照片选取
- (void)photoBtnAction:(UIButton *)btn{
    [self endEditing:YES];
    JHRecycleCameraViewController *vc = [[JHRecycleCameraViewController alloc] init];
    vc.allowCrop = NO;
    vc.showTitle = @"商品图片";
    vc.examImageUrl = @"abc";
    vc.allowTakePhone = YES;
    vc.allowRecordVideo = NO;
    vc.maximum = 1;
    @weakify(self);
    [vc.assetHandle subscribeNext:^(NSArray<JHRecycleTemplateImageModel *> * _Nullable x) {
        @strongify(self);
        [self refreshWithTemplateImageModelArr:x];
    }];
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:true];
}

- (void)refreshWithTemplateImageModelArr:(NSArray<JHRecycleTemplateImageModel *> *)modelArr{
    NSArray<JHRecyclePhotoInfoModel*>* photoModelArr = [modelArr jh_map:^id _Nonnull(JHRecycleTemplateImageModel * _Nonnull obj, NSUInteger idx) {
        if (obj.asset) {
            return [JHRecyclePhotoInfoModel photoInfoModelWithTempModel:obj];
        }
        return nil;
    }];
    [self addProductDetailPictureWithModelArr:photoModelArr];
}

- (void)addProductDetailPictureWithModelArr:(NSArray<JHRecyclePhotoInfoModel *> *)modelArr{
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i = 0; i< modelArr.count; i++) {
            JHRecyclePhotoInfoModel *model = modelArr[i];
            JHRecyclePhotoSeletedView *imageView = [[JHRecyclePhotoSeletedView alloc] init];
            imageView.model = model;
            @weakify(self);
            [imageView setDeleteBlock:^(JHRecyclePhotoSeletedView * _Nonnull photoView) {
                @strongify(self);
                [self removePictureView:photoView];
            }];
            //添加图片预览
//            imageView.tapImageBlock = ^(JHRecyclePhotoSeletedView * _Nonnull photoView) {
//                JHBrowserModel *model = [[JHBrowserModel alloc] init];
//                model.image = photoView.model.originalImage;
//                [JHBrowserViewController showBrowser:@[model] currentIndex:0 from:[JHRootController currentViewController]];
//            };
            [self.bagSetView addSubview:imageView];
            [self.imageViewArr addObject:imageView];
        }
        [self layoutItems];
    });
}

- (void)removePictureView:(JHRecyclePhotoSeletedView*)photoView{
    [photoView removeFromSuperview];
    [self.imageViewArr removeObject:photoView];
    [self layoutItems];
}

- (void)layoutItems{
    for (int i = 0; i<self.imageViewArr.count; i++) {
        JHRecyclePhotoSeletedView *imageView = self.imageViewArr[i];
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.sPhotoBtn);
        }];
    }
}

#pragma mark - 商品类别
- (void)goodsClassBtn:(UIButton *)btn{
    [self endEditing:YES];
    [self.picker show];
}

- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    if (![pickerSingle isKindOfClass:[JHPickerView class]]) {
        return;
    }
    NSInteger index = pickerSingle.selectedIndex;
    if (self.pickerDataArray && self.pickerDataArray.count>index) {
        self.selectedCate = self.pickerDataArray[index];
        self.sGoddsClassLab.text = self.selectedCate[@"name"];
        self.sGoddsClassLab.textColor = kColor333;
    }
}

#pragma mark - UITextField输入限制
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 2021) {//长度最多30
        if (textField.text.length + string.length > 30) {
            return NO;
        }
    }else if(textField.tag == 2022){//不能以0或小数点开头，并且不能输入小数且长度小于8位
        if (textField.text.length == 0 && [string isEqualToString:@"."]) {
            return NO;
        }
        if (textField.text.length == 0 && [string isEqualToString:@"0"]) {
            return NO;
        }
        NSString *tmpString = [textField.text stringByAppendingString:string];
        if (![self isNum:tmpString] && string.length){
            return NO;
        }
        if (textField.text.length + string.length > 8) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

#pragma mark  -UITextView输入框代理
-(void)textViewDidChange:(UITextView *)textView{
    _sPwdPlaceLab.hidden = textView.text.length == 0 ? NO : YES;
    _sPwdNumLab.text = [NSString stringWithFormat:@"%ld/20",textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length == 0) return YES;
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    if (existedLength - selectedLength + replaceLength > 20) {
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self changeUIHeight:230];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self changeUIHeight:0];
}

#pragma mark -发放福袋
- (void)sSendBtnAction:(UIButton *)btn{
    if (self.showType == JHLuckyBagShowTypeSet) {
        [self sendLuckyBagOne];
    }else if (self.showType == JHLuckyBagShowTypeShow){
        [self downLuckyBag];
    }
}

- (void)sendLuckyBagOne{
    //依次效验 请上传商品图片’/‘请输入商品标题’/‘请选择类别’/‘请输入奖励个数’/‘请输入参与口令
    if (self.imageViewArr.count == 0) {
        JHTOAST(@"请上传商品图片");
        return;
    }
    if (self.sTitTxtf.text.length <= 0) {
        JHTOAST(@"请输入商品标题");
        return;
    }
    if ([self.sGoddsClassLab.text isEqualToString:@"请选择宝贝类别"]) {
        JHTOAST(@"请选择类别");
        return;
    }
    if (self.sNumTxtf.text.length <= 0) {
        JHTOAST(@"请输入奖励个数");
        return;
    }
    if (self.sPwdTxtf.text.length <= 0) {
        JHTOAST(@"请输入参与口令");
        return;
    }
    @weakify(self);
    [self upLoadImage:^(BOOL isFinished, NSString *imgUrl) {
        @strongify(self);
        if (isFinished) {
            [self sendLuckyBagTow:imgUrl];
        }else{
            JHTOAST(@"图片上传失败");
        }
    }];
}

- (void)sendLuckyBagTow:(NSString *)imgUrl{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.sPwdTxtf.text forKey:@"bagKey"];
    [param setObject:self.sTitTxtf.text forKey:@"bagTitle"];
    int num = [self.sNumTxtf.text intValue];
    [param setObject:@(num) forKey:@"prizeNumber"];
    [param setObject:self.selectedCate[@"name"] forKey:@"productCateName"];
    [param setObject:self.selectedCate[@"newGoodsCateId"] forKey:@"newProductCateId"];
    [param setObject:self.selectedCate[@"id"] forKey:@"productCateId"];
    NSString *allImgStr = [NSString stringWithFormat:@"%@/%@",[JHEnvVariableDefine aliyuncsBaseUrl],imgUrl];
    [param setObject:allImgStr forKey:@"imgUrl"];
    if (self.bagMsgModel) {
        [param setObject:@(self.bagMsgModel.platformBagConfig.ID) forKey:@"configId"];
        [param setObject:@(self.bagMsgModel.platformBagConfig.countdownSeconds) forKey:@"countdownSeconds"];
    }
    @weakify(self);
    [JHLuckyBagBusiniss sendLuckyBagData:param completion:^(NSError * _Nullable error, BOOL success, NSString * _Nullable message) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self animated:YES];
        if (!error) {
            JHTOAST(message);
            [self remove];
        }else{
            JHTOAST(error.localizedDescription);
        }
    }];
}

///上传图片
- (void)upLoadImage:(void(^)(BOOL isFinished,NSString *imgUrl))resultBlock{
    NSArray<UIImage *> *array = [self.imageViewArr jh_map:^id _Nonnull(JHRecyclePhotoSeletedView * _Nonnull obj, NSUInteger idx) {
        return obj.model.originalImage;
    }];
    [[JHAiyunOSSManager shareInstance] uopladImage:array finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
        if (isFinished) {
            if (resultBlock) {
                resultBlock(YES,imgKeys[0]);
            }
        }else{
            if (resultBlock) {
                resultBlock(NO,@"");
            }
        }
    }];
}

///下架福袋
- (void)downLuckyBag{
    [self.downBagAlert show];
}

- (void)loadDownAction{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(self.bagMsgModel.sellerBagConfig.ID) forKey:@"id"];
    @weakify(self);
    [JHLuckyBagBusiniss downLuckyBagData:param completion:^(NSError * _Nullable error, NSString * _Nullable message) {
        @strongify(self);
        if (!error) {
            JHTOAST(@"下架成功");
            [self remove];
        }else{
            JHTOAST(error.localizedDescription);
        }
    }];
}

- (UIView *)listView{
    if (!_listView) {
        UIView *listView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.width, self.height-50)];
        listView.hidden = YES;
                
        self.luckListview = [[JHLuckyBagRewardListView alloc]init];
        self.luckListview.isOnAlert = YES;
        [listView addSubview:self.luckListview];
        [self.luckListview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(@(0));
        }];
        
        _listView = listView;
    }
    return _listView;
}

#pragma mark - Lazy load Methods：

- (UIButton *)maskView{
    if (!_maskView) {
        UIButton *maskView = [UIButton buttonWithType:UIButtonTypeCustom];
        maskView.frame = [UIScreen mainScreen].bounds;
        maskView.alpha = 0.5;
        maskView.backgroundColor = [UIColor blackColor];
        [maskView addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventTouchUpInside];
        _maskView = maskView;
    }
    return _maskView;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(self.right-14, self.top-14, 28, 28);
        closeBtn.backgroundColor = kColor333;
        [closeBtn jh_cornerRadius:14];
        [closeBtn setImage:JHImageNamed(@"icon_alert_close") forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn = closeBtn;
    }
    return _closeBtn;
}

- (UIButton *)sPhotoBtn{
    if (!_sPhotoBtn) {
        UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [photoBtn addTarget:self action:@selector(photoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        photoBtn.backgroundColor = HEXCOLOR(0xF9F9F9);
        photoBtn.layer.cornerRadius = 5;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.image = [UIImage imageNamed:@"recycle_uploadproduct_addblcak"];
        UILabel *label = [[UILabel alloc] init];
        label.font = JHFont(12);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = HEXCOLOR(0x999999);
        label.text = @"图片";
        [photoBtn addSubview:label];
        [photoBtn addSubview:imageView];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(3);
            make.centerX.equalTo(@0);
        }];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0).offset(16);
            make.centerX.equalTo(@0);
        }];
        
        _sPhotoBtn = photoBtn;
    }
    return _sPhotoBtn;
}

- (UILabel *)sExpLab{
    if (!_sExpLab) {
        UILabel *setExpLab = [[UILabel alloc]init];
        setExpLab.backgroundColor = HEXCOLOR(0xFEFBE9);
        setExpLab.text = @"今日已发福袋数量：50；每日福袋上限：100";
        setExpLab.font = JHFont(12);
        setExpLab.textColor = kColor666;
        setExpLab.numberOfLines = 0;
        setExpLab.edgeInsets = UIEdgeInsetsMake(6, 8, 6, 8);
        [setExpLab jh_cornerRadius:4];
        _sExpLab = setExpLab;
    }
    return _sExpLab;
}

- (UILabel *)lExpLab{
    if (!_lExpLab) {
        UILabel *setExpLab = [[UILabel alloc]init];
        setExpLab.backgroundColor = HEXCOLOR(0xFEFBE9);
        setExpLab.text = @"今日已发福袋数量：50；每日福袋上限：100";
        setExpLab.font = JHFont(12);
        setExpLab.textColor = kColor666;
        setExpLab.numberOfLines = 0;
        setExpLab.edgeInsets = UIEdgeInsetsMake(6, 8, 6, 8);
        [setExpLab jh_cornerRadius:4];
        _lExpLab = setExpLab;
    }
    return _lExpLab;
}

- (UITextField *)sTitTxtf{
    if (!_sTitTxtf) {
        UITextField *txtf = [[UITextField alloc]init];
        txtf.font = JHFont(13);
        txtf.textColor = kColor333;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请输入文字描述" attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x999999)}];
        txtf.attributedPlaceholder = attrString;
        txtf.delegate = self;
        txtf.tag = 2021;
        _sTitTxtf = txtf;
    }
    return _sTitTxtf;
}

- (UITextField *)sNumTxtf{
    if (!_sNumTxtf) {
        UITextField *txtf = [[UITextField alloc]init];
        txtf.font = JHFont(13);
        txtf.textColor = kColor333;
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"输入福袋奖品数量" attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x999999)}];
        txtf.attributedPlaceholder = attrString;
        txtf.delegate = self;
        txtf.keyboardType = UIKeyboardTypeNumberPad;
        txtf.tag = 2022;
        _sNumTxtf = txtf;
    }
    return _sNumTxtf;
}

- (UIButton *)sGoodsClassBtn{
    if (!_sGoodsClassBtn) {
        UIButton *goodsClassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [goodsClassBtn addTarget:self action:@selector(goodsClassBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = JHFont(13);
        label.textColor = HEXCOLOR(0x999999);
        label.text = @"请选择宝贝类别";
        [goodsClassBtn addSubview:label];
        self.sGoddsClassLab = label;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"appraise_pay_jiantou"];
        imageView.tag = 2021;
        [goodsClassBtn addSubview:imageView];
        
        _sGoodsClassBtn = goodsClassBtn;
    }
    return _sGoodsClassBtn;
}

- (UILabel *)creatSetNomalLable:(NSString *)content{
    UILabel *lab = [UILabel new];
    lab.text = content;
    lab.textColor = kColor333;
    lab.font = JHFont(13);
    return lab;
}

- (UILabel *)sMaxNumLab{
    if (!_sMaxNumLab) {
        UILabel *maxNumLab = [[UILabel alloc]init];
        maxNumLab.text = @"注：每个福袋奖励个数上限为x";
        maxNumLab.font = JHFont(12);
        maxNumLab.textColor = HEXCOLOR(0xFF4200);
        _sMaxNumLab = maxNumLab;
    }
    return _sMaxNumLab;
}

- (UILabel *)lMaxNumLab{
    if (!_lMaxNumLab) {
        UILabel *maxNumLab = [[UILabel alloc]init];
        maxNumLab.text = @"注：每个福袋奖励个数上限为x";
        maxNumLab.font = JHFont(12);
        maxNumLab.textColor = HEXCOLOR(0x999999);
        _lMaxNumLab = maxNumLab;
    }
    return _lMaxNumLab;
}

- (UIView *)sPwdTxtV{
    if (!_sPwdTxtV) {
        UIView *sPwdTxtV = [[UIView alloc]init];
        sPwdTxtV.backgroundColor = HEXCOLOR(0xFAFAFA);
        [sPwdTxtV jh_cornerRadius:5];
        _sPwdTxtV = sPwdTxtV;
        
        _sPwdTxtf = [[UITextView alloc]init];
        _sPwdTxtf.backgroundColor = HEXCOLOR(0xFAFAFA);
        _sPwdTxtf.delegate = self;
        _sPwdTxtf.textColor = kColor333;
        _sPwdTxtf.font = JHFont(12);
        
        //提示文字
        _sPwdPlaceLab = [[UILabel alloc]init];
        _sPwdPlaceLab.enabled = NO;
        _sPwdPlaceLab.text = @"请填写参与口令，20字以内";
        _sPwdPlaceLab.textColor = HEXCOLOR(0xBBBBBB);
        _sPwdPlaceLab.font = JHFont(12);
        
        //字数显示
        _sPwdNumLab = [[UILabel alloc]init];
        _sPwdNumLab.text = @"0/20";
        _sPwdNumLab.textColor = HEXCOLOR(0xCCCCCC);;
        _sPwdNumLab.font = JHFont(12);
        _sPwdNumLab.textAlignment = NSTextAlignmentRight;
    }
    return _sPwdTxtV;
}

- (UIButton *)sSendBtn{
    if (!_sSendBtn) {
        UIButton *sSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sSendBtn addTarget:self action:@selector(sSendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        sSendBtn.backgroundColor = HEXCOLOR(0xFEE100);
        [sSendBtn jh_cornerRadius:17.5];
        [sSendBtn setTitle:@"发放福袋" forState:UIControlStateNormal];
        [sSendBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        sSendBtn.titleLabel.font = JHFont(13);
        _sSendBtn = sSendBtn;
    }
    return _sSendBtn;
}

- (UIButton *)lSendBtn{
    if (!_lSendBtn) {
        UIButton *sSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sSendBtn addTarget:self action:@selector(sSendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        sSendBtn.backgroundColor = HEXCOLOR(0xFEE100);
        [sSendBtn jh_cornerRadius:17.5];
        [sSendBtn setTitle:@"下架" forState:UIControlStateNormal];
        [sSendBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        sSendBtn.titleLabel.font = JHFont(13);
        _lSendBtn = sSendBtn;
    }
    return _lSendBtn;
}

- (JHPickerView *)picker {
    if (!_picker) {
        _picker = [[JHPickerView alloc] init];
        _picker.widthPickerComponent = 300;
        _picker.heightPicker = 240 + UI.bottomSafeAreaHeight;
        [_picker setDelegate:self];
    }
    return _picker;
}

- (UIImageView *)lGoodsImgV{
    if (!_lGoodsImgV) {
        UIImageView *imgv = [UIImageView new];
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.clipsToBounds = YES;
        [imgv jh_cornerRadius:4];
        imgv.image = JHImageNamed(@"newStore_detail_shopProduct_Placeholder");
        _lGoodsImgV = imgv;
    }
    return _lGoodsImgV;
}

- (JHMyCompeteCountdownView *)countdownView{
    if (!_countdownView) {
        _countdownView = [[JHMyCompeteCountdownView alloc]init];
        [_countdownView changeTextAttribute:JHFont(13) color:HEXCOLOR(0xFF4200) bgColor:[UIColor clearColor]];
    }
    return _countdownView;
}

- (CommAlertView *)downBagAlert{
    if (!_downBagAlert) {
        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"下架后，用户将不能参与此福袋活动，请确认操作" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
        @weakify(self);
        alert.handle = ^{
            @strongify(self);
            [self loadDownAction];
        };
        _downBagAlert = alert;
    }
    return _downBagAlert;
}

- (NSMutableArray<JHRecyclePhotoSeletedView *> *)imageViewArr{
    if (!_imageViewArr) {
        _imageViewArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageViewArr;
}

#pragma mark -获取宝贝类别
- (void)getCateAll {
    if ([UserInfoRequestManager sharedInstance].feidanPickerDataArray) {
        self.pickerDataArray = [UserInfoRequestManager sharedInstance].feidanPickerDataArray;
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in self.pickerDataArray) {
            [array addObject:dic[@"name"]];
        }
        self.picker.arrayData = array;
        return;
    }
    [[UserInfoRequestManager sharedInstance] getNewFlyOrder_successBlock:^(RequestModel * _Nullable respondObject) {
       self.pickerDataArray = respondObject.data;
       NSMutableArray *array = [NSMutableArray array];
       for (NSDictionary *dic in self.pickerDataArray) {
           [array addObject:dic[@"name"]];
       }
       self.picker.arrayData = array;
       [UserInfoRequestManager sharedInstance].feidanPickerDataArray = respondObject.data;
    } failureBlock:^(RequestModel * _Nullable respondObject) {}];
}

#pragma mark -获取商家福袋信息
- (void)getBagMessageData{
    @weakify(self);
    [JHLuckyBagBusiniss loadLuckyBagMsgData:^(NSError * _Nullable error, JHLuckyBagModel * _Nullable model) {
        @strongify(self);
        if (!error) {
            self.bagMsgModel = model;
            self.showType = self.bagMsgModel.sellerBagConfig ? JHLuckyBagShowTypeShow : JHLuckyBagShowTypeSet;
            [self reloadBagDataAndUI];
            [self addAlertToView];
        }else {
            JHTOAST(error.localizedDescription);
            [self remove];
        }
    }];
}

#pragma mark -刷新UI数据
- (void)reloadBagDataAndUI{
    [self setInitUI];
    if (self.showType == JHLuckyBagShowTypeSet) {
        self.bagSetView.hidden = NO;
        self.bagLookView.hidden = YES;
        [self reloadSetData];
    }else{
        self.bagSetView.hidden = YES;
        self.bagLookView.hidden = NO;
        [self reloadLookData];
    }
    self.closeBtn.frame = CGRectMake(self.right-14, self.top-14, 28, 28);
}

- (void)reloadSetData{
    self.height = 536;
    self.center = [UIApplication sharedApplication].keyWindow.center;
    self.bagSetView.height = self.height-50;
    self.sExpLab.text = [NSString stringWithFormat:@"今日已发福袋数量：%d；每日福袋上限：%d",self.bagMsgModel.todayBagCount,self.bagMsgModel.platformBagConfig.dayBagMax];
    if (self.imageViewArr>0) {
        JHRecyclePhotoSeletedView *imageView = self.imageViewArr[0];
        [imageView removeFromSuperview];
        [self.imageViewArr removeObject:imageView];
    }
    self.sTitTxtf.text = @"";
    self.sGoddsClassLab.text = @"请选择宝贝类别";
    self.sGoddsClassLab.textColor = HEXCOLOR(0x999999);
    UIView *goodsClassImg = [self.sGoodsClassBtn viewWithTag:2021];
    goodsClassImg.hidden = NO;
    self.sNumTxtf.text = @"";
    self.sMaxNumLab.text = [NSString stringWithFormat:@"注：每个福袋奖励个数上限为%d",self.bagMsgModel.platformBagConfig.bagPrizeMax];
    self.sTimeLab.text = [self getMMSSFromSS:self.bagMsgModel.platformBagConfig.countdownSeconds];
    self.sPwdTxtf.text = @"";
    self.sPwdNumLab.text = @"0/20";
    self.sPwdPlaceLab.hidden = NO;
}

- (void)reloadLookData{
    //标题高度
    CGSize titSize = [self.bagMsgModel.sellerBagConfig.bagTitle boundingRectWithSize:CGSizeMake(self.width-83, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:JHFont(13)} context:nil].size;
    CGFloat titlabH = titSize.height > 20 ? titSize.height : 18;
    //口令高度
    CGSize keySize = [self.bagMsgModel.sellerBagConfig.bagKey boundingRectWithSize:CGSizeMake(self.width-83, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:JHFont(13)} context:nil].size;
    CGFloat keylabH = keySize.height > 20 ? keySize.height : 18;
    self.height = 430 + titlabH + keylabH;
    self.center = [UIApplication sharedApplication].keyWindow.center;
    self.bagLookView.height = self.height-50;
    self.lExpLab.text = [NSString stringWithFormat:@"今日已发福袋数量：%d；每日福袋上限：%d",self.bagMsgModel.todayBagCount,self.bagMsgModel.platformBagConfig.dayBagMax];
    [self.lGoodsImgV jhSetImageWithURL:[NSURL URLWithString:self.bagMsgModel.sellerBagConfig.imgUrl] placeholder:JHImageNamed(@"newStore_detail_shopProduct_Placeholder")];
    self.lTitLab.text = self.bagMsgModel.sellerBagConfig.bagTitle;
    self.lClassLab.text = self.bagMsgModel.sellerBagConfig.productCateName;
    self.lNumLab.text = [NSString stringWithFormat:@"%d",self.bagMsgModel.sellerBagConfig.prizeNumber];
    self.lMaxNumLab.text = [NSString stringWithFormat:@"注：每个福袋奖励个数上限为%d",self.bagMsgModel.platformBagConfig.bagPrizeMax];
    self.lTimeLab.text = [self getMMSSFromSS:self.bagMsgModel.platformBagConfig.countdownSeconds];
    self.lPwdTxtLab.text = self.bagMsgModel.sellerBagConfig.bagKey;
    @weakify(self);
    [self.countdownView setSecandData:self.bagMsgModel.sellerBagConfig.lastCountDownSeconds expString:@"福袋进行中 " completion:^(BOOL finished) {
        @strongify(self);
        JHTOAST(@"福袋活动已结束");
        [self remove];
    }];
}

//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSSFromSS:(int)seconds{
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%d",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%d",seconds%60];
    
    //不足两位补0
    NSString *minuteStr = str_minute.length < 2 ? [NSString stringWithFormat:@"0%@",str_minute]:str_minute;
    NSString *secondStr = str_second.length < 2 ? [NSString stringWithFormat:@"0%@",str_second]:str_second;
    
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",minuteStr,secondStr];
    return format_time;
}

@end
