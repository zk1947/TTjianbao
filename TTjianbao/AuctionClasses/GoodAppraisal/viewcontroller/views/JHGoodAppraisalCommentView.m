//
//  JHGoodAppraisalCommentView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/4/16.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHGoodAppraisalCommentView.h"
#import "NELivePlayerControlView.h"
#import "JHVideoPlayControlView.h"
#import "JHAppraisalContentView.h"
#import "CommentTableViewCell.h"
#import "CommentToolView.h"
#import <IQKeyboardManager.h>
#import "UMengManager.h"
#import "NTESLivePlayerViewController.h"
#import "NTESAudienceLiveViewController.h"
#import "JHAudienceApplyConnectView.h"
#import "NTESLiveManager.h"
#import "JHBaseOperationView.h"
#import "JHAppraisalDetailTopView.h"

#define pagesize 10
#define spaceTop 200
typedef void (^successBlock)(void);
@interface JHGoodAppraisalCommentView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate ,CommentToolViewDelegate,JHAppraisalContentViewDelegate>
{
    UIView *  headerView;
    UIView * footerView;
    float cellHeight;
    NSInteger PageNum;
    NSString * appraisalID;
    JHRefreshNormalFooter *footer;
    UILabel *lb;
   
}
@property(nonatomic,strong) UITableView* homeTable;
@property(nonatomic,strong) CommentToolView* commentToolView;
@property(nonatomic,strong) NSMutableArray* appraisalCommentModes;
@property(nonatomic,strong) AppraisalDetailMode* appraisalDetail;
@property(nonatomic,strong) UILabel* commentCountLabel;
@property(nonatomic,strong)  UIView * contentView;
@property(nonatomic,strong)  NSString * recordId;
@end

@implementation JHGoodAppraisalCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
//        self.backgroundColor=[UIColor clearColor];
//        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismiss)];
//        tap.delegate=self;
//        [self  addGestureRecognizer:tap];
        
        [self addSubview:self.contentView];
        [self setHeaderView];
        [self setFooterView];
        [self.contentView addSubview:self.homeTable];
        
        self.gestView=self.contentView;
        self.gestView=self.homeTable;
        
        JH_WEAK(self)
        self.hideComplete = ^{
            JH_STRONG(self)
            if (self.hideCompleteBlock) {
                self.hideCompleteBlock(self.appraisalDetail);
            }
        };
        [self.homeTable mas_makeConstraints:^(MASConstraintMaker *make) {
              make.top.offset(50);
              make.bottom.offset(-50);
              make.left.right.equalTo(self);
        }];
        [self.contentView addSubview:self.commentToolView];
        
        [self.commentToolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(50);
            make.bottom.offset(0);
            make.left.right.equalTo(self.contentView);
        }];
       
        UITapGestureRecognizer*tableTap=[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(dismissKeyboard)];
        tableTap.delegate=self;
        [self.homeTable  addGestureRecognizer:tableTap];
        
        self.homeTable.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            JH_STRONG(self)
            [self loadMoreData];
        }];
    }
    return self;
}
- (void)loadData:(AppraisalDetailMode*)mode andShowCommentbar:(BOOL)isShow{
    
      self.appraisalDetail=mode;
      self.recordId=mode.recordId;
      [self loadNewData];
    if (isShow) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self.commentToolView.commentTextField becomeFirstResponder];
        });
      }
}
-(void)loadNewData{
    
    PageNum=0;
    [self requestCommentList];
}
-(void)loadMoreData{
    
    PageNum++;
    [self requestCommentList];
}
-(void)requestCommentList{
    
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/comment/authoptional/newlist?productId=%@&pageNo=%ld&pageSize=%ld"), self.appraisalDetail.recordId,PageNum,pagesize];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        [self handleDataWithArr:respondObject.data[@"datas"]];
         _commentCountLabel.text =[NSString stringWithFormat:@"共 %@ 条评论",respondObject.data[@"count"]];
         self.appraisalDetail.comments = [NSString stringWithFormat:@"%@",respondObject.data[@"count"]];
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}
- (void)handleDataWithArr:(NSArray *)array {
    NSArray *arr = [ApprailsalCommentMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        self.appraisalCommentModes = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.appraisalCommentModes addObjectsFromArray:arr];
        
    }
    [self.homeTable reloadData];
    
    if ([arr count]<pagesize) {
        self.homeTable.mj_footer.hidden=YES;
        if (arr.count == 0){
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
- (void)setHeaderView
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
    
    _commentCountLabel = [[UILabel alloc ]initWithFrame:CGRectMake(0,0, ScreenW , 50)];
    _commentCountLabel.font=[UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    _commentCountLabel.textColor=HEXCOLOR(0x333333);
    _commentCountLabel.numberOfLines = 1;
    _commentCountLabel.textAlignment = UIControlContentHorizontalAlignmentLeft;
    [headerView addSubview:_commentCountLabel];
    
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
    
}
#pragma mark =============== setter ===============
-(UITableView*)homeTable{
    
    if (!_homeTable) {
        _homeTable=[[UITableView alloc]initWithFrame:CGRectZero  style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.scrollEnabled=YES;
        _homeTable.bounces=YES;
        _homeTable.tableFooterView=footerView;
        _homeTable.estimatedRowHeight = 50;
        //         _homeTable.estimatedSectionFooterHeight = 0;
        _homeTable.contentInset=UIEdgeInsetsMake(0, 0,0, 0);
        _homeTable.backgroundColor=[UIColor whiteColor];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
    return _homeTable;
}
-(CommentToolView *)commentToolView{
    
    if (!_commentToolView) {
        _commentToolView=[[CommentToolView alloc]init];
        _commentToolView.top=spaceTop;
        _commentToolView.delegate=self;
    }
    return _commentToolView;
}
-(UIView *)contentView {
    
    if (!_contentView) {
        _contentView=[[UIView alloc]initWithFrame:CGRectMake(0,spaceTop, ScreenW, self.height-spaceTop)];
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
    
    return self.appraisalCommentModes.count ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"cellIdentifier";
    CommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
     [cell setAppraisalComment:self.appraisalCommentModes[indexPath.section]];
     [cell setCellIndex:indexPath.section];
     JH_WEAK(self)
    
    cell.cellClick = ^(BOOL isLaud, NSInteger index) {
        JH_STRONG(self)
        [self clickIndex:index isLaud:isLaud];
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
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==[self.appraisalCommentModes count]-1) {
        return 1;
    }
    
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer =[[UIView alloc]init];
    footer.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    return footer;
}
-(void)onClickBtnComment:(UIButton*)sender{
    
    [ self.commentToolView.commentTextField becomeFirstResponder];
}
#pragma mark =============== JHVideoPlayControlViewProtocol ===============
- (void)controlViewOnClickShare:(JHVideoPlayControlView *)controlView{
    
    NSLog(@"%@",self.appraisalDetail.videoUrl);
    if ([self isLgoin]) {
        NSString *stringURL = [[UMengManager shareInstance].shareVideoUrl stringByAppendingString:OBJ_TO_STRING(self.appraisalDetail.appraiseId)];
        //@"来看大神的鉴定一对一鉴定视频，珠宝，翡翠，玉石"
        stringURL = [stringURL stringByAppendingString:[NSString stringWithFormat:@"&type=1"]];
//        [[UMengManager shareInstance] showShareWithTarget:nil title:ShareOrderReportTitle text:ShareOrderReportText thumbUrl:nil webURL:stringURL type:ShareObjectTypeAppraiseVideo object:self.appraisalDetail.recordId];
        JHShareInfo* info = [JHShareInfo new];
        info.title = ShareOrderReportTitle;
        info.desc = ShareOrderReportText;
        info.shareType = ShareObjectTypeAppraiseVideo;
        info.url = stringURL;
        [JHBaseOperationView showShareView:info objectFlag:self.appraisalDetail.recordId]; //TODO:Umeng share
    }
}
- (void)controlViewOnClickLike:(JHVideoPlayControlView *)controlView isLike:(BOOL)like{
    
    if ([self isLgoin]) {
        
        NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/video/auth/viewerChangeStatusNew?channelRecordId=%@&status=%@"),self.recordId,like?@"1":@"0"];
        [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
           // [_appraisalTopView setIsLike:like];
            
        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [UITipView showTipStr:respondObject.message];
        }];
        [SVProgressHUD show];
    }
}

#pragma mark =============== CommentToolViewDelegate ===============
- (void)OnClickComment:(NSString *)string{
    VideoExtendModel *model = [JHGrowingIO videoExtendModel:[self appraisalDetail]];
    [JHGrowingIO trackEventId:JHTrackvideo_detail2_commentpage_sendclick variables:[model mj_keyValues]];
    [self.commentToolView.commentTextField resignFirstResponder];
   // [self endEditing:YES];
    if ([self isLgoin]) {
        NSDictionary * parameters=@{@"productId":self.appraisalDetail.recordId,
                                    @"remarks":string
                                    };
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/comment/auth/add") Parameters:parameters requestSerializerType:RequestSerializerTypeJson
                        successBlock:^(RequestModel *respondObject) {
                            
                            [SVProgressHUD dismiss];
                            self.commentToolView.commentTextField.text = @"";
                            [self loadNewData];
            
            VideoExtendModel *model = [JHGrowingIO videoExtendModel:[self appraisalDetail]];
            model.commentId = respondObject.data;
            model.result = @"true";
               [JHGrowingIO trackEventId:JHTrackvideo_detail2_commentpage_sendcommit variables:[model mj_keyValues]];
                            
                        } failureBlock:^(RequestModel *respondObject) {
                            
                            [SVProgressHUD dismiss];
                            [self makeToast:respondObject.message duration:2.0 position:CSToastPositionCenter];
                            VideoExtendModel *model = [JHGrowingIO videoExtendModel:[self appraisalDetail]];
                                       model.commentId = @"";
                                       model.result = @"false";
                                          [JHGrowingIO trackEventId:JHTrackvideo_detail2_commentpage_sendcommit variables:[model mj_keyValues]];
                        }];
        
        [SVProgressHUD show];
    }
    
}
#pragma mark =============== JHAppraisalContentViewDelegate ===============
- (void)pressCare:(UIButton*)button{
    if ([self isLgoin]) {
        
        NSLog(@"%@",self.appraisalDetail.appraiser.viewId);
        [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/authoptional/appraise/follow") Parameters:@{@"followCustomerId":self.appraisalDetail.appraiser.viewId,@"status":@(!button.selected)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            
            [SVProgressHUD dismiss];
           // [reportView setIsCare:!button.selected];
            
        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [self makeToast:respondObject.message];
        }];
        
        [SVProgressHUD show];
        
    }
}
- (void)clickIndex:(NSInteger)index isLaud:(BOOL)laud{
    
    if ([self isLgoin]) {
        ApprailsalCommentMode * mode=[self.appraisalCommentModes objectAtIndex:index];
        NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/comment/auth/laud?wordId=%@&status=%@"),mode.ID,laud?@"0":@"1"];
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
            
            CommentTableViewCell *cell =(CommentTableViewCell*) [self.homeTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
             [cell beginAnimation:mode];
        
        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [UITipView showTipStr:respondObject.message];
        }];
      //  [SVProgressHUD show];
    }
}
-(BOOL)isLgoin{
    
    if (![JHRootController isLogin]) {
          [self.commentToolView.commentTextField resignFirstResponder];
        [JHRootController presentLoginVCWithTarget:self.viewController complete:^(BOOL result) {
            if (result){
                
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
    
    VideoExtendModel *model = [JHGrowingIO videoExtendModel:[self appraisalDetail]];
            [JHGrowingIO trackEventId:JHTrackvideo_detail2_commentpage_show variables:[model mj_keyValues]];


}
- (void)dismiss
{
     self.contentView.bottom =  self.height;
    [UIView animateWithDuration:0.5 animations:^{
     self.contentView.top =  self.height;
        
    } completion:^(BOOL finished) {
        
      [self removeFromSuperview];
        if (self.hideCompleteBlock) {
            self.hideCompleteBlock(self.appraisalDetail);
        }
        
    }];
    
    VideoExtendModel *model = [JHGrowingIO videoExtendModel:[self appraisalDetail]];
    [JHGrowingIO trackEventId:JHTrackvideo_detail2_commentpage_closeclick variables:[model mj_keyValues]];
}


- (void)dealloc
{
    NSLog(@"deallocdealloc");
}
@end
