//
//  JHC2CProductDetailAccusationViewController.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailAccusationViewController.h"

@interface JHC2CProductDetailAccusationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView * tableView;
@property(nonatomic, strong) NSArray * reasonDataArr;
@end

@implementation JHC2CProductDetailAccusationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择举报原因";
    [self setItems];
    [self layoutItems];
}

- (void)setItems{
    [self.view addSubview:self.tableView];
}

- (void)layoutItems{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.top.equalTo(self.jhNavView.mas_bottom);
    }];
}

#pragma mark -- <UITableViewDelegate and UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    cell.textLabel.text = self.reasonDataArr[indexPath.row];
    cell.textLabel.font  = JHFont(14);
    cell.textLabel.textColor =  HEXCOLOR(0x333333);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [self showInputTextView];
}


#pragma mark -- <get and set>


- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *view = [[UITableView alloc] init];
        view.delegate = self;
        view.dataSource = self;
        view.tableFooterView = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        view.estimatedRowHeight = 0;
        [view registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
        _tableView = view;
    }
    return _tableView;
}

- (NSArray *)reasonDataArr{
    return @[@"存在违反国家法律法规的内容", @"存在泄露他人隐私信息的内容",
             @"存在辱骂、中伤、诽谤他人的内容", @"存在夸大、过渡宣传、站外联系方式等内容",
             @"存在色情、淫秽、低俗等不适内容"
    ];
}
@end
