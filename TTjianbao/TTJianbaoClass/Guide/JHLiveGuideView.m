//
//  JHLiveGuideView.m
//  TTjianbao
//
//  Created by Jesse on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveGuideView.h"
#import "TTjianbao.h"
#import "TTjianbaoMarco.h"
#import "JHGuideModel.h"
#import "JHGuideTableViewCell.h"
#import "YDGuideManager.h"
#import "JHSQManager.h"
#import "JHDiscoverChannelModel.h"
#import "GrowingManager.h"
#import "JHRightArrowBtn.h"
#import "JHAppAlertViewManger.h"

@interface JHLiveGuideView () <UITableViewDelegate,UITableViewDataSource>
///标题
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, strong) UIImageView *televisionImage;

@end

@implementation JHLiveGuideView

- (void)dealloc
{
    NSLog(@"JHLiveGuideView dealloc!!");
    [JHAppAlertViewManger appAlertshowing:NO];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
        [self loadData];
        ///进入分流引导页埋点
        NSString *userId = [UserInfoRequestManager sharedInstance].user.customerId;
        NSDictionary *params = @{@"user_id":userId ? userId : @"",
                                @"time":@([[CommHelp getNowTimeTimestampMS] integerValue]),
                                @"deviceId":[GrowingManager getDeviceId]
        };
        [GrowingManager showGuidePage:params];
    }
    return self;
}

- (void)configUI {
    UILabel *label = ({
        label = [[UILabel alloc] init];
        label.textColor = kColor333;
        label.numberOfLines = 0;
        label.text = @"欢迎宝友来到天天鉴宝\n选择您首次想要浏览的内容";
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:label.text];
        [attriString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, label.text.length)];
        [attriString addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontMedium size:28] range:NSMakeRange(0 , 10)];
        [attriString addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontNormal size:18] range:NSMakeRange(10, label.text.length - 10)];
        label.textAlignment = NSTextAlignmentCenter;
        label.attributedText = attriString;
        label;
    });
    [self addSubview:label];
    _titleLabel = label;

    _titleLabel.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(self, UI.statusAndNavBarHeight+10)
    .heightIs(70);
    
    UITableView *table = ({
        table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.scrollEnabled = NO;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.tableFooterView = [[UIView alloc] init];
        [table registerClass:[JHGuideTableViewCell class] forCellReuseIdentifier:@"JHGuideTableViewCell"];
        table;
    });
    [self addSubview:table];
    _tableView = table;

    _tableView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(_titleLabel, 40)
    .heightIs(84*3+20+10);
    
    UIButton *jumpInBtn = [[UIButton alloc] init];
    [jumpInBtn setTitle:@"跳过，直接进入   " forState:UIControlStateNormal];
    [jumpInBtn setTitleColor:kColor999 forState:UIControlStateNormal];
    jumpInBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
    [jumpInBtn addTarget:self action:@selector(enterPage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:jumpInBtn];
    
    UIImageView *arrow = [UIImageView new];
    arrow.image = [UIImage imageNamed:@"icon_lanch_guide_arrow"];
    [jumpInBtn addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.trailing.equalTo(jumpInBtn);
    }];
    
    [jumpInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(30);
        make.centerX.equalTo(self);
    }];

    UIImageView *tvImage = [[UIImageView alloc] init];
    tvImage.backgroundColor = HEXCOLOR(0xffffff);
    tvImage.contentMode = UIViewContentModeScaleAspectFit;
    tvImage.image = [UIImage imageNamed:@"icon_guide_tel"];
    
    _televisionImage = tvImage;
    [self addSubview:tvImage];
        
    [_televisionImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-UI.bottomSafeAreaHeight-32);
        make.centerX.equalTo(self);
        make.leading.offset(15);
        make.trailing.offset(-15);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"JHGuideTableViewCell";
    JHGuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    JHGuideModel *model = self.datasource[indexPath.row];
    cell.guideModel = model;
    @weakify(self);
    cell.guideBlock = ^(JHGuideModel * _Nullable guideModel) {
        @strongify(self);
        [self enterPage:guideModel];
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 97;
}

///列表点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHGuideModel *model = self.datasource[indexPath.row];
    [self enterPage:model];
}

- (NSMutableArray *)getLocalChannelData:(NSString *)channelType {
    NSArray *arr;
    NSMutableArray *cateArr=[NSMutableArray array];
    NSData * data=[FileUtils readDataFromFile:channelType];
    if (data) {
        arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    if ([arr isKindOfClass:[NSArray class]]) {
        cateArr =[JHDiscoverChannelModel mj_objectArrayWithKeyValuesArray:arr];
    }
    return cateArr;
}

///界面的跳转事件
- (void)enterPage:(JHGuideModel *)model {
    if (![model isKindOfClass:[JHGuideModel class]]) {
        [self dismissView];
        [JHGrowingIO trackPublicEventId:JHTrackGuide_jump_with_cowry_click];
        return;
    }
    ///添加埋点!!!
    [self addGrowing:model.dataType];
    if (!model.vcName) {
        return;
    }
    ///点击后需要移除分流引导页 然后执行之后的方法
//    [self dismissViewControllerAnimated:NO completion:^{
//        [self configData:model];
//    }];
    [self dismissView];
    [self configData:model];
}

- (void)configData:(JHGuideModel *)model {
    [JHRootController toNativeVC:model.vcName withParam:@{@"selectedIndex":@(model.dataType)} from:@""];
    if (model.dataType == JHGuideDataTypeOriginBuy) {
        //首次进入显示引导视图
//        [YDGuideManager showStoreHomePageGuide];
    }
    if (model.dataType == JHGuideDataTypeCommunity) {  ///社区文玩
        
    }
}

///分流引导页list点击事件埋点 ----
- (void)addGrowing:(JHGuideDataType)type {
    NSString *userId = [UserInfoRequestManager sharedInstance].user.customerId;
    NSDictionary *params = @{@"user_id":userId ? userId : @"",
                            @"time":@([[CommHelp getNowTimeTimestampMS] integerValue]),
                            @"deviceId":[GrowingManager getDeviceId]
    };
    if (type == JHGuideDataTypeAuthenticate) {
        ///在线鉴定
        [GrowingManager authenticateClick:params];
    }
    else if (type == JHGuideDataTypeOriginBuy) {
        [GrowingManager storePageClick:params];
    }
    else {
        [GrowingManager chatWithCowryClick:params];
    }
}

- (void)loadData {
    NSArray *dataArray = [JHGuideModel mj_objectArrayWithFilename:@"JHGuide.plist"];
    _datasource = [NSMutableArray arrayWithArray:dataArray];
    [_tableView reloadData];
}

- (void)dismissView
{
    [self removeFromSuperview];
    [JHAppAlertViewManger appAlertshowing:NO];
}

@end
