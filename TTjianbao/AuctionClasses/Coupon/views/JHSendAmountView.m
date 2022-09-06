//
//  JHSendAmountView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/3/29.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHSendAmountCell.h"
#import "JHSendAmountView.h"
#import "CoponPackageMode.h"
#import "TTjianbaoHeader.h"


@interface JHSendAmountView () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (nonatomic, strong) NSMutableArray<CoponPackageMode *> *dataArray;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end

@implementation JHSendAmountView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cancelBtn.layer.borderColor = HEXCOLOR(0x999999).CGColor;
    self.cancelBtn.layer.borderWidth = 1;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHSendAmountCell class]) bundle:nil] forCellReuseIdentifier:@"JHSendAmountCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 100;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHSendAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHSendAmountCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    if (self.selectedIndex == indexPath.row) {

        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

    }else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
}

#pragma mark - 请求数据

- (void)requestList {

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"viewerId"] = self.viewerId;
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/coupon/anchor/grant/auth") Parameters:dic successBlock:^(RequestModel *respondObject) {
        NSArray *array = [CoponPackageMode mj_objectArrayWithKeyValuesArray:respondObject.data];
        [self dealDataWithDic:array];

    } failureBlock:^(RequestModel *respondObject) {
        [self makeToast:respondObject.message];
    }];
}

- (void)dealDataWithDic:(NSArray *)arr {
    if (arr.count) {
        self.tableView.backgroundColor = [UIColor whiteColor];
    }else {
        self.tableView.backgroundColor = [UIColor clearColor];
    }
    self.dataArray = [NSMutableArray arrayWithArray:arr];
    [self.tableView reloadData];
}
#pragma mark -

- (void)showAlert {
    CGRect rect = self.frame;
    self.mj_y = ScreenH;
    
    rect.origin.y = ScreenH - rect.size.height;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    [self requestList];
}

- (void)hiddenAlert {
    CGRect rect = self.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}




- (IBAction)closeAction:(id)sender {
    [self hiddenAlert];
}

- (IBAction)sendAction:(id)sender {

    if (self.selectedIndex<self.dataArray.count) {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"确定发送红包吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self sendRequestList];
        }]];
        [self.viewController presentViewController:alertVc animated:YES completion:nil];

    }else {
        if (self.dataArray.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"没有红包可发送~"];
        }
    }

}


- (void)sendRequestList {
    
    if (self.selectedIndex<self.dataArray.count) {
        [self hiddenAlert];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"viewerId"] = self.viewerId;
        dic[@"couponId"] = self.dataArray[self.selectedIndex].Id;
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/coupon/grant/auth") Parameters:dic requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD showErrorWithStatus:respondObject.message];
        }];
    }
   
}
- (NSMutableArray<CoponPackageMode *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}


@end

@implementation JHRecvAmountView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)okAction:(id)sender {
    [SVProgressHUD showSuccessWithStatus:@"领取成功！"];
    [self hiddenAlert];
}
- (IBAction)closeAction:(id)sender {
    [self hiddenAlert];
}


- (void)setModel:(CoponPackageMode *)model {
    _model = model;
    self.amoutLabel.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.desStringLabel.text = model.name;

}


#pragma mark -

- (void)showAlert {
    CGRect rect = self.frame;
    self.mj_y = ScreenH;
    
    rect.origin.y = ScreenH - rect.size.height;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
}

- (void)hiddenAlert {
    CGRect rect = self.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}
@end

