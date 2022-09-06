//
//  JHAssistantViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/28.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHAssistantViewController.h"
#import "JHAssistantTableViewCell.h"
#import <IQKeyboardManager.h>
#import "BaseNavViewController.h"


@interface JHAssistantViewController () <UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate, UITextFieldDelegate>
{
    
}
@property(nonatomic, strong) UITableView *homeTable;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) UIView *inputView;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) NSIndexPath *deleteIndexPath;


@end

@implementation JHAssistantViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.homeTable];
    [self.view addSubview:self.inputView];
    
//    [self  initToolsBar];
//    [self.navbar setTitle:@"设置助理"];
    self.title = @"设置助理"; //背景颜色不一致
//    self.navbar.ImageView.hidden = YES;
//    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self requestData];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight-1, ScreenW, 1)];
    line.backgroundColor = HEXCOLOR(0xeeeeee);
//    [self.navbar addSubview:line];


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationController isKindOfClass:[PanNavigationController class]]) {
        PanNavigationController *nav = (PanNavigationController *)self.navigationController;
        nav.isForbidDragBack = YES;
    }

}

- (UITableView*)homeTable{
    
    if (!_homeTable) {
        
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight-50) style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.scrollEnabled=YES;
        _homeTable.separatorStyle = UITableViewCellSelectionStyleNone;
        _homeTable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _homeTable.backgroundColor=[UIColor clearColor];
        [_homeTable registerNib:[UINib nibWithNibName:NSStringFromClass([JHAssistantTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"JHAssistantTableViewCell"];

    }
    return _homeTable;
}


- (UIView *)inputView {
    if (!_inputView) {
        _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH-50, ScreenW, 50)];
        _inputView.backgroundColor = [UIColor whiteColor];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenW-156, 0, 156, 50);
        btn.backgroundColor = HEXCOLOR(0xfba028);
        [btn setTitle:@"添加助理" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        [_inputView addSubview:btn];
        [_inputView addSubview:self.textField];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
        line.backgroundColor = HEXCOLOR(0xeeeeee);
        [_inputView addSubview:line];
    }
    return _inputView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 6, ScreenW-15-156, 38)];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
        _textField.placeholder = @"请输入助理手机号";
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.layer.cornerRadius = 2;
        _textField.layer.masksToBounds = YES;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.delegate = self;
    }
    return _textField;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - tableviewDatesource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataArray count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"JHAssistantTableViewCell";
    JHAssistantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.model = self.dataArray[indexPath.section];
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除助理吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.deleteIndexPath = indexPath;
            [self deleteRequest];

        }]];
        [self presentViewController:alertVc animated:YES completion:nil];
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = HEXCOLOR(0xf7f7f7);
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}


#pragma mark - action
- (void)addAction:(UIButton *)btn {
    [_textField resignFirstResponder];
    if (_textField.text.length!=11) {
        [self.view makeToast:@"请填写正确的手机号码"];
        return;
    }
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/anchorAssistant") Parameters:@{@"phone":_textField.text} successBlock:^(RequestModel *respondObject) {
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/anchorAssistant") Parameters:@{@"assistantId":respondObject.data} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            self.textField.text = @"";
            [self.view makeToast:@"添加成功"];
            [self.dataArray addObject:[JHAssistantModel mj_objectWithKeyValues:respondObject.data]];
            [self hiddenDefaultImage];
            [self.homeTable reloadData];
        } failureBlock:^(RequestModel *respondObject) {
            [self.view makeToast:respondObject.message];

        }];

    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message];

    }];
}

- (void)requestData {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/anchorAssistant/all") Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.dataArray = [JHAssistantModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        [self.homeTable reloadData];
        if (self.dataArray.count) {
            [self hiddenDefaultImage];
        }else {
            [self showDefaultImageWithView:self.homeTable];
        }
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message];
        [self showDefaultImageWithView:self.homeTable];

    }];
}

- (void)deleteRequest {
    
    JHAssistantModel *model = self.dataArray[self.deleteIndexPath.section];
    [HttpRequestTool deleteWithURL:FILE_BASE_STRING(@"/auth/anchorAssistant") Parameters:@{@"anchorAssistantId":model.Id} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [self.view makeToast:@"删除成功"];
        [self.dataArray removeObjectAtIndex:self.deleteIndexPath.section];
        [self.homeTable deleteSections:[NSIndexSet indexSetWithIndex:self.deleteIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        if (self.dataArray.count) {
            [self hiddenDefaultImage];
        }else {
            [self showDefaultImageWithView:self.homeTable];
        }

    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message];

    }];
}

@end

