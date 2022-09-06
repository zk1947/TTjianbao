//
//  JHSelectbankBranchViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/6/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSelectbankBranchViewController.h"
#import "JHProviceModel.h"
#import "JHUnionPayManager.h"
#import "JHUnionPayModel.h"

#define cellHeight 51.f
#define searchContainerHeight 60

@interface JHSelectbankBranchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

///记录用户搜索框内输入的文字 关键字
@property (nonatomic, copy) NSString *keyword;
///支行列表
@property (nonatomic, strong) NSMutableArray *bankBranchList;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *searchContainer;
@property (nonatomic, strong) UITextField *searchBar;
///是否在请求数据
@property (nonatomic, assign) BOOL isRequest;


@end

@implementation JHSelectbankBranchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isRequest = NO;
    [self configNav];
    [self configSearchBar];
    [self congfigUI];
}

- (void)configNav {
//    [self initToolsBar];
    self.title = JHLocalizedString(@"searchBankBranch");
//    [self.navbar setTitle:JHLocalizedString(@"searchBankBranch")];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0, 0, 44, 44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configSearchBar {
    _searchContainer = [[UIView alloc] init];
    _searchContainer.backgroundColor = kColorF5F6FA;
    [self.view addSubview:_searchContainer];
    
    _searchBar = [[UITextField alloc] init];
    _searchBar.backgroundColor = HEXCOLOR(0xffffff);
    _searchBar.placeholder = @"请输入关键词搜索";
    _searchBar.textColor = kColor666;
    _searchBar.font = [UIFont fontWithName:kFontNormal size:15.0];
    _searchBar.delegate = self;
    _searchBar.returnKeyType = UIReturnKeySearch;
    [_searchBar setTintColor:[UIColor colorWithHexString:@"FEE100"]];//光标颜色
    _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchBar.leftView = [self leftView];
    _searchBar.leftViewMode = UITextFieldViewModeAlways;
    [_searchBar addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [_searchContainer addSubview:self.searchBar];
        
    [_searchContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.height.mas_equalTo(searchContainerHeight);
    }];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.searchContainer).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    [_searchBar layoutIfNeeded];
    _searchBar.layer.cornerRadius = _searchBar.height/2;
    _searchBar.layer.masksToBounds = YES;
}

- (void)congfigUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.tableFooterView = [self footerView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.searchContainer.mas_bottom);
    }];
}

- (UIView *)leftView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 40)];
    view.backgroundColor = HEXCOLOR(0xffffff);
    return view;
}

- (UIView *)footerView {
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, UI.bottomSafeAreaHeight)];
    return footer;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self resetList];
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField.text.length == 0) {
        [self resetList];
    }
}

- (void)textFieldChanged:(UITextField *)textField {
    NSString *changeText = textField.text;
    //不支持系统表情的输入
    if ([NSString isStringContainsEmoji:changeText]) {
        NSLog(@"不支持输入表情");
        _searchBar.text = _keyword;
        return;
    }
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {   // 没有高亮选择的字，说明不是拼音输入
        NSString *upperCaseString = [textField.text uppercaseString];
        textField.text = upperCaseString;
        _keyword = changeText;
        ///通过关键字获取银行支行信息
        if ([_keyword isNotBlank]) {
            [self getBranchInfo];
        }
        else {
            [self resetList];
        }
    }
}

- (void)resetList {
    [self hiddenDefaultImage];
    [self.bankBranchList removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchBar endEditing:YES];
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
    if ([_keyword isNotBlank]) {
        [self getBranchInfo];
    }
    return YES;
}

#pragma mark -
#pragma mark - UITableViewDelegate / UITableViewSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bankBranchList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"bankBranchIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    JHUnionPaySubBankModel *model = self.bankBranchList[indexPath.row];
    cell.textLabel.text = model.bankBranchName;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHUnionPaySubBankModel *model = self.bankBranchList[indexPath.row];
    if (self.bankBranchBlock) {
        self.bankBranchBlock(model);
        [self backActionButton:nil];
    }
}

#pragma mark -
#pragma mark - data

- (void)getBranchInfo {
    if (![_keyword isNotBlank]) {
        return;
    }
    if (_isRequest) {
        return;
    }
    _isRequest = YES;
    @weakify(self);
    [JHUnionPayManager getBankSubBranch:self.cityModel.cityId key:_keyword completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        self.isRequest = NO;
        RequestModel *responseObj = (RequestModel *)respObj;
        if (!hasError && [self.keyword isNotBlank]) {
            NSArray *arr = responseObj.data[@"branchBankList"];
            NSMutableArray *branchBank = [NSMutableArray arrayWithArray:[JHUnionPaySubBankModel mj_objectArrayWithKeyValuesArray:arr]];
            self.bankBranchList = branchBank;
            [self.tableView reloadData];
            if (branchBank.count == 0) {
                [self showDefaultImageWithView:self.view];
            }
            else {
                [self hiddenDefaultImage];
            }
        }
        else {
            [self hiddenDefaultImage];
        }
    }];
}

- (NSMutableArray *)bankBranchList {
    if (!_bankBranchList) {
        _bankBranchList = [NSMutableArray array];
    }
    return _bankBranchList;
}

@end
