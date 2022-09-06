//
//  JHShopListViewController.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHShopListViewController.h"
#import "JHShoplistTableCell.h"
#import "JHNormalListView.h"
#import "JHResultListView.h"
#import "JHSellerInfo.h"

struct YDTextFieldInfo {
    NSInteger length;
    NSInteger number;
};
typedef struct YDTextFieldInfo TextFieldInfo;

static const NSInteger maxLength = 30; //最大输入字符数（中文两个字符，英文数字1个字符）


@interface JHShopListViewController () <UITextFieldDelegate>

@property (nonatomic, strong) JHNormalListView *normalListView;
@property (nonatomic, strong) JHResultListView *resultListView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, copy) NSString *inputText;

@end

@implementation JHShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavBar];
    [self initViews];
    
    [self __addKeyboardObserver];
    
    ///修改关注状态更新数据
    @weakify(self);
    [[[JHNotificationCenter rac_addObserverForName:ShopRefreshDataNotication object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self refreshData:notification];
    }];
}

///从店铺主页返回后刷新数据
- (void)refreshData:(NSNotification *)noti {
    JHSellerInfo *info = (JHSellerInfo *)noti.object;
    [_normalListView changeSellerInfos:info];
    if (_normalListView.hidden) {
        [_resultListView changeSellerInfos:info];
    }
}

- (void)initViews {
    _normalListView = [[JHNormalListView alloc] initWithFrame:CGRectZero];
    _normalListView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_normalListView];
    
    [_normalListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(UI.statusAndNavBarHeight));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(@(UI.bottomSafeAreaHeight));
    }];
    
    _resultListView = [[JHResultListView alloc] initWithFrame:CGRectZero];
    _resultListView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_resultListView];
       
    [_resultListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(UI.statusAndNavBarHeight));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(@(UI.bottomSafeAreaHeight));
    }];
    
    _resultListView.hidden = YES;
}

- (void)configNavBar {
//    [self initToolsBar];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    ///添加搜索框
    [self configSearchBar];
}

- (void)configSearchBar {
    _searchView = [[UIView alloc] initWithFrame:CGRectMake(42, 0, ScreenW - 42 - 15, 28)];
    _searchView.centerY = UI.statusAndNavBarHeight - UI.navBarHeight/2.0;//self.jhLeftButton.centerY;
    [self.jhNavView addSubview:_searchView];
    
    _searchBar = [[UITextField alloc] initWithFrame:_searchView.bounds];
    _searchBar.backgroundColor = HEXCOLOR(0xEEEEEE);
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入店铺名称";
    _searchBar.textColor = kColor999;
    _searchBar.font = [UIFont fontWithName:kFontNormal size:13.0];
    _searchBar.leftView = [self leftView];
    _searchBar.leftViewMode = UITextFieldViewModeAlways;
    _searchBar.returnKeyType = UIReturnKeySearch;
    [_searchBar setTintColor:[UIColor colorWithHexString:@"FEE100"]];//光标颜色
    _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchBar.layer.cornerRadius = _searchBar.height/2;
    [_searchBar addTarget:self action:@selector(textFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_searchBar addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

    [_searchView addSubview:_searchBar];
    [_searchView addSubview:self.cancelBtn];
    self.cancelBtn.hidden = YES;
}

#pragma mark -
#pragma mark - UITextField Methods
- (void)textFieldDidBegin:(UITextField *)field {
    NSString *text = field.text;
    NSLog(@"textFieldDidBegin::text = %@", text);
    [self showCancelBtn];
    //首次输入时
    if ([text isNotBlank]) {
        [self showResultView:YES];
    }
}

//控制搜索结果页显示和隐藏
- (void)showResultView:(BOOL)isVisible  {
    _normalListView.hidden = isVisible;
    _resultListView.hidden = !isVisible;
}

- (void)textFieldChanged:(UITextField *)field {
    NSString *changeText = field.text;
    NSLog(@"textFieldChanged::curent text = %@", changeText);
    
    //不支持系统表情的输入
    if ([NSString isStringContainsEmoji:changeText]) {
        NSLog(@"不支持输入表情");
        field.text = _inputText;
    }
    
    UITextRange *selectedRange = [field markedTextRange];
    UITextPosition *position = [field positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文被截断
    if (!position) {
        TextFieldInfo info = [self getInfoWithText:changeText maxLength:maxLength];
        if (info.length > maxLength) {
            field.text = [field.text substringToIndex:info.number];
        }
    }

    _inputText = changeText;
    if ([_inputText isNotBlank]) {
        [self showResultView:YES];
    } else {
        [self showResultView:NO];
    }
    
    _resultListView.keyword = _inputText;
}

- (UIView *)leftView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 30)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dis_glasses"]];
    imgView.center = CGPointMake(16 + 5, 15.0);
    [view addSubview:imgView];
    return view;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(_searchView.width - 50, 0, 50, _searchView.height);
        _cancelBtn.centerY = self.searchBar.centerY;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        @weakify(self);
        [[_cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.searchBar endEditing:YES];
            [self hideCancelBtn];
        }];
    }
    return _cancelBtn;
}

- (void)showCancelBtn {
    [UIView animateWithDuration:0.2 animations:^{
        self.searchBar.width = self.searchBar.width - 54;
    } completion:^(BOOL finished) {
        self.cancelBtn.hidden = NO;
    }];
}

- (void)hideCancelBtn {
    self.cancelBtn.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.searchBar.width = self.searchView.width;
    } completion:^(BOOL finished) {
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchBar endEditing:YES];
    [self hideCancelBtn];
    return YES;
}

#pragma mark - action
//判断中英混合的的字符串长度及字符个数
- (TextFieldInfo)getInfoWithText:(NSString *)text maxLength:(NSInteger)maxLength {
    int length = 0;
    int singleNum = 0;
    int totalNum = 0;
    char *p = (char *)[text cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            length++;
            if (length <= maxLength) {
                totalNum++;
            }
        } else {
            if (length <= maxLength) {
                singleNum++;
            }
        }
        p++;
    }
    
    TextFieldInfo fieldInfo;
    fieldInfo.length = length;
    fieldInfo.number = (totalNum - singleNum) / 2 + singleNum;
    return fieldInfo;
}

- (void)__addKeyboardObserver {
    @weakify(self);
    [[[JHNotificationCenter rac_addObserverForName:UIKeyboardWillHideNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self hideCancelBtn];
    }];
}

@end
