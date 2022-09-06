//
//  JHLiveRoomPKView.m
//  TTjianbao
//
//  Created by apple on 2020/8/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomPKView.h"
#import "JHLiveRoomPKModel.h"
#import "JHLiveRoomPKHeaderView.h"
#import "JHLiveRoomPKTableHeaderView.h"
#import "JHRankingTableViewCell.h"
#import "JHLiveRoomPKBottomView.h"
#import "JHLiveStoreView.h"
#import "ChannelMode.h"
#import "NTESAudienceLiveViewController.h"
#import "JHRouterManager.h"
#import "JHUIFactory.h"

@interface JHLiveRoomPKView ()<UITableViewDelegate,UITableViewDataSource,JHLiveRoomPKHeaderViewDelegate,UIGestureRecognizerDelegate,JHLiveRoomPKBottomViewDelegate>
@property (nonatomic,strong)JHLiveRoomPKModel *pkModel;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)JHLiveRoomPKHeaderView *headerView;
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UITableView *tableView2;

@property (nonatomic,strong)UITableView *tableView3;

@property (nonatomic,strong)JHLiveRoomPKBottomView *bottomView;
@property (nonatomic,strong)NSMutableArray *categoryTitleArray;
@property (nonatomic,strong)NSMutableArray *categoryTypeArray;
/**
 * JHAudienceUserRoleType
 * 0 直播鉴定 1 直播卖货 2卖货助理 主播
 */
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString * channelId;

@property (nonatomic, copy) NSString * currentCategory;
@end

@implementation JHLiveRoomPKView
- (instancetype)initWithFrame:(CGRect)frame andType:(NSInteger)type andchannelId:(NSString *)channelId{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.type = type;
        self.channelId = channelId;
        UITapGestureRecognizer * tapgest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTapAction:)];
        tapgest.delegate = self;
        [self addGestureRecognizer:tapgest];
        
        [self requestData];
    }
    return self;
}

- (void)creatUI{
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.3*ScreenH+20, ScreenW, ScreenH*0.7-20)];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgView];
    
    self.headerView = [[JHLiveRoomPKHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50) andType:self.type];
    self.headerView.delegate = self;
    [self.bgView addSubview:self.headerView];
   
    self.bottomView = [[JHLiveRoomPKBottomView alloc] init];
    self.bottomView.delegate = self;
    [self.bgView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(70+UI.bottomSafeAreaHeight);
    }];
}
- (void)creatTableView:(NSString*)type{
    float height = 205;
    BOOL isShowUser = YES;
    if (![JHRootController isLogin] || self.type == 2 || [type isEqualToString:@"fansRanking"]) {
        height = 179;
        isShowUser = NO;
    }
    if ([type isEqualToString:@"summaryRanking"]) {
         [self.bgView addSubview:self.tableView];
           
           [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.mas_equalTo(self.headerView.mas_bottom);
               make.left.right.mas_equalTo(0);
               make.bottom.mas_equalTo(self.bottomView.mas_top);
           }];
        JHLiveRoomPKTableHeaderView * headerView = [[JHLiveRoomPKTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height) andModel:self.pkModel andType:@"summaryRanking" andIsShowUserInfo:isShowUser];
        JH_WEAK(self);
        headerView.headerClickBlock = ^(NSString * _Nonnull roomId) {
            JH_STRONG(self);
            [self gotoLiveRoom:roomId];
        };
           self.tableView.tableHeaderView = headerView;
           
    }else if ([type isEqualToString:@"increaseRanking"]) {
         [self.bgView addSubview:self.tableView2];
           
           [self.tableView2 mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.mas_equalTo(self.headerView.mas_bottom);
               make.left.right.mas_equalTo(0);
               make.bottom.mas_equalTo(self.bottomView.mas_top);
           }];
        
           JHLiveRoomPKTableHeaderView * headerView2 = [[JHLiveRoomPKTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height) andModel:self.pkModel andType:@"increaseRanking" andIsShowUserInfo:isShowUser];
            JH_WEAK(self);
            headerView2.headerClickBlock = ^(NSString * _Nonnull roomId) {
                JH_STRONG(self);
                [self gotoLiveRoom:roomId];
            };
           self.tableView2.tableHeaderView = headerView2;
           self.tableView2.hidden = YES;
           
    }else if ([type isEqualToString:@"fansRanking"]) {
          [self.bgView addSubview:self.tableView3];
          [self.tableView3 mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.mas_equalTo(self.headerView.mas_bottom);
               make.left.right.mas_equalTo(0);
               make.bottom.mas_equalTo(0);
           }];
           JHLiveRoomPKTableHeaderView * headerView3 = [[JHLiveRoomPKTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height) andModel:self.pkModel andType:@"fansRanking" andIsShowUserInfo:isShowUser];
           self.tableView3.tableHeaderView = headerView3;
           self.tableView3.hidden = YES;
    }
    [self.bgView bringSubviewToFront:self.bottomView];
}
- (void)requestData{
    JH_WEAK(self);
    [JHLiveRoomPKModel requestEditDetailWithId:self.channelId successBlock:^(RequestModel * _Nonnull reqModel) {
        JH_STRONG(self);
        [self creatUI];
        self.pkModel = [JHLiveRoomPKModel mj_objectWithKeyValues:reqModel.data];
        if (self.pkModel.summaryRanking.count>0 && self.pkModel.summaryTitle) {
            [self.categoryTitleArray addObject:self.pkModel.summaryTitle];
            [self.categoryTypeArray addObject:@"summaryRanking"];
            [self creatTableView:@"summaryRanking"];
            if(self.pkModel.summaryRanking.count<=3){
                [self showEmptyViewTableView:self.tableView];
            }
        }
        if (self.pkModel.increaseRanking.count>0 && self.pkModel.increaseTitle) {
            [self.categoryTitleArray addObject:self.pkModel.increaseTitle];
            [self.categoryTypeArray addObject:@"increaseRanking"];
            [self creatTableView:@"increaseRanking"];
            if(self.pkModel.increaseRanking.count<=3){
                [self showEmptyViewTableView:self.tableView2];
            }
        }
        if (self.pkModel.fansTitle && self.type == 2) {
            [self.categoryTitleArray addObject:self.pkModel.fansTitle];
            [self.categoryTypeArray addObject:@"fansRanking"];
            [self creatTableView:@"fansRanking"];
            if(self.pkModel.fansRanking.count<=3){
                [self showEmptyViewTableView:self.tableView3];
            }
        }
        [self resetUIView];
        [self.bottomView resetViewwithModel:self.pkModel.channel andType:self.type];
    } failBlock:^(RequestModel * _Nonnull reqModel) {
        
    }];
}
- (void)resetUIView{
    self.headerView.categoryTitleArray = self.categoryTitleArray;
    self.headerView.categoryTypeArray = self.categoryTypeArray;
    [self.headerView creatCategoryViwe];
}
- (void)showEmptyViewTableView:(UITableView *)table{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH*0.7-180-UI.bottomSafeAreaHeight, ScreenW, 60)];
    [table addSubview:bottomView];

    
    UILabel *tipLabel = [JHUIFactory createLabelWithTitle:@" 暂无更多排名 " titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentCenter];
    [bottomView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bottomView.mas_centerX);
        make.top.equalTo(bottomView).offset(25);
        make.size.mas_equalTo(CGSizeMake(80, 20));
        
    }];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [bottomView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tipLabel.mas_centerY);
        make.right.mas_equalTo(tipLabel.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(80, 2));
    }];
    UIColor *colorOne = HEXCOLORA(0xEEEEEE, 0);
    UIColor *colorTwo = HEXCOLORA(0xEEEEEE, 1);;
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    gradient.colors = colors;
    gradient.frame = CGRectMake(0, 0, 80, 2);
    [view.layer insertSublayer:gradient atIndex:0];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectZero];
    [bottomView addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tipLabel.mas_centerY);
        make.left.mas_equalTo(tipLabel.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(80, 2));
    }];
    UIColor *colorOne2 = HEXCOLORA(0xEEEEEE, 1);
    UIColor *colorTwo2 = HEXCOLORA(0xEEEEEE, 0);;
    NSArray *colors2 = [NSArray arrayWithObjects:(id)colorOne2.CGColor, colorTwo2.CGColor, nil];
    CAGradientLayer *gradient2 = [CAGradientLayer layer];
    gradient2.startPoint = CGPointMake(0, 0);
    gradient2.endPoint = CGPointMake(1, 0);
    gradient2.colors = colors2;
    gradient2.frame = CGRectMake(0, 0, 80, 2);
    [view2.layer insertSublayer:gradient2 atIndex:0];
    
}
- (void)closeTapAction:(UIGestureRecognizer *)gest{
    if (gest.view == self) {
        [self removeFromSuperview];
    }
}
- (void)show{
    [JHKeyWindow addSubview:self];
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.alwaysBounceVertical = NO;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UITableView *)tableView2{
    if(!_tableView2){
        _tableView2 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView2.backgroundColor = [UIColor whiteColor];
        _tableView2.delegate = self;
        _tableView2.dataSource = self;
        _tableView2.alwaysBounceVertical = NO;
        _tableView2.bounces = NO;
        _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView2;
}

- (UITableView *)tableView3{
    if(!_tableView3){
        _tableView3 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView3.backgroundColor = [UIColor whiteColor];
        _tableView3.delegate = self;
        _tableView3.dataSource = self;
        _tableView3.alwaysBounceVertical = NO;
        _tableView3.bounces = NO;
        _tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView3;
}

#pragma mark - table datasource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    JHRankingTableViewCell* cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell)
    {
        cell = [[JHRankingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
   if (tableView == self.tableView) {
       if (self.pkModel.summaryRanking.count>3) {
           JHLiveRoomPKInfoModel * model = self.pkModel.summaryRanking[indexPath.row+3];
           [cell resetCellView:model andIsIncrease:NO];
       }
   }else if (tableView == self.tableView2){
      if (self.pkModel.increaseRanking.count>3) {
           JHLiveRoomPKInfoModel * model = self.pkModel.increaseRanking[indexPath.row+3];
           [cell resetCellView:model andIsIncrease:YES];
       }
   }else if (tableView == self.tableView3){
      if (self.pkModel.fansRanking.count>3) {
           JHLiveRoomPKInfoModel * model = self.pkModel.fansRanking[indexPath.row+3];
           [cell resetCellView:model andIsIncrease:NO];
       }
   }
    return cell;
       
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (self.pkModel.summaryRanking.count>3) {
            return self.pkModel.summaryRanking.count - 3;
        }
        
    }else if (tableView == self.tableView2){
        if (self.pkModel.increaseRanking.count>3) {
            return self.pkModel.increaseRanking.count - 3;
        }
    }else if (tableView == self.tableView3){
        if (self.pkModel.fansRanking.count>3) {
            return self.pkModel.fansRanking.count - 3;
        }
    }
    return 0;
}
#pragma mark - table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        if (self.pkModel.summaryRanking.count>3) {
            JHLiveRoomPKInfoModel * model = self.pkModel.summaryRanking[indexPath.row+3];
            if ([model.isOpen boolValue]) {
                [self gotoLiveRoom:model.channelId];
            }
            
        }
    }else if (tableView == self.tableView2){
       if (self.pkModel.increaseRanking.count>3) {
            JHLiveRoomPKInfoModel * model = self.pkModel.increaseRanking[indexPath.row+3];
           if ([model.isOpen boolValue]) {
               [self gotoLiveRoom:model.channelId];
           }
            
        }
    }else if (tableView == self.tableView3){
    }
}
- (void)gotoLiveRoom:(NSString *)roomId{
    if (_type == 2) {//主播 或者助理 不进其他直播间
        return;
    }
    if ([roomId isNotBlank]) {
        
        if (self.currentCategory.length>0 && self.rankName.length>0) {
            [JHGrowingIO trackEventId:JHtrackRanding_recommendClick variables:@{@"type":self.rankName,@"type1":self.currentCategory,@"channelLocalId":roomId}];
        }
        
        [self removeFromSuperview];
        [JHRootController EnterLiveRoom:roomId fromString:JHFromUndefined];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view != self) {
        return NO;
    }
    return YES;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 173;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//}
-(void)pressGoShopBtnEnter{
    [self removeFromSuperview];
    
    if (IS_LOGIN) {
        if ([self.bottomBar.shopwindowButtonNum integerValue]>0) {
                JHLiveStoreView *storeView = [[JHLiveStoreView alloc] initWithType:0 channel:self.channel];
                [JHRootController.currentViewController.view addSubview:storeView];

            }else{
                [SVProgressHUD showInfoWithStatus:@"请在直播间内购买喜欢的宝贝"];
        //        [JHKeyWindow makeToast:@"请在直播间内购买喜欢的宝贝"];
            }
    }
}

-(NSMutableArray *)categoryTitleArray{
    if (!_categoryTitleArray) {
        _categoryTitleArray = [[NSMutableArray alloc] init];
    }
    return _categoryTitleArray;
}
-(NSMutableArray *)categoryTypeArray{
    if (!_categoryTypeArray) {
        _categoryTypeArray = [[NSMutableArray alloc] init];
    }
    return _categoryTypeArray;
}
-(void)categoryBtnAction:(UIButton*)button andTypeStr:(nonnull NSString *)typeStr{
    NSLog(@"------%@",typeStr);
    self.currentCategory = button.currentTitle;
    if (button.currentTitle.length>0 && self.rankName.length>0) {
        [JHGrowingIO trackEventId:JHtrackType_Click variables:@{@"type":self.rankName,@"type1":typeStr}];
    }
    [self.headerView resetBgViewimage:typeStr];
    if ([typeStr isEqualToString:@"summaryRanking"]) {
        self.tableView.hidden = NO;
        self.tableView2.hidden = YES;
        self.tableView3.hidden = YES;
        self.bottomView.hidden = NO;
    }else if ([typeStr isEqualToString:@"increaseRanking"]) {
        self.tableView.hidden = YES;
        self.tableView2.hidden = NO;
        self.tableView3.hidden = YES;
        self.bottomView.hidden = NO;
    }else if ([typeStr isEqualToString:@"fansRanking"]) {
        self.tableView.hidden = YES;
        self.tableView2.hidden = YES;
        self.tableView3.hidden = NO;
        self.bottomView.hidden = YES;
    }
    
}
@end
