//
//  JHDiscountCoponListView.m
//  TTjianbao
//
//  Created by jiang on 2020/1/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHDiscountCoponListView.h"
#import "JHDiscountCoponTableViewCell.h"
#import "JHMyCouponTableViewCell.h"
#import "TTjianbaoHeader.h"
#import "CustomToolsBar.h"
@interface JHDiscountCoponListView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger selectIndex;
    NSIndexPath * lastSelectIndexPath;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CustomToolsBar *navbar;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (strong, nonatomic)  NSMutableArray *dataArray;
@end

@implementation JHDiscountCoponListView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    [self addSubview:self.backView];
    
    self.navbar = [[CustomToolsBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50-1)];
    [self.backView addSubview:_navbar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.navbar.bounds];
    label.text = @"折扣活动";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = HEXCOLOR(0x222222);
    label.font = [UIFont systemFontOfSize:16];
    [self.navbar addSubview:label];
    
    [self.backView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backView).insets(UIEdgeInsetsMake(CGRectGetMaxY(self.navbar.frame)+1, 0, UI.bottomSafeAreaHeight+60, 0));
        
    }];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"icon_alert_close"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navbar addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.navbar);
        make.trailing.equalTo(self.navbar);
        make.width.height.equalTo(@50);
    }];
    
    UIButton *complete = [UIButton buttonWithType:UIButtonTypeCustom];
    //[complete setImage:[UIImage imageNamed:@"icon_alert_close"] forState:UIControlStateNormal];
    complete.titleLabel.font= [UIFont systemFontOfSize:14];
    [complete setTitle:@"确定" forState:UIControlStateNormal];
    complete.layer.cornerRadius = 22.0;
    [complete setBackgroundColor:HEXCOLOR(0xff6601)];
    [complete addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:complete];
    [complete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.bottom.equalTo(self.backView).offset(-8);
        make.height.equalTo(@44);
        make.width.equalTo(@200);
    }];
    
}

#pragma mark - GET

- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.frame = CGRectMake(0, ScreenH-430./375.*ScreenW, ScreenW, 430./375.*ScreenW);
    }
    
    return _backView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f5);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 45;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}
-(void)complete{
    
    if (self.cellSelect) {
        self.cellSelect(lastSelectIndexPath);
    }
     [self hiddenAlert];
    
}
- (void)backAction{
    [self hiddenAlert];
}
#pragma mark - UITableViewDelegate UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
      return  UITableViewAutomaticDimension;
    return (ScreenW-30)/(710/278.)+10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier=@"cellIdentifier";
    JHDiscountCoponTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[JHDiscountCoponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell setMode:self.dataArray [indexPath.row]];
    cell.isOrderCoupon=YES;
    
    return  cell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CoponMode * mode=self.dataArray[indexPath.row];
    if (mode.unableUsed) {
        return;
    }
    
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.selected&&lastSelectIndexPath==indexPath) {
         [cell setSelected:NO animated:YES];
         lastSelectIndexPath=nil;
    }
    else{
         lastSelectIndexPath=indexPath;
    }
}

- (void)btnAction:(UIButton *)btn {
    
}

- (UIImageView *)creatLine {
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_cell_separator"]];
    img.mj_x = 15;
    img.mj_y = 45 - img.mj_h;
    img.mj_w = ScreenW - 15;
    return img;
}
-(void)setDataArr:(NSArray*)arr andDefaultSelecltIndex:(NSIndexPath*)indexPath{
    
      self.dataArray=[NSMutableArray arrayWithArray:arr];
      lastSelectIndexPath=indexPath;
      [self.tableView reloadData];
    
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES animated:YES];
    
}
- (void)showAlert {
    CGRect rect = self.backView.frame;
    self.backView.mj_y = ScreenH;
    
    rect.origin.y = ScreenH - rect.size.height;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.frame = rect;
    }];
    //[self loadOneData];
}

- (void)hiddenAlert {
    CGRect rect = self.backView.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.frame = rect;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)hiddenAlertCompletion:(void (^)(BOOL))completion {
    CGRect rect = self.backView.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.backView.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        completion(finished);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hiddenAlert];
}


@end
