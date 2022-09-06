//
//  JHGoodAppraisalCommentView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/4/16.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHAudienceCommentView.h"
#import "JHAudienceCommentTableViewCell.h"
#import "CommentToolView.h"
#import <IQKeyboardManager.h>
#import "UMengManager.h"
#import "NTESLivePlayerViewController.h"
#import "NTESAudienceLiveViewController.h"
#import "JHAudienceApplyConnectView.h"
#import "NTESLiveManager.h"
#import "JHAppraisalDetailTopView.h"
#import "NTESAudienceLiveViewController.h"
#import "JHCommentHeaderTagView.h"
#import "ChannelMode.h"
#import "TTjianbaoHeader.h"
#import "JHWebViewController.h"


#define pagesize 10
typedef void (^successBlock)(void);
@interface JHAudienceCommentView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate >
{
    UIView *headerView;
    JHCommentHeaderTagView *tableHeaderView;
    UIView * footerView;
    float cellHeight;
    NSInteger PageNum;
    NSString * appraisalID;
    JHRefreshNormalFooter *footer;
    UILabel *lb;
  
    
}
@property(nonatomic,strong) UITableView* homeTable;
@property(nonatomic,strong) NSMutableArray* audienceCommentModes;
@property(nonatomic,strong) NSMutableArray<CommentTagMode*>* searchTagModes;
@property(nonatomic,strong) UILabel* commentCountLabel;
@property(nonatomic,strong) UILabel* goodCommentLabel;
@property(nonatomic,strong)  UIView * contentView;
@property(nonatomic,strong)  ChannelMode * channelMode;
@property(nonatomic,strong)    NSString * tagCode;
@end

@implementation JHAudienceCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.contentView];
        [self setTitlerView];
        [self.contentView addSubview:self.homeTable];
        [self setHeaderView];
        [self setFooterView];
     
        self.gestView=self.contentView;
        self.gestView=self.homeTable;
        self.tagCode=@"all";
        
        JH_WEAK(self)
        self.hideComplete = ^{
            JH_STRONG(self)
            if (self.hideCompleteBlock) {
                // self.hideCompleteBlock(weakSelf.appraisalDetail);
            }
        };
        [self.homeTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(50);
            make.bottom.offset(0);
            make.left.right.equalTo(self);
        }];
        
        UITapGestureRecognizer*tableTap=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)];
        tableTap.delegate=self;
        [self.homeTable  addGestureRecognizer:tableTap];
        
        self.homeTable.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            JH_STRONG(self)
            [self loadMoreData];
        }];
        [self.homeTable.mj_footer setHidden:YES];
    }
    return self;
}
- (void)loadData:(ChannelMode*)mode andShowCommentbar:(BOOL)isShow{
    
    self.channelMode=mode;
    [self loadNewData];
    [self requestTags];
}
-(void)loadNewData{
    PageNum=0;
    [self requestCommentList];
}
-(void)loadMoreData{
    PageNum++;
    [self requestCommentList];
}
-(void)requestTags{
    
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/orderComment/countByTag?sellerCustomerId=%@&roomId=%@"), self.channelMode.anchorId,self.channelMode.roomId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.searchTagModes=[NSMutableArray array];
        self.searchTagModes = [CommentTagMode  mj_objectArrayWithKeyValuesArray:respondObject.data];
        [tableHeaderView showTagArray:self.searchTagModes];
   
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}
-(void)requestCommentList{
    
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/orderComment/list?sellerCustomerId=%@&roomId=%@&pageNo=%ld&pageSize=%ld&tagCode=%@"), self.channelMode.anchorId,self.channelMode.roomId,PageNum,pagesize,self.tagCode];
    
    NSLog(@"url :----- %@", url);
    
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        [self handleDataWithArr:respondObject.data[@"datas"]];
        _commentCountLabel.text =[NSString stringWithFormat:@"( %@ )",respondObject.data[@"count"]];
        
        NSString * string=[NSString stringWithFormat:@"好评度 %@",respondObject.data[@"orderGrade"]];
        NSRange  range =[string rangeOfString:@"好评度"];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
        [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
        [attString addAttribute:NSForegroundColorAttributeName value:[CommHelp toUIColorByStr:@"#666666"] range:range];
        _goodCommentLabel.attributedText=attString;
        
        //  self.appraisalDetail.comments = [NSString stringWithFormat:@"%@",respondObject.data[@"count"]];
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}
- (void)handleDataWithArr:(NSArray *)array {
    NSArray *arr = [JHAudienceCommentMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        self.audienceCommentModes = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.audienceCommentModes addObjectsFromArray:arr];
        
    }
    [self.homeTable reloadData];
    
    if ([arr count]<pagesize) {
        self.homeTable.mj_footer.hidden=YES;
        if (arr.count == 0&&self.audienceCommentModes.count==0){
            lb.text = @"- 暂无评论 -";
        }
        else{
            lb.text = @"— 已显示全部评论 —";
        }
    }
    else{
        self.homeTable.mj_footer.hidden=NO;
    }
}
- (void)endRefresh {
    [self.homeTable.mj_footer endRefreshing];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UISlider"]) {
        return NO;
    }
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIControl"]) {
        return NO;
    }
    return YES;
    
}
-(void)dismissKeyboard {
    
    [self endEditing:YES];
}
- (void)setTitlerView
{
     headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW,50)];
    headerView.backgroundColor=[UIColor whiteColor];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:headerView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(8,8)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = headerView.bounds;
    maskLayer.path = maskPath.CGPath;
    headerView.layer.mask = maskLayer;
    
    [self.contentView addSubview:headerView];
    
    UIView * line=[[UIView alloc]init];
    line.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
    [headerView addSubview:line];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.right.equalTo(headerView);
        make.bottom.equalTo(headerView).offset(0);
    }];
    
    UILabel * titleLabel = [[UILabel alloc ]init];
    titleLabel.font=[UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    titleLabel.textColor=HEXCOLOR(0x222222);
    titleLabel.numberOfLines = 1;
    titleLabel.text=@"买家评价";
    titleLabel.textAlignment = UIControlContentHorizontalAlignmentLeft;
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(headerView);
        make.left.equalTo(headerView).offset(10);
    }];
    
    _commentCountLabel = [[UILabel alloc ]init];
    _commentCountLabel.font=[UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    _commentCountLabel.textColor=HEXCOLOR(0x222222);
    _commentCountLabel.numberOfLines = 1;
    _commentCountLabel.textAlignment = UIControlContentHorizontalAlignmentLeft;
    [headerView addSubview:_commentCountLabel];
    [_commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(headerView);
        make.left.equalTo(titleLabel.mas_right).offset(10);
    }];
       _goodCommentLabel = [[UILabel alloc ]init];
    _goodCommentLabel.font=[UIFont fontWithName:@"PingFangSC-Semibold" size:11];
    _goodCommentLabel.textColor=HEXCOLOR(0x222222);
    _goodCommentLabel.numberOfLines = 1;
    _goodCommentLabel.textAlignment = UIControlContentHorizontalAlignmentLeft;
    [headerView addSubview:_goodCommentLabel];
    [_goodCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(headerView);
        make.left.equalTo(_commentCountLabel.mas_right).offset(10);
    }];

    UIButton * close=[[UIButton alloc]init];
    // [close setBackgroundImage:[UIImage imageNamed:@"new_appraisal_close"] forState:UIControlStateNormal];
    [close setImage:[UIImage imageNamed:@"new_appraisal_close"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    close.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:close];
    
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.right.equalTo(headerView).offset(-15);
    }];
    
}
-(void)setHeaderView{
   tableHeaderView=[[JHCommentHeaderTagView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
     self.homeTable.tableHeaderView=tableHeaderView;
    MJWeakSelf
    tableHeaderView.finish = ^(CGFloat height) {
          __strong typeof(weakSelf) sself = weakSelf;
          sself->tableHeaderView.frame=CGRectMake(0, 0, ScreenW, height);
           weakSelf.homeTable.tableHeaderView= sself->tableHeaderView;
    };
    tableHeaderView.clickTagFinish = ^(id sender) {
        UIButton * btn=(UIButton*)sender;
        weakSelf.tagCode=weakSelf.searchTagModes[btn.tag].tagCode;
        [weakSelf loadNewData];
    };
//     [tableHeaderView showTagArray:@[@"你好",@"阿发放",@"短发短发",@"发发",@"苟富贵",@"奋斗奋斗",@"奋斗奋斗分",@"阿大",@"奋斗奋斗分"]];
}
- (void)setFooterView
{
    
    footerView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 80)];
    footerView.backgroundColor=[UIColor whiteColor];
    lb = [[UILabel alloc ]initWithFrame:CGRectMake(0, 30, ScreenW , 30)];
    lb.text = @"";
    lb.font=[UIFont systemFontOfSize:13];
    lb.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
    lb.numberOfLines = 1;
    lb.textAlignment = UIControlContentHorizontalAlignmentLeft;
    lb.textColor = [UIColor lightGrayColor];
    [footerView addSubview:lb];
    _homeTable.tableFooterView=footerView;
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
        _homeTable.backgroundColor=[UIColor whiteColor];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
    return _homeTable;
}

-(UIView *)contentView {
    
    if (!_contentView) {
        _contentView=[[UIView alloc]initWithFrame:CGRectMake(0,200, ScreenW, self.height-200)];
        _contentView.backgroundColor=[UIColor whiteColor];
        
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds byRoundingCorners: UIRectCornerTopLeft  | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = maskPath.CGPath;
        _contentView.layer.mask = maskLayer;
        
    }
    return _contentView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self endEditing:YES];
    NSLog(@"%lf",scrollView.contentOffset.y);
    
}
#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.audienceCommentModes.count ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"cellIdentifier";
    JHAudienceCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[JHAudienceCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    [cell setAudienceCommentMode:self.audienceCommentModes[indexPath.section]];
    [cell setCellIndex:indexPath.section];
    JH_WEAK(self)
    cell.cellClick = ^(UIButton *button, BOOL isLaud, NSInteger index) {
        JH_STRONG(self)
        if (button.tag==1) {
            JHAudienceCommentMode * mode=[self.audienceCommentModes objectAtIndex:index];
            if ( [self.viewController isKindOfClass: [NTESAudienceLiveViewController class]]) {
                NTESAudienceLiveViewController * vc=(NTESAudienceLiveViewController*)self.viewController;
                vc.needShutDown=YES;
            }
            
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            webView.urlString = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/report.html?orderId=%@"), mode.orderId];
            [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
        }
        if (button.tag==2) {
            [self clickIndex:index isLaud:isLaud];
        }
    };
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
    
    if (section==[self.audienceCommentModes count]-1) {
        return 1;
    }
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer =[[UIView alloc]init];
    footer.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    return footer;
}


- (void)clickIndex:(NSInteger)index isLaud:(BOOL)laud{
    
    if ([self isLgoin]) {
        JHAudienceCommentMode * mode=[self.audienceCommentModes objectAtIndex:index];
        NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/orderComment/auth/laud?commentId=%@&status=%@"),mode.Id,laud?@"0":@"1"];
        [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            mode.isLaud=!laud;
            int count=[mode.laudTimes intValue];
            if (!laud) {
                count=count+1;
                mode.laudTimes=[NSString stringWithFormat:@"%d",count];
            }
            else{
                count=count-1;
                mode.laudTimes=[NSString stringWithFormat:@"%d",count];
            }
            
            JHAudienceCommentTableViewCell *cell =(JHAudienceCommentTableViewCell*) [self.homeTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
            [cell reloadCell:mode];
            
            
        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [UITipView showTipStr:respondObject.message];
        }];
        //  [SVProgressHUD show];
    }
}
-(BOOL)isLgoin{
    
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self.viewController complete:^(BOOL result) {
            if (result){
                [[NSNotificationCenter defaultCenter] postNotificationName:JHNotifactionNameLiveLoginFinish object:nil];

            }
        }];
        return  NO;
    }
    return  YES;
}

- (void)show
{
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //    [window addSubview:self];
    self.contentView.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.bottom =  self.height;
        
    }];
    
}
- (void)dismiss
{
    self.contentView.bottom =  self.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.top =  self.height;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        if (self.hideCompleteBlock) {
        }
        
    }];
}


- (void)dealloc
{
    NSLog(@"deallocdealloc");
}
@end


