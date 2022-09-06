//
//  JHPlateSelectView.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPlateSelectView.h"
#import "JHPlateSelectCell.h"
#import "JHSQApiManager.h"
#import "UIView+Blank.h"

#define kPaddingTop (UI.statusAndNavBarHeight + 94)

@interface JHPlateSelectView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, copy) void(^doneBlock)(JHPlateSelectData *data);

@property (nonatomic, strong) JHPlateSelectModel *curModel;

//----------------------------------------------------------------------------
@property (nonatomic, strong) UIView        *container;
@property (nonatomic, strong) UITableView   *tableView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, assign) BOOL isDragTableView; //当前正在拖拽的是否是tableView
@property (nonatomic, assign) CGFloat lastDrapDistance; //向下拖拽最后时刻的位移
//----------------------------------------------------------------------------

@end


@implementation JHPlateSelectView

- (void)dealloc {
    NSLog(@"JHPlateSelectView::dealloc");
}

+ (void)showInView:(UIView *)view doneBlock:(void(^)(JHPlateSelectData *data))block {
    JHPlateSelectView *selectView = [[JHPlateSelectView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    selectView.doneBlock = block;
    [selectView showInView:view];
}

#pragma mark -
#pragma mark - 显示、隐藏

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect frame = self.container.frame;
        frame.origin.y = frame.origin.y - frame.size.height;
        self.container.frame = frame;
        
    } completion:^(BOOL finished) {}];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = self.container.frame;
        frame.origin.y = frame.origin.y + frame.size.height;
        self.container.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        _curModel = [[JHPlateSelectModel alloc] init];
        _isDragTableView = NO;
        _lastDrapDistance = 0.0;
        
        [self configUI];
        
        [self loadData];
    }
    return self;
}

- (void)configUI {

    // Container
    CGFloat containerH = kScreenHeight - kPaddingTop;
    _container = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, containerH)];
    _container.backgroundColor = [UIColor whiteColor];
    [self addSubview:_container];
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:_container.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10.0f , 10.0f )];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    _container.layer.mask = shape;
    
    //tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, _container.height) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10); //分割线到头
    _tableView.separatorColor = kColorCellLine;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.rowHeight = [JHPlateSelectCell cellHeight];
    [_tableView registerClass:[JHPlateSelectCell class] forCellReuseIdentifier:NSStringFromClass([JHPlateSelectCell class])];
    //适配iOS11
    if (iOS(11)) {
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0.1;
        _tableView.estimatedSectionFooterHeight = 0.1;
    }
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.viewController.automaticallyAdjustsScrollViewInsets = NO;
    }
    [_container addSubview:_tableView];
    
    //点击点击手势
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGuesture:)];
    self.tapGestureRecognizer = tapGestureRecognizer;
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
    
    //添加拖拽手势
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.container addGestureRecognizer:self.panGestureRecognizer];
    self.panGestureRecognizer.delegate = self;
}

#pragma mark -
#pragma mark - 数据相关
- (void)loadData {
    [self beginLoading];
    @weakify(self);
    [JHSQApiManager getPlateSelectList:_curModel block:^(NSArray<JHPlateSelectData *> * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [self endLoading];
        
        if (respObj) {
            self.curModel.list = [NSMutableArray arrayWithArray:respObj];
            [self.tableView reloadData];
        }
        
        [self configBlankType:YDBlankTypeNoCollectionList hasData:_curModel.list.count > 0 hasError:hasError offsetY:-20 reloadBlock:^(id sender) {}];
    }];
}

#pragma mark -
#pragma mark - UIGestureRecognizerDelegate
//1
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if(gestureRecognizer == self.panGestureRecognizer) {
        UIView *touchView = touch.view;
        while (touchView != nil) {
            if (touchView == self.tableView) {
                _isDragTableView = YES;
                break;
            } else if (touchView == self.container) {
                _isDragTableView = NO;
                break;
            }
            touchView = (UIView *)[touchView nextResponder];
        }
    }
    return YES;
}

//2.
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if(gestureRecognizer == self.tapGestureRecognizer) {
        //如果是点击手势
        CGPoint point = [gestureRecognizer locationInView:_container];
        if ([_container.layer containsPoint:point] && gestureRecognizer.view == self) {
            return NO;
        }
    } else if (gestureRecognizer == self.panGestureRecognizer) {
        //如果是自己加的拖拽手势
        //NSLog(@"gestureRecognizerShouldBegin");
    }
    return YES;
}

//3. 是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer == self.panGestureRecognizer)
    {
        if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")] ||
            [otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIPanGestureRecognizer")] )
        {
            if(otherGestureRecognizer.view == self.tableView)
            {
                return YES;
            }
        }
    }
    return NO;
}

//拖拽手势
- (void)pan:(UIPanGestureRecognizer *)panGestureRecognizer {
    // 获取手指的偏移量
    CGPoint transP = [panGestureRecognizer translationInView:self.container];
    //NSLog(@"transP : %@",NSStringFromCGPoint(transP));
    //CGPoint transP2 = [panGestureRecognizer translationInView:self.tableView];
    //NSLog(@"transP2 : %@",NSStringFromCGPoint(transP2));
    
    if (_isDragTableView) { //当前拖拽的是tableView
        if (self.tableView.contentOffset.y <= 0) {
            //如果tableView在顶端
            if (transP.y > 0) { //向下拖拽
                self.tableView.contentOffset = CGPointMake(0, 0 );
                self.tableView.panGestureRecognizer.enabled = NO;
                self.tableView.panGestureRecognizer.enabled = YES;
                _isDragTableView = NO;
                self.container.frame = CGRectMake(self.container.left, self.container.top + transP.y, self.container.width, self.container.height);
            } else {
                //向上拖拽
            }
        }
    } else {
        if(transP.y > 0) {
            //向下拖拽
            self.container.frame = CGRectMake(self.container.left, self.container.top + transP.y, self.container.width, self.container.height);
        } else if (transP.y < 0 && self.container.top > (kScreenHeight - self.container.height)) {
            //向上拖拽
            self.container.frame = CGRectMake(self.container.left, (self.container.top + transP.y) > (kScreenHeight - self.container.height) ? (self.container.top + transP.y) : (kScreenHeight - self.container.height), self.container.width, self.container.height);
        }
    }
    
    [panGestureRecognizer setTranslation:CGPointZero inView:self.container];
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //NSLog(@"transP : %@",NSStringFromCGPoint(transP));
        //NSLog(@"transP2 : %@",NSStringFromCGPoint(transP2));
        
        if (self.lastDrapDistance > 10 && self.isDragTableView == NO) {
            //清扫滑动页面
            [self dismiss];
        } else {
            //普通拖拽
            if(self.container.top >= kScreenHeight - self.container.height/2) {
                [self dismiss];
            } else {
                [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.container.top = kScreenHeight - self.container.height;
                } completion:^(BOOL finished) {
                    //NSLog(@"拖拽结束");
                }];
            }
        }
    }
    self.lastDrapDistance = transP.y;
}

//点击手势
- (void)handleGuesture:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_container];
    if (![_container.layer containsPoint:point] && sender.view == self) {
        [self dismiss];
        return;
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _curModel.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHPlateSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHPlateSelectCell class]) forIndexPath:indexPath];
    
    JHPlateSelectData *data = _curModel.list[indexPath.row];
    cell.curData = data;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JHPlateSelectData *data = _curModel.list[indexPath.row];
    if (_doneBlock) {
        _doneBlock(data);
    }
    [self dismiss];
}

@end
