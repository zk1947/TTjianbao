//
//  JHSendOrderProccessGoodView.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/13.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHSendOrderProccessGoodView.h"
#import "JHSendOrderProccessGoodCell.h"
#import "JHSendOrderProccessGoodServiceView.h"
#import "TTjianbaoHeader.h"


#define kCellIdentifier @"JHSendOrderProccessGoodCell"

@interface JHSendOrderProccessGoodView () <UITableViewDelegate, UITableViewDataSource> {
    NSString *buyId;
    int isAssitant;
}

@property (nonatomic,strong) UIView* backView;
@property (nonatomic, strong) UILabel* titleText;
@property (nonatomic, strong) UIButton* closeButton;
@property (nonatomic, strong) UITableView* goodTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation JHSendOrderProccessGoodView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = HEXCOLORA(0x000000, 0.2);

//        [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
        [self drawSubview];
        [self makeData];//test data
    }
    return self;
}

- (void)makeData
{
    self.dataArray = [NSMutableArray array];
}

- (void)loadOneData {
    self.pageNo = 0;
    self.pageSize = 10;
    [self requestData];
}

- (void)loadMoreData {
    self.pageNo ++;
    [self requestData];

}

- (void)requestProccessGoodsBuyId:(NSString *)buyid isAssistant:(BOOL)isAssis
{
    buyId = buyid;
    isAssitant = isAssis;
    [self loadOneData];
}

- (void)requestData {
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:@"processingGoods" forKey:@"searchStatus"];
    [dic setValue:buyId forKey:@"buyerId"];
    [dic setValue:@(self.pageNo) forKey:@"pageNo"];//第一页
    [dic setValue:@(self.pageSize) forKey:@"pageSize"];//10
    [dic setValue:@(0) forKey:@"isLive"];
    [dic setValue:@(isAssitant) forKey:@"isAssistant"];
    NSString* url = @"/order/auth/sellerOrderList";
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(url) Parameters:dic successBlock:^(RequestModel *respondObject) {
        
       NSLog(@"proccessingGoods success");
        if (self.pageNo == 0) {
            self.dataArray = [OrderMode mj_objectArrayWithKeyValuesArray:respondObject.data];
        }else {
            [self.dataArray addObjectsFromArray:[OrderMode mj_objectArrayWithKeyValuesArray:respondObject.data]];
        }
        [self.goodTableView.mj_header endRefreshing];
        [self.goodTableView.mj_footer endRefreshing];

        [self.goodTableView reloadData];
        if (self.dataArray.count == 0) {
            [self showDefaultImageWithView:self.goodTableView];
        }else {
            [self hiddenDefaultImage];
        }
       
    } failureBlock:^(RequestModel *respondObject) {
       NSLog(@"proccessingGoods fail");
    
        [self.goodTableView.mj_header endRefreshing];
        [self.goodTableView.mj_footer endRefreshing];
        
        if (self.dataArray.count == 0) {
                   [self showDefaultImageWithView:self.goodTableView];
               }else {
                   [self hiddenDefaultImage];
               }
    }];
}

- (void)drawSubview
{
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(52);
        make.centerY.equalTo(self).offset(-30);
        make.width.mas_equalTo(ScreenW-52*2);
        make.height.mas_equalTo(346);//默认
    }];
    
    [self.backView addSubview:self.titleText];
    [self.titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(10);
        make.centerX.equalTo(self.backView);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(21);
    }];
    
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(28);
        make.right.equalTo(self.backView).offset(28/2);
        make.top.equalTo(self.backView).offset(-28/2);
    }];
    
    [self.backView addSubview:self.goodTableView];
    [self.goodTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(41);
        make.left.equalTo(self.backView);
        make.bottom.equalTo(self.backView).offset(-10);
        make.width.equalTo(self.backView);
        make.height.equalTo(self.backView).offset(-41-10);
    }];
    
    [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
               make.height.equalTo(self.goodTableView).offset(41+10);
           }];
}

- (UIView*)backView
{
    if (!_backView)
    {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 6;
        _backView.layer.masksToBounds = YES;
    }
    
    return _backView;
}

- (UILabel *)titleText
{
    if (!_titleText)
    {
        _titleText = [UILabel new];
        _titleText.font = [UIFont fontWithName:kFontMedium size:15];
        _titleText.textColor = HEXCOLOR(0x333333);
        _titleText.text = @"加工服务单";
        _titleText.backgroundColor = [UIColor whiteColor];
    }
    
    return _titleText;
}

- (UIButton *)closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.layer.cornerRadius = 14;
        _closeButton.backgroundColor = HEXCOLOR(0x333333);
//        [_closeButton setTitle:@"×" forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"icon_alert_close"] forState:UIControlStateNormal];
        [_closeButton setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:28];
    }
    
    return _closeButton;
}

- (UITableView *)goodTableView
{
    if (!_goodTableView)
    {
        _goodTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _goodTableView.delegate = self;
        _goodTableView.dataSource = self;
        _goodTableView.backgroundColor = [UIColor whiteColor];
        _goodTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goodTableView.estimatedRowHeight = kJHSendOrderProccessGoodCellHeight;
//        _goodTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
       JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadOneData)];
        _goodTableView.mj_header = header;
        
        JHRefreshNormalFooter *footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _goodTableView.mj_footer = footer;
    }
    return _goodTableView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kJHSendOrderProccessGoodCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHSendOrderProccessGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if(!cell)
        cell = [[JHSendOrderProccessGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    
    [cell setData:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHSendOrderProccessGoodServiceView *view = [[JHSendOrderProccessGoodServiceView alloc] init];
    OrderMode *model = self.dataArray[indexPath.row];
    model.buyerCustomerId = buyId;
    [view setOrderModel:model];
    [self.superview addSubview:view];
    
    [self dismiss];
}

#pragma event
- (void)dismiss
{
    [self removeFromSuperview];
}

@end
