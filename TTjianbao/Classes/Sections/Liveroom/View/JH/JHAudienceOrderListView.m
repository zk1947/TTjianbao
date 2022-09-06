//
//  JHGoodAppraisalCommentView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/4/16.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHAudienceOrderListView.h"
#import "JHAudienceOrderTableViewCell.h"
#import "TTjianbaoHeader.h"

#define pagesize 10
typedef void (^successBlock)(void);
@interface JHAudienceOrderListView ()<UITableViewDelegate,UITableViewDataSource >
{
    NSInteger PageNum;
    NSString * appraisalID;
    UILabel *lb;
    UILabel * titleLabel;
}
@property(nonatomic,strong) UIView* contentView;
@property(nonatomic,strong) UITableView* homeTable;
@property(nonatomic,strong) NSMutableArray* orderModes;

@end

@implementation JHAudienceOrderListView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
       self.frame=CGRectMake(0, 0, ScreenW, ScreenH);
       self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        
        [self addSubview:self.contentView];
        [self setTitlerView];
        [self.contentView addSubview:self.homeTable];
 
        [self.homeTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(50);
            make.left.equalTo(self.contentView).offset(0);
            make.right.equalTo(self.contentView).offset(0);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}
- (void)loadData:(NTESMicConnector*)mode{

     [self requestInfo:mode.Id];
}
-(void)requestInfo:(NSString*)uid{
    
    NSString *  url = [NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/orderListByBuyer?buyerId=%@&"),uid];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self handleDataWithArr:respondObject.data];
        [self endRefresh];
    } failureBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        [UITipView showTipStr:respondObject.message];
    }];
}
- (void)handleDataWithArr:(NSArray *)array {
    NSArray *arr = [OrderMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        self.orderModes = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.orderModes addObjectsFromArray:arr];
    }
    [self.homeTable reloadData];
    [self endRefresh];
    
}
- (void)endRefresh {
   
    if (self.orderModes.count) {
        [self hiddenDefaultImage];
    }else {
        [self  showDefaultImageWithView:self.homeTable];
    }
}
- (void)setTitlerView
{
    titleLabel = [[UILabel alloc ]init];
    titleLabel.font=[UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    titleLabel.textColor=HEXCOLOR(0x222222);
    titleLabel.numberOfLines = 1;
    titleLabel.text=@"订单记录";
    titleLabel.textAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.centerX.equalTo(self.contentView);
        make.width.offset(100);
    }];

    UIButton * close=[[UIButton alloc]init];
    // [close setBackgroundImage:[UIImage imageNamed:@"new_appraisal_close"] forState:UIControlStateNormal];
    [close setImage:[UIImage imageNamed:@"audiencelist_close"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    close.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:close];

    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.equalTo(self.contentView).offset(-10);
    }];

}

#pragma mark =============== setter ===============
-(UITableView*)homeTable{
    
    if (!_homeTable) {
        _homeTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.scrollEnabled=YES;
        _homeTable.bounces=YES;
        _homeTable.estimatedRowHeight = 100;
        //         _homeTable.estimatedSectionFooterHeight = 0;
        _homeTable.contentInset=UIEdgeInsetsMake(0, 0,0, 0);
        _homeTable.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
    return _homeTable;
}

-(UIView *)contentView {
    
    if (!_contentView) {
        _contentView=[[UIView alloc]initWithFrame:CGRectMake(0,0, ScreenW-100, 420)];
        _contentView.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        _contentView.layer.masksToBounds =YES;
        _contentView.layer.cornerRadius =4;
        _contentView.center=self.center;
    }
    return _contentView;
}

#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.orderModes.count ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"cellIdentifier";
    JHAudienceOrderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[JHAudienceOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
      [cell setOrderMode:self.orderModes[indexPath.section]];
      return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==[self.orderModes count]-1) {
        return 1;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer =[[UIView alloc]init];
    footer.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    return footer;
}

- (void)show
{
    
   [ [UIApplication sharedApplication].keyWindow addSubview:self];
    self.contentView.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.center =  self.center;
        
    }];
    
}
- (void)dismiss
{
    self.contentView.bottom =  self.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.top =  self.height;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}


- (void)dealloc
{
    NSLog(@"deallocdealloc");
}
@end



