//
//  JHTopicListController.m
//  TTjianbao
//
//  Created by wuyd on 2019/12/10.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHTopicListController.h"
#import "CTopicModel.h"
#import "JHTopicListView.h"
#import "JHTopicListSearchResultView.h"
#import "JHTopicDetailController.h"

struct YDTextFieldInfo {
    NSInteger length;
    NSInteger number;
};
typedef struct YDTextFieldInfo TextFieldInfo;

static const NSInteger maxLength = 30; //最大输入字符数（中文两个字符，英文数字1个字符）

@interface JHTopicListController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *searchContainer;
@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic,   copy) NSString *inputText;

@property (nonatomic, strong) JHTopicListView *listView;
@property (nonatomic, strong) JHTopicListSearchResultView *resultView;

@end

@implementation JHTopicListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNaviBar];
    [self configSearchBar];
    
    [self configListView];
    [self configSearchResultView];
    
    [self __addKeyboardObserver];
}

#pragma mark -
#pragma mark - 输入框方法

//监听键盘消失
- (void)__addKeyboardObserver {
    @weakify(self);
    [[[JHNotificationCenter rac_addObserverForName:UIKeyboardWillHideNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self hideCancelBtn];
    }];
}

- (void)configNaviBar {
    [self showNaviBar];
    //self.naviBar.titleLabel.alpha = 0;
    self.naviBar.title = @"话题列表";
    self.naviBar.leftImage = kNavBackBlackImg;
    self.naviBar.bottomLine.hidden = NO;
}

- (void)configSearchBar {
    _searchContainer = [[UIView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenWidth, 50)];
    [self.view addSubview:_searchContainer];
    
    _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, ScreenWidth-30, 30)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"搜索话题";
    _searchBar.textColor = kColor333;
    _searchBar.font = [UIFont fontWithName:kFontNormal size:13.0];
    _searchBar.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    _searchBar.leftView = [self leftView];
    _searchBar.leftViewMode = UITextFieldViewModeAlways;
    _searchBar.returnKeyType = UIReturnKeySearch;
    [_searchBar setTintColor:[UIColor colorWithHexString:@"FEE100"]];//光标颜色
    _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchBar.layer.cornerRadius = 15.f;
    [_searchBar addTarget:self action:@selector(textFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_searchBar addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [_searchContainer addSubview:self.searchBar];
    [_searchContainer addSubview:self.cancelBtn];
    self.cancelBtn.hidden = YES;
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, _searchContainer.height, ScreenWidth, 0.5)];
    bottomLine.backgroundColor = kColorEEE;
    [_searchContainer addSubview:bottomLine];
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
        _cancelBtn.frame = CGRectMake(ScreenWidth-70, 10, 70, 30);
        _cancelBtn.centerY = self.searchBar.centerY;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:kColor999 forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        @weakify(self);
        [[_cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.searchBar endEditing:YES];
            [self hideCancelBtn];;
        }];
    }
    return _cancelBtn;
}

- (void)showCancelBtn {
    [UIView animateWithDuration:0.2 animations:^{
        self.searchBar.width = ScreenWidth-74;
        
    } completion:^(BOOL finished) {
        self.cancelBtn.hidden = NO;
    }];
}

- (void)hideCancelBtn {
    self.cancelBtn.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.searchBar.width = ScreenWidth-30;
    } completion:^(BOOL finished) {
    }];
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

#pragma mark -
#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchBar endEditing:YES];
    [self hideCancelBtn];
    return YES;
}


#pragma mark -
#pragma mark - ListView Methods


//控制搜索结果页显示和隐藏
- (void)showResultView:(BOOL)isVisible  {
    _listView.hidden = isVisible;
    _resultView.hidden = !isVisible;
}

//默认列表页
- (void)configListView {
    _listView = [[JHTopicListView alloc] init];
    [self.view addSubview:_listView];
    
    @weakify(self);
    _listView.didSelectedBlock = ^(CTopicData * _Nonnull data) {
        NSLog(@"选择了话题");
        @strongify(self);
        [self enterTopicDetailVCWithData:data];
    };
    
    [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchContainer.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(UI.bottomSafeAreaHeight);
    }];
}

//搜索结果页
- (void)configSearchResultView {
    _resultView = [[JHTopicListSearchResultView alloc] init];
    [self.view addSubview:_resultView];
    
    @weakify(self);
    _resultView.didSelectedBlock = ^(CTopicData * _Nonnull data) {
        NSLog(@"选择了话题");
        @strongify(self);
        [self enterTopicDetailVCWithData:data];
    };
    
    [_resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchContainer.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(UI.bottomSafeAreaHeight);
    }];
    _resultView.hidden = YES;
}


#pragma mark -
#pragma mark - 页面跳转
- (void)enterTopicDetailVCWithData:(CTopicData *)data {
    ///340埋点 - 话题进入事件
    [JHGrowingIO trackEventId:JHTrackSQTopicDetailEnter];

    JHTopicDetailController *vc = [JHTopicDetailController new];
    vc.topicId = data.item_id;
    [self.navigationController pushViewController:vc animated:YES];
    
    //埋点 - 进入话题详情埋点
    [self buryPointWithTopicId:data.item_id];
}

//新增进入话题页埋点
- (void)buryPointWithTopicId:(NSString *)topicId {
    JHBuryPointEnterTopicDetailModel *pointModel = [JHBuryPointEnterTopicDetailModel new];
    pointModel.entry_type = 11;
    pointModel.entry_id = @"0";
    pointModel.topic_id = topicId;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    pointModel.time = timeSp;
    [[JHBuryPointOperator shareInstance] enterTopicDetailWithModel:pointModel];
}

@end
