//
//  JHStoreHomeListCell.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeListCell.h"
#import "CStoreHomeListModel.h"
#import "YYControl.h"
#import "YDCountDownManager.h"
#import "YDCountDownView.h"
#import "UIView+CornerRadius.h"


@interface JHStoreHomeListCell ()
@property (nonatomic, strong) YYControl *contentControl;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) YDCountDownView *countDownView; //倒计时视图

@property (nonatomic, assign) BOOL isEnd;
@end

@implementation JHStoreHomeListCell

- (void)dealloc {
    //倒计时相关
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (CGFloat)cellHeight {
    return 225.0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyleEnabled = NO;
        [self __addCountDownObserver];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    if (!_contentControl) {
        _contentControl = [YYControl new];
        _contentControl.backgroundColor = [UIColor whiteColor];
        _contentControl.layer.cornerRadius = 4;
        _contentControl.clipsToBounds = YES;
        _contentControl.exclusiveTouch = YES;
        [self.contentView addSubview:_contentControl];
        @weakify(self);
        _contentControl.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            @strongify(self);
            if (state == YYGestureRecognizerStateEnded) {
                UITouch *touch = touches.anyObject;
                CGPoint p = [touch locationInView:self];
                if (CGRectContainsPoint(self.bounds, p)) {
                    if (self.selectedBlock) { //点击事件
                        self.selectedBlock(self.curData);
                    }
                }
            }
        };
    }
    
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.layer.opaque = YES;
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [_contentControl addSubview:_imgView];
    }
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:14] textColor:kColor333];
        _titleLabel.numberOfLines = 1;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //_titleLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        [_contentControl addSubview:_titleLabel];
    }
    
    if (!_descLabel) {
        _descLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:12] textColor:kColor666];
        _descLabel.numberOfLines = 1;
        _descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        //_descLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        [_contentControl addSubview:_descLabel];
    }
    
    //倒计时视图
    if (!_countDownView) {
        YDCountDownConfig *config = [[YDCountDownConfig alloc] init];
        _countDownView = [YDCountDownView countDownWithConfig:config endBlock:^{
            
        }];
        [_contentControl addSubview:_countDownView];
    }
    
    [self makeLayout];
}

- (void)makeLayout {
    //布局
    _contentControl.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 10, 10, 10));
    
    _imgView.sd_layout
    .topEqualToView(_contentControl)
    .leftEqualToView(_contentControl)
    .rightEqualToView(_contentControl)
    .heightIs(150);
    
    
    //倒计时
    _countDownView.sd_layout
    .topSpaceToView(_imgView, 11)
    .rightSpaceToView(_contentControl, 5)
    .heightIs(18);
    
    //标题
    _titleLabel.sd_layout
    .centerYEqualToView(_countDownView)
    .leftSpaceToView(_contentControl, 10)
    .rightSpaceToView(_countDownView, 2)
    .heightIs(20);
    
    //描述
    _descLabel.sd_layout
    .leftSpaceToView(_contentControl, 10)
    .rightSpaceToView(_contentControl, 10)
    .bottomSpaceToView(_contentControl, 10)
    .heightIs(18);
    
    // 设置优先级
    /**
    [_timeTipLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
     
    [_hLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
     
    [_descLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
     */
}

- (void)setCurData:(CStoreHomeListData *)curData {
    if (!curData) return;
    _curData = curData;
    [_imgView jhSetImageWithURL:[NSURL URLWithString:curData.head_img]
                              placeholder:kDefaultCoverImage];
    
    _titleLabel.text = curData.name;
    _descLabel.text = curData.desc;
    
    //倒计时相关
    [self __handleCountDownEvent];
    
    [self updateLayout];
}

- (void)setIsLastCell:(BOOL)isLastCell {
    _isLastCell = isLastCell;
    _contentControl.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 10, isLastCell?0:10, 10));
    [_contentControl updateLayout];
}

#pragma mark -
#pragma mark - 倒计时相关 - 添加通知

- (void)__addCountDownObserver {
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:YDCountDownNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        //第一场倒计时
        [self __handleCountDownEvent];
    }];
}

//倒计时相关 - 设置倒计时数据
- (void)__handleCountDownEvent {
    NSInteger timeInterval = 0;
    if (_curData.timerSourceIdentifier) {
        timeInterval = [kCountDownManager timeIntervalWithId:_curData.timerSourceIdentifier];
    } else {
        timeInterval = kCountDownManager.runLoopTimeInterval;
    }
    
    NSInteger second = _curData.offline_at.integerValue - _curData.server_at.integerValue;
    NSInteger countDownValue = second - timeInterval;
    
    if (countDownValue <= 0) {
        //第一次倒计时结束，进行下一场的倒计时
        [self __handleNextCountDown];
        return;
    }
    
    [_countDownView setCountDownTime:countDownValue];
}

#pragma mark - 进行下一场的倒计时
- (void)__handleNextCountDown {
    NSInteger timeSpace = _curData.offline_at.integerValue - _curData.next_offline_at.integerValue;
    if (timeSpace >= 0) {
        [_countDownView showEndStyle];
        return;
    }
    
    _curData.offline_at = _curData.next_offline_at;
    
    NSInteger timeInterval = 0;
    if (_curData.timerSourceIdentifier) {
        timeInterval = [kCountDownManager timeIntervalWithId:_curData.timerSourceIdentifier];
    } else {
        timeInterval = kCountDownManager.runLoopTimeInterval;
    }
    NSInteger second = _curData.offline_at.integerValue - _curData.server_at.integerValue;
    NSInteger countDownValue = second - timeInterval;
    
    if (countDownValue <= 0) {
        //两场倒计时全部结束
        [_countDownView showEndStyle];
        //删除当前数据的倒计时，不再接收回调
        [kCountDownManager removeTimerSourceWithId:_curData.timerSourceIdentifier];
        return;
    }
    
    [_countDownView setCountDownTime:countDownValue];
}

@end
