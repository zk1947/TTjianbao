//
//  JH99FreeViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JH99FreeViewController.h"
#import "JH99FreeGoodsInfoView.h"
#import "YYKit/YYKit.h"
#import "JHStoreHomeCardModel.h"
#import "YDCountDown.h"
#import "JHShopWindowPageController.h"
#import "JH99FreeModel.h"
#import "JHAppAlertViewManger.h"
#import "JHStoreHomeCardModel.h"

@interface JH99FreeViewController ()
///99包邮背景图
@property (nonatomic, strong) YYAnimatedImageView *bgImageView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) YDCountDown *countDown;
@property (nonatomic, strong) UILabel *timeTipLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *enterButton;

@end

@implementation JH99FreeViewController
-(void)dealloc
{
    [JHAppAlertViewManger appAlertshowing:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLORA(0x000000, .4f);
    [self setupUI];
    [self loadData:nil];
    [JHAppAlertViewManger appAlertshowing:YES];
}

- (void)setupUI {
    if (!_countDown) {
        _countDown = [[YDCountDown alloc] init];
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bg_99_free" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    YYImage *image = [YYImage imageWithData:data];
    _bgImageView = [[YYAnimatedImageView alloc] initWithImage:image];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    _bgImageView.userInteractionEnabled = YES;
    [self.view addSubview:_bgImageView];
    
    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterButton addTarget:self action:@selector(handleEnterButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    _enterButton = enterButton;
    [_bgImageView addSubview:enterButton];

    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"距结束仅剩";
    tipLabel.font = [UIFont fontWithName:kFontNormal size:11.f];
    tipLabel.textColor  = kColor333;
    [self.view addSubview:tipLabel];
    _timeTipLabel = tipLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"00:00:00";
    timeLabel.font = [UIFont fontWithName:kFontMedium size:11.f];
    timeLabel.textColor  = kColorFF4200;
    [self.view addSubview:timeLabel];
    _timeLabel = timeLabel;

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"icon_pop_cancel"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(handleCancelEvent) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton = cancelButton;
    [self.view addSubview:cancelButton];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(270, 322));
    }];
    
    [_enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bgImageView).offset(53);
        make.trailing.equalTo(self.bgImageView).offset(43);
        make.bottom.equalTo(self.bgImageView).offset(-20);
        make.height.mas_equalTo(45);
    }];
    
    [_timeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView).offset(78);
        make.top.equalTo(self.bgImageView).offset(206);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeTipLabel.mas_right).offset(5);
        make.centerY.equalTo(self.timeTipLabel);
        make.width.mas_equalTo(50);
    }];
        
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgImageView.mas_top).offset(-15);
        make.centerX.equalTo(self.bgImageView.mas_right);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    ///判断商品信息是否为空 不为空配置商品信息view
    [self showGoodsInfoView];
}

- (void)showGoodsInfoView {
    ///商品信息处理
    if (self.freeModel.goodsList.count > 0) {
        [self configGoodsInfoView];
    }
}

+ (void)get99FreeInfo {
    if ([CommHelp isFirstForName:k99FreeEnterForeGroundShow]) {
        [[self alloc] loadData:^(JH99FreeModel *freeModel) {
            if (freeModel.is_pop) {
                ///当is_pop值为1时需要弹出99包邮的弹窗
                JHAppAlertModel *model = [JHAppAlertModel new];
                model.type = JHAppAlertType99Free;
                model.localType = JHAppAlertLocalTypeHome;
                model.typeName = AppAlertName99Free;
                model.body = freeModel;
                [JHAppAlertViewManger addModelArray:@[model]];
            }
        }];
    }
}

- (void)loadData:(void(^)(JH99FreeModel *cardInfo))block {
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v2/shop/new_user_pop");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        NSLog(@"respondObject:--- %@", respondObject);
        if (respondObject.data) {
            JH99FreeModel *model = [[JH99FreeModel alloc] initWith99FreeInfo:respondObject];
            if (block) {
                block(model);
            }
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
//        NSLog(@"respondObject:--- %@", respondObject);
    }];
}

- (void)configGoodsInfoView {
    CGFloat space = 40.f;
    CGFloat width = 90.f;
    CGFloat height = (width + 25.f);
    if (self.freeModel.goodsList.count == 1) {
        JHGoodsInfoMode *goods = [self.freeModel.goodsList firstObject];
        JH99FreeGoodsInfoView *goodsView = [[JH99FreeGoodsInfoView alloc] initWithFrame:CGRectZero GoodsInfo:goods];
        [_bgImageView addSubview:goodsView];
        [goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgImageView.mas_centerX);
            make.top.equalTo(self.bgImageView).offset(80);
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
    }
    else {
        [self.freeModel.goodsList enumerateObjectsUsingBlock:^(JHGoodsInfoMode * _Nonnull goods, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < 2) {
                JH99FreeGoodsInfoView *goodsView = [[JH99FreeGoodsInfoView alloc] initWithFrame:CGRectZero GoodsInfo:goods];
                [_bgImageView addSubview:goodsView];
                [goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.bgImageView).offset(space+(width+10)*idx);
                    make.top.equalTo(self.bgImageView).offset(80);
                    make.size.mas_equalTo(CGSizeMake(width, height));
                }];
            }
            else {
                *stop = YES;
            }
        }];
    }
    ///开始倒计时
    [self handleCountdownEvent];
}

- (void)handleEnterButtonEvent {
    NSLog(@"handleEnterButtonEvent");
    [self dismissViewControllerAnimated:NO completion:^{
        JHShopWindowPageController *vc = [[JHShopWindowPageController alloc] init];
        vc.showcaseId = self.freeModel.showcaseInfo.sc_id;
        vc.showcaseName = self.freeModel.showcaseInfo.name;
        [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)handleCancelEvent {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)handleCountdownEvent {
    ///倒计时
    @weakify(self);
    [_countDown startWithbeginTimeStamp:self.freeModel.server_time
                        finishTimeStamp:self.freeModel.finish_time
                          completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        @strongify(self);
        self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hour, (long)minute, (long)second];
        if (day == 0 && hour == 0 && minute == 0 && second == 0) {
            ///倒计时结束 秒杀开始
            [self.countDown destoryTimer];
        }
    }];
}


@end
