//
//  JHChatCouponViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatCouponViewController.h"
#import "JHChatCouponListCell.h"
#import "CommAlertView.h"

@interface JHChatCouponViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) NSMutableArray<JHChatCouponInfoModel *> *selectedData;
@end

@implementation JHChatCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self registerCells];
    [self bindData];
    [self.tableView reloadData];
    
    CGFloat height = 100;
    if (self.dataSource.count < 4) {
        height = self.dataSource.count * 100;
        self.tableView.scrollEnabled = false;
    }else {
        height = 300;
        self.tableView.scrollEnabled = true;
    }
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.containerView jh_cornerRadius:10 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight bounds:self.containerView.bounds];
}

- (void)didClickSend : (UIButton *)sender{
    if (self.selectedData.count == 0) return;
    
    NSString *text = [NSString stringWithFormat:@"%lu", (unsigned long)self.selectedData.count];
    
    NSDictionary *muDic = @{NSForegroundColorAttributeName : HEXCOLOR(0xff0a0a)};
    NSDictionary *dic = @{NSForegroundColorAttributeName : HEXCOLOR(0x333333)};
    NSMutableAttributedString *mutext = [[NSMutableAttributedString alloc] initWithString:text attributes:muDic];
    NSAttributedString *te = [[NSAttributedString alloc] initWithString:@"张优惠券直接到用户账号，确认发放么？" attributes:dic];
    [mutext appendAttributedString:te];
    
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@""
                                                 andMutableDesc:mutext
                                                 cancleBtnTitle:@"取消"
                                                   sureBtnTitle:@"确认"
                                                     andIsLines:false];
    
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    
    @weakify(self)
    alert.handle = ^{
        @strongify(self)
        
        [self.sendSubject sendNext:self.selectedData];
        [self dismissViewControllerAnimated:true completion:nil];
    };
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHChatCouponInfoModel *model = self.dataSource[indexPath.row];
    model.isSelected = !model.isSelected;
    if (model.isSelected) {
        [[self mutableArrayValueForKey:@"selectedData"] addObject:model];
        
    }else {
        [[self mutableArrayValueForKey:@"selectedData"] removeObject:model];
    }
}

- (void)bindData {
    [RACObserve(self, selectedData) subscribeNext:^(id  _Nullable x) {
        NSArray *arr = x;
        if (arr.count == 0) {
            self.sendButton.userInteractionEnabled = false;
            [self.sendButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        }else {
            self.sendButton.userInteractionEnabled = true;
            [self.sendButton setTitleColor:HEXCOLOR(0xffa900) forState:UIControlStateNormal];
        }
    }];
}
#pragma mark - UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.sendButton];
    [self.containerView addSubview:self.tableView];
    [self.containerView addSubview:self.alertLabel];
    [self layoutViews];
}
- (void)layoutViews {
    
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(-26);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(0);
        make.bottom.mas_equalTo(self.alertLabel.mas_top).offset(-20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-(46 + UI.bottomSafeAreaHeight));
    }];
}
- (void)registerCells {
    [self.tableView registerClass:[JHChatCouponListCell class] forCellReuseIdentifier:@"JHChatCouponListCell"];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch.view == self.view) {
            [self dismissViewControllerAnimated:true completion:nil];
            return;
        }
    }
}

#pragma mark - Tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHChatCouponInfoModel *model = self.dataSource[indexPath.row];
    JHChatCouponListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHChatCouponListCell" forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return [[UIView alloc] initWithFrame:CGRectZero];
//}
#pragma mark - LAZY

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _containerView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0x222222);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:16];
        _titleLabel.text = @"代金券发放";
    }
    return _titleLabel;
}
- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_sendButton setTitle:@"发放" forState:UIControlStateNormal];
        [_sendButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        [_sendButton addTarget:self action:@selector(didClickSend:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.backgroundColor = HEXCOLOR(0xffffff);
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}
- (UILabel *)alertLabel {
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _alertLabel.textColor = HEXCOLOR(0x999999);
        _alertLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.text = @"注：发放后直接到用户账号，不需领取";
    }
    return _alertLabel;
}
- (NSMutableArray<JHChatCouponInfoModel *> *)selectedData {
    if (!_selectedData) {
        _selectedData = [[NSMutableArray alloc] init];
    }
    return _selectedData;
}
- (RACSubject<NSArray<JHChatCouponInfoModel *> *> *)sendSubject {
    if (!_sendSubject) {
        _sendSubject = [RACSubject subject];
    }
    return _sendSubject;
}
@end
