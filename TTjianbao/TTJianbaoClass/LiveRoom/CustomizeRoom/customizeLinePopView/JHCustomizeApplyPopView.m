//
//  JHCustomizeApplyPopView.m
//  TTjianbao
//
//  Created by apple on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeApplyPopView.h"
#import "JHGrowingIO.h"
#import "TTjianbaoHeader.h"
#import "UIImage+JHColor.h"
#import "UIView+CornerRadius.h"
#import "JHApplyCustomizeOrderView.h"
#import "JHCustomizApplyPopCell.h"
#import "JHCustomizeApplyProcessFirst.h"
#import "JHCustomizePopModel.h"
#import "UIScrollView+JHEmpty.h"

@interface JHCustomizeApplyPopView ()<UIGestureRecognizerDelegate,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)  UIButton* sureBtn;
@property(nonatomic,strong) UILabel * titleLabel;
@property(nonatomic,strong) UIView * bar;
@property(nonatomic,strong) UIView * topView;
@property(nonatomic,strong) OrderMode * orderModel;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray <JHCustomizePopModel *>* arrayModel;
@property(nonatomic,strong) UIView * emptyView;
@end

@implementation JHCustomizeApplyPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        _bar =  [[UIView alloc]init];
        _bar.backgroundColor= [CommHelp toUIColorByStr:@"#ffffff"];
        _bar.userInteractionEnabled = YES;
        _bar.layer.masksToBounds = YES;
        _bar.frame= CGRectMake(0, 0, ScreenW, 362);
        [_bar yd_setCornerRadius:8.f corners:UIRectCornerAllCorners];
        [self addSubview:_bar];

        self.topView =  [[UIView alloc] init];
        // topView.frame = CGRectMake(0,0,375,50);
        self.topView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        self.topView.layer.cornerRadius = 0;
        self.topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
        self.topView.layer.shadowOffset = CGSizeMake(0,1);
        self.topView.layer.shadowOpacity = 1;
        self.topView.layer.shadowRadius = 5;
        [_bar addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((_bar)).offset(0);
            make.left.right.equalTo(_bar);
            make.height.offset(50);

        }];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColor333;
        _titleLabel.text=@"请选择已申请的定制服务进行连麦";
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15.f];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.topView addSubview:_titleLabel];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //  make.top.equalTo((_bar)).offset(15);
            make.center.equalTo(self.topView);
        }];

        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"new_appraisal_close"] forState:UIControlStateNormal ];
        closeButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:closeButton];


        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel);
            make.right.equalTo(self.topView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];

        UILabel * tipLabel = [[UILabel alloc] init];
        tipLabel.backgroundColor = HEXCOLOR(0xFFEDE7);
        tipLabel.textColor = HEXCOLOR(0xFF4200);
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text=@"仅展示当前直播间的订单和自有原料申请定制的历史记录";
        tipLabel.font = JHFont(12);
        [_bar addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_bar);
            make.top.mas_equalTo(self.topView.mas_bottom);
            make.height.mas_equalTo(37);
        }];
        
        
        [_bar addSubview:self.tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(_bar);
            make.top.mas_equalTo(tipLabel.mas_bottom);
            make.bottom.mas_equalTo(_bar.mas_bottom).offset(-UI.bottomSafeAreaHeight);
                    
        }];
        

        UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
        footView.backgroundColor = [UIColor whiteColor];
        _sureBtn=[[UIButton alloc]init];
        [_sureBtn setTitle:@"申请新定制" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = JHFont(15);
        [_sureBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _sureBtn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
        _sureBtn.layer.borderWidth = 0.5;
        _sureBtn.layer.cornerRadius = 22;
        _sureBtn.clipsToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(footView);
            make.top.equalTo(footView).offset(8);
            make.size.mas_equalTo(CGSizeMake(320, 44));
        }];
        
        _tableView.tableFooterView = footView;
        
        [_bar bringSubviewToFront:self.topView];
    }
    return self;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 44;
        
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayModel.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHCustomizApplyPopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellPop"];
    if (!cell) {
        cell = [[JHCustomizApplyPopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellPop"];
    }
    JH_WEAK(self);
    cell.completeBlock = ^{
        JH_STRONG(self);
        JHCustomizePopModel * model = self.arrayModel[indexPath.row];
        if (self.completeBlock) {
            [self hiddenAlert];
            self.completeBlock(model);
            
        }
        
    };
    [cell setCellDataModel:self.arrayModel[indexPath.row] andIndexPath:indexPath];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    JHCustomizePopModel * model = self.arrayModel[indexPath.row];
//    if (self.completeBlock) {
//        self.completeBlock(model);
//    }
    
}

- (void)close
{
    [self hiddenAlert];
}
- (void)cancelClick:(UIButton *)sender{
    
    [self hiddenAlert];
    
}
-(void)sureClick:(UIButton *)sender{
    [JHGrowingIO trackEventId:JHTrackCustomizelive_lmdz_tc_sqdz_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    JHCustomizeApplyProcessFirst *applyCustomizeView = [[JHCustomizeApplyProcessFirst alloc] initWithFrame:self.bounds andCustomizeId:self.customerId];
    applyCustomizeView.channelId = self.channelId;
    applyCustomizeView.completeBlock = self.completeBlock;
    [self.superview addSubview:applyCustomizeView];
    [applyCustomizeView showAlert];
    [self hiddenAlert];
}
- (void)showAlert
{
    self.bar.top =  self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom =  self.height;
    }];
     [self requestOrderList];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)hiddenAlert{
   [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
- (void)showEmptyView{
    self.tableView.hidden = YES;
    [_bar addSubview:self.emptyView];
    JHEmptyView * emView = [JHEmptyView new];
    [emView.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(emView).offset(20);
        make.centerX.equalTo(emView);
    }];
    [self.emptyView addSubview:emView];
    [_bar bringSubviewToFront:self.topView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_bar);
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.bottom.mas_equalTo(_bar.mas_bottom).offset(-UI.bottomSafeAreaHeight);
                
    }];
    [emView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView);
        make.top.equalTo(self.emptyView).offset(20);
        make.size.mas_equalTo(CGSizeMake(320, 163));
    }];
    [_emptyView addSubview:_sureBtn];
    [_sureBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.emptyView);
        make.top.mas_equalTo(emView.mas_bottom).offset(8);
        make.size.mas_equalTo(CGSizeMake(320, 44));
    }];
}
- (UIView *)emptyView{
    if (!_emptyView) {
        _emptyView = [UIView new];
        _emptyView.backgroundColor = [UIColor whiteColor];
    }
    return _emptyView;

//    [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.centerY.equalTo(self);
//        make.size.mas_equalTo([JHEmptyView viewSize]);
//    }];
}
-(void)requestOrderList{
    [SVProgressHUD show];
    JH_WEAK(self);
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/order/auth/getMaterialOrders") Parameters:@{@"customerId":self.customerId,@"channelId":self.channelId}
       successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        JH_STRONG(self);
        self.arrayModel = [JHCustomizePopModel mj_objectArrayWithKeyValuesArray:respondObject.data];

        if (self.arrayModel.count>0) {
            [self.tableView reloadData];
        }else{
            [self showEmptyView];
        }
        
    }
    failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        JH_STRONG(self);
        [self showEmptyView];
        [self makeToast:respondObject.message];

    }];
}
- (void)dealloc
{
    
}

@end
