//
//  JHCompanyAuthenticationController.m
//  TTjianbao
//
//  Created by lihui on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHCompanyAuthenticationController.h"
#import "JHAuthImageTableViewCell.h"

static NSString *const messageString = @"注：以上营业执照信息，根据国家工商总局《网络交易管理办法》要求对入驻商家营业执照信息进行公示，除企业名称通过认证之外，其余信息为卖家自行申请，如需进一步核实，请联系当地工商行政管理部门";

@interface JHCompanyAuthenticationController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
/**图片数组*/
@property (nonatomic, strong) NSMutableArray <NSString *>*authImageArray;
@end

@implementation JHCompanyAuthenticationController

- (NSMutableArray<NSString *> *)authImageArray {
    if (!_authImageArray) {
        _authImageArray = [NSMutableArray array];
    }
    return _authImageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"企业认证";
    [self setupUI];
}

- (void)setupUI {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.backgroundColor = kColorFFF;
    table.dataSource = self;
    table.delegate = self;
    table.estimatedRowHeight = 200.f;
    table.estimatedSectionFooterHeight = 0.1f;
    table.estimatedSectionHeaderHeight = 0.1f;
    [self.view addSubview:table];
    _tableView = table;
    [_tableView registerClass:[JHAuthImageTableViewCell class] forCellReuseIdentifier:kAuthIdentifer];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
    }];
    
    ///标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 56.)];
    titleLabel.text = @"天天鉴宝网店经营者营业执照信息";
    titleLabel.font = [UIFont fontWithName:kFontNormal size:18.];
    titleLabel.textColor = kColor222;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = titleLabel;
    
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 168.)];
    self.tableView.tableFooterView = messageView;

    ///底部展示信息
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = messageString;
    messageLabel.numberOfLines = 0;
    messageLabel.font = [UIFont fontWithName:kFontNormal size:14.];
    messageLabel.textColor = kColor666;
    [messageView addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(messageView).insets(UIEdgeInsetsMake(12, 13, 10, 11));
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.authImageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHAuthImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAuthIdentifer];
    cell.imageNameString = self.authImageArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
