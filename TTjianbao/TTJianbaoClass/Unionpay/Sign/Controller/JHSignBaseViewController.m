//
//  JHSignBaseViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/4/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 签约页面填写账户信息等的基类

#import "JHSignBaseViewController.h"
#import "JHProcessView.h"
#import "JHUnionPayFooter.h"
#import "UserInfoRequestManager.h"
#import "JHUnionPayManager.h"

#define kTableHeaderHeight   75
#define kTableFooterHeight   (140+UI.bottomSafeAreaHeight)


@interface JHSignBaseViewController () <UITableViewDelegate, UITableViewDataSource, STPickerAreaDelegate, STPickerSingleDelegate>

@property (nonatomic, strong) JHProcessView *processView;
@property (nonatomic, strong) JHUnionPayFooter *tableFooter;
@property (nonatomic, assign) NSInteger selectIndex;   ///当前执行

@end

@implementation JHSignBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    [self initNav];
    [self configTableView];
    [self loadData];
}

#pragma mark - NavigationBar

- (void)initNav {
    self.title = JHLocalizedString(@"signContractTitle");
//    [self initToolsBar];
//    [self.navbar setTitle:JHLocalizedString(@"signContractTitle")];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0, 0, 44, 44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, UI.statusAndNavBarHeight, ScreenW-20, ScreenH - UI.statusAndNavBarHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = HEXCOLOR(0xF0F0F0);
    self.tableView.tableHeaderView = self.processView;
    self.tableView.tableFooterView = self.tableFooter;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    [self.view addSubview:self.tableView];
    
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 10, 0, 10));
    
    [self registerCell];
    @weakify(self);
    self.tableFooter.doneBlock = ^{
        @strongify(self);
        [self nextStep];
    };
}

#pragma mark - 下一步按钮的点击事件
- (void)nextStep {
}

#pragma mark - 注册cell
- (void)registerCell {
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifer = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)setCurrentSelectIndex:(NSInteger)currentSelectIndex {
    _selectIndex = currentSelectIndex;
    _processView.currentSelectIndex = _selectIndex;
}

- (JHProcessView *)processView {
    if (!_processView) {
        _processView = [[JHProcessView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, kTableHeaderHeight)];
        _processView.currentSelectIndex = 0;
        _processView.processArray = self.processDatas;
        _processView.backgroundColor = [UIColor clearColor];
    }
    return _processView;
}

- (JHUnionPayFooter *)tableFooter {
    if (!_tableFooter) {
        _tableFooter = [[JHUnionPayFooter alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, kTableFooterHeight)];
        _tableFooter.buttonTitle = JHLocalizedString(@"nextStep");
        _tableFooter.infoText = JHLocalizedString(@"tableFooterInfoText");
    }
    return _tableFooter;
}

- (void)setProcessDatas:(NSArray *)processDatas {
    _processDatas = processDatas;
    _processView.processArray = _processDatas;
}

- (void)loadData {
    int cutomerType = [[JHUnionPayManager shareManager].unionpayModel.customerType intValue];
    _customerType = cutomerType;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JHSignProcess" ofType:@"plist"];
    NSDictionary *dict =[NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *str = [self getKeyByCustomerType:cutomerType];
    if (!str) {
        return;
    }
    NSArray *listArray = [JHProcessModel mj_objectArrayWithKeyValuesArray:dict[str]];
    _processDatas = [NSArray arrayWithArray:listArray];
    [_processDatas enumerateObjectsUsingBlock:^(JHProcessModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isFinished) {
            obj.leftlineColor = HEXCOLOR(0xFFEE00);
            obj.rightlineColor = HEXCOLOR(0xE3E3E3);
        }
        else {
            obj.leftlineColor = HEXCOLOR(0xE3E3E3);
            obj.rightlineColor = HEXCOLOR(0xE3E3E3);
        }
    }];
    
    _processView.processArray = _processDatas;
    [_processView reloadData];
}

- (NSString *)getKeyByCustomerType:(int)type {
    switch (type) {
        case 0:
            return @"company";
            break;
        case 2:
            return @"personal";
            break;
        default:
            return @"personal";
            break;
    }
}

#pragma mark - pickerView相关

- (STPickerArea *)pickerView {
    if (!_pickerView) {
        _pickerView = [[STPickerArea alloc] init];
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (JHPickerView *)singlePicker {
    if (!_singlePicker) {
        _singlePicker = [[JHPickerView alloc] init];
        _singlePicker.widthPickerComponent = ScreenW - 30;
        _singlePicker.arrayData = @[].mutableCopy;
        _singlePicker.delegate = self;
    }
    return _singlePicker;
}

- (void)pickerArea:(STPickerArea *)pickerArea province:(JHProviceModel *)province city:(JHCityModel *)city area:(JHAreaModel *)area {
    
}

///单行picker的代理方法
- (void)pickerSingle:(STPickerSingle *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
