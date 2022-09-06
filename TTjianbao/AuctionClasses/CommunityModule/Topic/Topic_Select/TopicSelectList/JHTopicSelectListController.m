//
//  JHTopicSelectListController.m
//  TTjianbao
//
//  Created by wuyd on 2019/7/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHTopicSelectListController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "CTopicModel.h"
#import "JHTopicSelectListView.h"
#import "JHTopicSearchResultView.h"
#import "BaseNavViewController.h"


struct YDTextFieldInfo {
    NSInteger length;
    NSInteger number;
};
typedef struct YDTextFieldInfo TextFieldInfo;

static const NSInteger maxLength = 30; //最大输入字符数（中文两个字符，英文数字1个字符）

@interface JHTopicSelectListController () //<UISearchBarDelegate>

@property (nonatomic, copy) void(^doneBlock)(CTopicData * _Nullable data);

@property (nonatomic, strong) CTopicModel *curModel;
@property (nonatomic, strong) CTopicData *defaultData;

@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) JHTopicSelectListView *listView;
@property (nonatomic, strong) JHTopicSearchResultView *resultView;

@property (nonatomic,   copy) NSString *inputText;

@end


@implementation JHTopicSelectListController

+ (void)showFromVC:(UIViewController *)preVC defaultData:(nullable CTopicData *)defaultData doneBlock:(void(^)(CTopicData * _Nullable data))block {
    JHTopicSelectListController *topicVC = [[JHTopicSelectListController alloc] init];
    topicVC.defaultData = defaultData;
    topicVC.doneBlock = block;
    
    BaseNavViewController *topicNav = [[BaseNavViewController alloc] initWithRootViewController:topicVC];
    [preVC presentViewController:topicNav animated:YES completion:nil];
    
}


#pragma mark -
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self configSearchBar];
    
    [self configListView];
    [self configSearchResultView];
    
    _curModel = [[CTopicModel alloc] init];
    
    //埋点
    [Growing track:@"topicselect"];
}


#pragma mark -
#pragma mark - UI Methods

- (void)configSearchBar {
    UIView *searchContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, UI.statusAndNavBarHeight)];
    [self.view addSubview:searchContainer];
    
    _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(15, UI.statusAndNavBarHeight-30.0, ScreenWidth-74, 30)];
    //_searchBar.delegate = self;
    _searchBar.placeholder = @"搜索更多话题";
    _searchBar.textColor = kColor333;
    _searchBar.font = [UIFont fontWithName:kFontNormal size:14.0];
    _searchBar.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    _searchBar.leftView = [self leftView];
    _searchBar.leftViewMode = UITextFieldViewModeAlways;
    _searchBar.returnKeyType = UIReturnKeySearch;
    [_searchBar setTintColor:[UIColor colorWithHexString:@"FEE100"]];//光标颜色
    _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchBar.layer.cornerRadius = 15.f;
    [_searchBar addTarget:self action:@selector(textFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_searchBar addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [searchContainer addSubview:self.searchBar];
    [searchContainer addSubview:self.cancelBtn];
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
        _cancelBtn.frame = CGRectMake(ScreenWidth-70, UI.statusAndNavBarHeight-30.0, 70, 30);
        _cancelBtn.centerY = self.searchBar.centerY;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        //[_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        @weakify(self);
        [[_cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.searchBar endEditing:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _cancelBtn;
}

- (void)configListView {
    _listView = [[JHTopicSelectListView alloc] init];
    [self.view addSubview:_listView];
    
    @weakify(self);
    _listView.didSelectedBlock = ^(CTopicData * _Nonnull data) {
        NSLog(@"选择了话题");
        @strongify(self);
        [self didSelectedTopicData:data];
    };
    
    [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(8);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(UI.bottomSafeAreaHeight);
    }];
}

- (void)configSearchResultView {
    _resultView = [[JHTopicSearchResultView alloc] init];
    [self.view addSubview:_resultView];
    
    @weakify(self);
    _resultView.didSelectedBlock = ^(CTopicData * _Nonnull data) {
        NSLog(@"选择了话题");
        @strongify(self);
        [self didSelectedTopicData:data];
    };
    
    [_resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(8);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(UI.bottomSafeAreaHeight);
    }];
    _resultView.hidden = YES;
}

//选择了话题
- (void)didSelectedTopicData:(CTopicData *)data {
    if (self.doneBlock) {
        self.doneBlock(data);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//控制搜索结果页显示和隐藏
- (void)showResultView:(BOOL)isVisible  {
    _listView.hidden = isVisible;
    _resultView.hidden = !isVisible;
}


#pragma mark -
#pragma mark - UITextField Methods

- (void)textFieldDidBegin:(UITextField *)field {
    NSString *text = field.text;
    NSLog(@"text = %@", text);
    //首次输入时
    if ([text isNotBlank]) {
        [self showResultView:YES];
    }
}

- (void)textFieldChanged:(UITextField *)field {
    NSString *changeText = field.text;
    
    //不支持系统表情的输入
    if ([NSString isStringContainsEmoji:changeText]) {
        NSLog(@"不支持输入表情");
        _searchBar.text = _inputText;
        return;
    }
    
    UITextRange *selectedRange = [field markedTextRange];
    UITextPosition *position = [field positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文被截断
    if (!position) {
        TextFieldInfo info = [self getInfoWithText:changeText maxLength:maxLength];
        if (info.length > maxLength) {
            _searchBar.text = [field.text substringToIndex:info.number];
        }
    }
    
    _inputText = changeText;
    
    if ([_inputText isNotBlank]) {
        [self showResultView:YES];
    } else {
        [self showResultView:NO];
    }
    _resultView.keywordStr = _inputText;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchBar endEditing:YES];
    return YES;
}

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

@end
