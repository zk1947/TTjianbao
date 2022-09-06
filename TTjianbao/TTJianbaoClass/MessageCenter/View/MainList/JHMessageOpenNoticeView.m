//
//  JHMessageOpenNoticeView.m
//  TTjianbao
//
//  Created by Jesse on 2020/2/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMessageOpenNoticeView.h"
#import "JHMessageOpenNoticeViewCell.h"
#import "CommHelp.h"
#import "JHGrowingIO.h"

@interface JHMessageOpenNoticeView () <UITableViewDelegate, UITableViewDataSource>
{
    UIView* noticeView; //弹窗view
    UIButton* closeBtn;
    UIButton* openBtn;
    UILabel* titleLabel;
    UILabel* subTitleLabel;
    NSTimeInterval beginShowTime;
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* dataArray;
@end

@implementation JHMessageOpenNoticeView

- (instancetype)init
{
    if(self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)])
    {
        self.backgroundColor = HEXCOLORA(0x0, 0.3);
        [self drawSubview];
        beginShowTime = [[NSDate date] timeIntervalSince1970];
    }
    return self;
}

- (void)drawSubview
{
    noticeView = [UIView new];
    noticeView.backgroundColor = HEXCOLOR(0xF7F7F7);
    noticeView.layer.cornerRadius = 4;
    [self addSubview:noticeView];
    [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(JHScaleToiPhone6(260), JHScaleToiPhone6(330)));
    }];
    //close
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"img_msg_notice_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(pressCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [noticeView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noticeView).offset(0);
        make.right.equalTo(noticeView).offset(0);
        make.size.mas_equalTo(40);
    }];
    
    titleLabel = [[UILabel alloc]init];
    titleLabel.font = JHMediumFont(15);
    titleLabel.textColor = HEXCOLOR(0x333333);
    titleLabel.text = @"开启消息通知";
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [noticeView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(21);
        make.top.equalTo(noticeView).offset(20);
        make.centerX.equalTo(noticeView);
    }];
    
    subTitleLabel = [[UILabel alloc]init];
    subTitleLabel.font = JHFont(11);
    subTitleLabel.textColor = HEXCOLOR(0x666666);
    subTitleLabel.text = @"您将及时收到";
    subTitleLabel.numberOfLines = 1;
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [noticeView addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(16);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(5);
        make.centerX.equalTo(noticeView);
    }];
    
    UIView* leftLine = [UIView new];
    leftLine.backgroundColor = HEXCOLOR(0xCCCCCC);
    [noticeView addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 1));
        make.right.mas_equalTo(subTitleLabel.mas_left).offset(-3);
        make.centerY.equalTo(subTitleLabel);
    }];
    
    UIView* rightLine = [UIView new];
    rightLine.backgroundColor = HEXCOLOR(0xCCCCCC);
    [noticeView addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 1));
        make.left.mas_equalTo(subTitleLabel.mas_right).offset(3);
        make.centerY.equalTo(subTitleLabel);
    }];

    //open
    openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn.backgroundColor = HEXCOLORA(0xFEE100, 1);
    openBtn.titleLabel.font = JHFont(15);
    openBtn.layer.cornerRadius = JHScaleToiPhone6(40)/2.0;
    [openBtn setTitle:@"去开启" forState:UIControlStateNormal];
    [openBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [openBtn addTarget:self action:@selector(pressOpenButton) forControlEvents:UIControlEventTouchUpInside];
    [noticeView addSubview:openBtn];
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(noticeView).offset(-20);
        make.centerX.equalTo(noticeView);
        make.size.mas_equalTo(CGSizeMake(JHScaleToiPhone6(200), JHScaleToiPhone6(40)));
    }];
    
    //table
    [noticeView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(subTitleLabel.mas_bottom).offset(20);
        make.bottom.mas_equalTo(openBtn.mas_top).offset(-15);
        make.left.right.equalTo(noticeView);
    }];
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSArray *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = [JHMessageOpenNoticeModel dataArray];
    }
    return _dataArray;
}

#pragma mark - delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHMessageOpenNoticeViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"JHMessageOpenNoticeViewCellKey"];
    if(!cell)
    {
        cell = [[JHMessageOpenNoticeViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JHMessageOpenNoticeViewCellKey"];
    }
    [cell setModel:self.dataArray[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

#pragma mark - event
- (void)pressCloseButton
{
    [self dismissView];
    [JHGrowingIO trackPublicEventId:JHTrackMsgCenterPushCloseClick];
}

- (void)pressOpenButton
{
    [CommHelp goToAppSystemSetting];
    [self dismissView];
    [JHGrowingIO trackPublicEventId:JHTrackMsgCenterPushOpenClick];
}

- (void)dismissView
{
    [self removeFromSuperview];
    NSTimeInterval endShowTime = [[NSDate date] timeIntervalSince1970];
    NSString *duration = [NSString stringWithFormat:@"%.f", endShowTime - beginShowTime];
    [JHGrowingIO trackPublicEventId:JHTrackMsgCenterPushDuration paramDict:@{@"duration":duration}];
}

@end
