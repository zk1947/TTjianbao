//
//  JHAppraiseRedPacketHistoryView.m
//  TTjianbao
//
//  Created by Jesse on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAppraiseRedPacketHistoryView.h"
#import "JHTableViewExt.h"
#import "SVProgressHUD.h"
#import "JHGrowingIO.h"

#define kCellHeight (23+8)

@interface JHAppraiseRedPacketHistoryView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView* bgview;
@property (nonatomic, strong) UIButton* closeView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* submitButton;
@property (nonatomic, strong) JHTableViewExt* tableview;
@property (nonatomic, strong) JHAppraiseRedPacketHistoryModel* dataModel;
@property (nonatomic, strong) NSString* appraiserId;
@property (nonatomic, strong) NSString* channelId;
@end

@implementation JHAppraiseRedPacketHistoryView

- (void)dealloc
{
    NSLog(@">>>AppraiseRedPacketHistory<<<");
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.backgroundColor = HEXCOLORA(0x0, 0.2);
    }
    return self;
}

- (void)showWithAppraiserId:(NSString*)appraiserId channelId:(NSString*)channelId
{
    self.appraiserId = appraiserId;
    self.channelId  = channelId;
    [JHKeyWindow  addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(JHKeyWindow);
    }];
    [self drawRedPacketSubview];
    [self requestHistoryData];
}

- (void)drawRedPacketSubview
{
    [self addSubview:self.bgview];
    
    [self.bgview addSubview:self.closeView];
    [self.closeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgview).offset(15-4);
        make.right.equalTo(self.bgview).offset(-(15-4));
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.bgview addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgview).offset(42);
        make.centerX.equalTo(self.bgview);
        make.left.right.mas_equalTo(self.bgview);
    }];
    
    [self.bgview addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgview);
        make.bottom.equalTo(self.bgview).offset(-30);
        make.size.mas_equalTo(CGSizeMake(160, 38));
    }];
    
    [self.bgview addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
        make.bottom.mas_equalTo(self.submitButton.mas_top).offset(-30);
        make.left.mas_equalTo(self.bgview).offset(25);
        make.right.mas_equalTo(self.bgview).offset(-15);
    }];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

#pragma mark - subviews
- (UIView *)bgview
{
    if(!_bgview)
    {
        _bgview = [UIView new];
        _bgview.backgroundColor = HEXCOLOR(0xFFFFFF);
        _bgview.layer.cornerRadius = 8;
        _bgview.layer.masksToBounds = YES;
    }
    return _bgview;
}

- (UIButton *)closeView
{
    if(!_closeView)
    {
        _closeView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeView setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
        [_closeView setImage:[UIImage imageNamed:@"btn_detect_close"] forState:UIControlStateNormal];
        [_closeView addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = JHMediumFont(18);
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)submitButton
{
    if(!_submitButton)
    {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.layer.cornerRadius = 20;
        _submitButton.layer.masksToBounds = YES;
        _submitButton.backgroundColor = HEXCOLOR(0xFEE100);
        [_submitButton.titleLabel setFont:JHFont(15)];
        [_submitButton setTitle:@"确认发布" forState:UIControlStateNormal];
        [_submitButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (JHTableViewExt *)tableview
{
    if(!_tableview)
    {
        _tableview = [[JHTableViewExt alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.backgroundColor = HEXCOLOR(0xFFFFFF);
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.scrollEnabled = NO;
    }
    return _tableview;
}

- (void)reloadViewContents
{
    if([self.dataModel.remainSendTimes integerValue] > 0)
    {
        _submitButton.userInteractionEnabled = YES;
        _submitButton.backgroundColor = HEXCOLOR(0xFEE100);
        self.titleLabel.text = [NSString stringWithFormat:@"今天还可发送 %@ 次红包", self.dataModel.remainSendTimes];
    }
    else
    {
        _submitButton.userInteractionEnabled = NO;
        _submitButton.backgroundColor = HEXCOLOR(0xEEEEEE);
        self.titleLabel.text = @"今天还可发送 0 次红包";
    }
    
    [self.tableview reloadData];
    CGFloat height = 170 + kCellHeight * self.dataModel.sendTimeDescList.count;
    if(height > 390)
    {
        height = 390; //最大高度
        _tableview.scrollEnabled = YES;
    }
    else
    {
        _tableview.scrollEnabled = NO;
    }
    [self.bgview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(260, height));
    }];
}

#pragma mark - table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataModel.sendTimeDescList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JHAppraiseRedPacketHistoryViewCell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JHAppraiseRedPacketHistoryViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = JHFont(13);
        cell.textLabel.textColor = HEXCOLOR(0x333333);
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    if(indexPath.row < self.dataModel.sendTimeDescList.count)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"• %@", self.dataModel.sendTimeDescList[indexPath.row]];
    }
    return cell;
}

- (void)submitAction
{
    [JHAppraiseRedPacketModel asynReqSendAppraiserId:self.appraiserId channelId:self.channelId Resp:^(NSString* msg, NSString* tips) {
        if(msg)
            [SVProgressHUD showErrorWithStatus:msg];
        else
            [SVProgressHUD showSuccessWithStatus:tips];
    }];
    [self dismiss];
    [JHGrowingIO trackPublicEventId:JHAppraiserSendGiftSuccess paramDict:@{@"roomId":self.channelId ? : @"", @"appraiserId":self.appraiserId ? : @""}];
}

- (void)closeAction
{
    [self dismiss];
}

#pragma mark - requuest
- (void)requestHistoryData
{
    [JHAppraiseRedPacketModel asynReqSendHistoryAppraiserId:self.appraiserId Resp:^(NSString* msg, JHAppraiseRedPacketHistoryModel* data) {
        if(msg)
            [SVProgressHUD showErrorWithStatus:msg];
        else
        {
            self.dataModel = data;
            [self reloadViewContents];
        }
    }];
}

@end
