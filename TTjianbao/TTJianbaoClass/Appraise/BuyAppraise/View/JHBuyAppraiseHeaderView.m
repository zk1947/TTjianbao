//
//  JHBuyAppraiseHeaderView.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBuyAppraiseHeaderView.h"
#import "JHBuyAppraiseCheckCountView.h"
#import "JHBuyAppraiseTVBoxHeader.h"
#import "JHBuyAppraiseSeparateOperationView.h"

@interface JHBuyAppraiseHeaderView()
/** 直播视图*/
@property (nonatomic, strong) JHBuyAppraiseTVBoxHeader *tvBoxView;
/** 把关入口*/
@property (nonatomic, strong) JHBuyAppraiseCheckCountView *checkView;

/// 一图多热区
@property (nonatomic, weak) JHBuyAppraiseSeparateOperationView *operationView;

@end
@implementation JHBuyAppraiseHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = HEXCOLOR(0xf5f5f8);
        [self configUI];
    }
    return self;
}

- (void)configUI{
    [self addSubview:self.tvBoxView];
    [self addSubview:self.checkView];
    
    
    [self.tvBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
    }];
    
    [self.checkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.equalTo(self.operationView.mas_bottom).offset(8);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (JHBuyAppraiseSeparateOperationView *)operationView {
    if(!_operationView) {
        JHBuyAppraiseSeparateOperationView *operationView = [JHBuyAppraiseSeparateOperationView new];
        [self addSubview:operationView];
        @weakify(self);
        operationView.hiddenBlock = ^(BOOL hidden) {
            @strongify(self);
            self.operationView.hidden = hidden;
            if(hidden) {
                [self.checkView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.mas_left);
                    make.right.mas_equalTo(self.mas_right);
                    make.top.mas_equalTo(self.tvBoxView.mas_bottom).offset(8);
                    make.bottom.mas_equalTo(self.mas_bottom);
                }];
            }
            else {
                [self.checkView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.mas_left);
                    make.right.mas_equalTo(self.mas_right);
                    make.top.equalTo(self.operationView.mas_bottom).offset(8);
                    make.bottom.mas_equalTo(self.mas_bottom);
                }];
            }
            
        };
        [operationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.tvBoxView.mas_bottom);
            make.height.mas_equalTo([JHBuyAppraiseSeparateOperationView viewHeight]);
        }];
        _operationView = operationView;
    }
    return _operationView;
}

- (JHBuyAppraiseTVBoxHeader *)tvBoxView{
    if (_tvBoxView == nil) {
        _tvBoxView = [[JHBuyAppraiseTVBoxHeader alloc] init];
    }
    return _tvBoxView;
}

- (JHBuyAppraiseCheckCountView *)checkView{
    if (_checkView == nil) {
        _checkView = [[JHBuyAppraiseCheckCountView alloc] init];
        _checkView.layer.cornerRadius = 4;
        _checkView.clipsToBounds = YES;
        MJWeakSelf;
        _checkView.selectBlock = ^(NSDictionary * _Nonnull params) {
            if (weakSelf.selectBlock) {
                weakSelf.selectBlock(params);
            }
        };
    }
    return _checkView;
}

/// 直播或者回放开始
- (void)start {
    [self.tvBoxView start];
}

/// 直播或者回放结束
- (void)stop {
    [self.tvBoxView stop];
}

/// 刷新
- (void)refreshData {
    
    [self.checkView refreshData];
    [self.tvBoxView refreshData];
    [self.operationView refreshData];
}

@end
