//
//  YDActionSheet.m
//  Cooking-Home
//
//  Created by Wuyd on 2019/6/29.
//  Copyright © 2019 Wuyd. All rights reserved.
//

#import "YDActionSheet.h"
#import "YDActionSheetUtil.h"
#import "YDActionSheetCell.h"
#import "YYKit.h"
#import "UIView+Additions.h"

@interface YDActionSheet () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) void(^selectedBlock)(NSInteger index);

@property (nonatomic, strong, nullable) NSString *title; //标题
@property (nonatomic, strong, nullable) NSArray<NSString *> *itemTitles; //列表项标题
@property (nonatomic, assign) NSInteger destructiveIndex; //标红项索引

@property (nonatomic, strong) UIView        *maskView;
@property (nonatomic, strong) UIView        *container;
@property (nonatomic, strong) UIView        *headerView;
@property (nonatomic, strong) UITableView   *tableView;

@end


@implementation YDActionSheet

- (void)dealloc {
    NSLog(@"YDActionSheet::dealloc");
}

+ (void)yd_showActionSheetTitle:(nullable NSString *)title itemTitles:(nullable NSArray<NSString *> *)itemTitles block:(void(^)(NSInteger index))block {
    YDActionSheet *sheet = [[YDActionSheet alloc] initWithFrame:CGRectZero title:title itemTitles:itemTitles block:block];
    [sheet showInView:YD_KeyWindow];
}

+ (void)yd_showActionSheetTitle:(nullable NSString *)title itemTitles:(nullable NSArray<NSString *> *)itemTitles destructiveIndex:(NSInteger)destructiveIndex block:(void(^)(NSInteger index))block {
    
    YDActionSheet *sheet = [[YDActionSheet alloc] initWithFrame:CGRectZero title:title itemTitles:itemTitles destructiveIndex:destructiveIndex block:block];
    [sheet showInView:YD_KeyWindow];
}

- (instancetype)initWithFrame:(CGRect)frame
                        title:(nullable NSString *)title
                   itemTitles:(nullable NSArray<NSString *> *)itemTitles
                        block:(void(^)(NSInteger index))block {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        
        _title = title;
        _itemTitles = itemTitles.mutableCopy;
        _selectedBlock = block;
        _destructiveIndex = -1;
        [self configUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                        title:(nullable NSString *)title
                   itemTitles:(nullable NSArray<NSString *> *)itemTitles
             destructiveIndex:(NSInteger)destructiveIndex
                        block:(void(^)(NSInteger index))block {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        
        _title = title;
        _itemTitles = itemTitles.mutableCopy;
        _selectedBlock = block;
        _destructiveIndex = destructiveIndex;
        
        [self configUI];
    }
    return self;
}

- (void)configUI {
    // maskView
    _maskView = [YDActionSheetUtil yd_maskView];
    [self addSubview:_maskView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)];
    //tapGesture.delegate = self;
    [_maskView addGestureRecognizer:tapGesture];
    
    CGFloat headerH = (_title != nil && _title.length > 0) ? YD_ASHeaderH : 0;
    
    // containerView
    CGFloat containerH = headerH + YD_ASFooterH + YD_ASCellH * (_itemTitles.count + 1) + UI.bottomSafeAreaHeight;
    _container = [YDActionSheetUtil yd_containerWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, containerH)];
    [self addSubview:_container];
    
    // headerView
    if (headerH > 0) {
        _headerView = [YDActionSheetUtil yd_headerWithFrame:CGRectMake(0, 0, ScreenWidth, YD_ASHeaderH) title:_title];
        [_container addSubview:_headerView];
    }
    
    // tableView
    CGRect tableFrame = CGRectMake(0, headerH, ScreenWidth, containerH - CGRectGetMaxY(_headerView.frame));
    _tableView = [YDActionSheetUtil yd_tableWithFrame:tableFrame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_container addSubview:_tableView];
}
    

#pragma mark -
#pragma mark - 显示/隐藏

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.maskView.alpha = 1;
                         self.maskView.height = ScreenHeight - self.container.height;
                         self.container.y -= self.container.height;
                     } completion:^(BOOL finished) {}];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.maskView.alpha = 0;
                         self.maskView.height = ScreenHeight;
                         self.container.y = ScreenHeight;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

//点击手势
- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_container];
    if(![_container.layer containsPoint:point] && sender.view == _maskView) {
        [self dismiss];
        return;
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0 ? _itemTitles.count : 1);
}
 

/** 适配iOS11：这两个方法必须实现，且返回高度必须大于0，不然不起作用！！！ */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return (section == 0 ? YD_ASFooterH : 0.01);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = nil;
    if (section == 0) {
        footer = [YDActionSheetUtil yd_footerWithFrame:CGRectMake(0, 0, ScreenWidth, YD_ASFooterH)];
    }
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YDActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId_YDActionSheetCell forIndexPath:indexPath];
    if (indexPath.section == 0) {
        [cell setTitleStr:_itemTitles[indexPath.row] isDestructive:indexPath.row == _destructiveIndex showTopLine:YES];
        cell.isCancel = NO;
    } else {
        [cell setTitleStr:@"取消" isDestructive:NO showTopLine:NO];
        cell.isCancel = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (self.selectedBlock) {
            self.selectedBlock(indexPath.row);
        }
    }
    [self dismiss];
}

@end
