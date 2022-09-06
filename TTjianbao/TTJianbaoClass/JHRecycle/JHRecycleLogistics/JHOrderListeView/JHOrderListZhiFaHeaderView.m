//
//  JHOrderListZhiFaHeaderView.m
//  TTjianbao
//
//  Created by user on 2021/6/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHOrderListZhiFaHeaderView.h"
#import "JHOrderListZhiFaListView.h"
#import "JHReLayoutButton.h"

@interface JHOrderListZhiFaHeaderView ()
@property (nonatomic, strong) JHReLayoutButton         *sendBtn;
@property (nonatomic, strong) JHOrderListZhiFaListView *listView;
@property (nonatomic, assign) BOOL isListShow;
@end

@implementation JHOrderListZhiFaHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isListShow = NO;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {    
    _sendBtn = [JHReLayoutButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:13.f];
    [_sendBtn setTitle:@"全部" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(sendBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_sendBtn setImage:[UIImage imageNamed:@"jhOrder_listChannel_down"] forState:UIControlStateNormal];
    _sendBtn.layoutType = RelayoutTypeRightLeft;
    _sendBtn.margin     = 5.f;
    [self addSubview:_sendBtn];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12.f);
    }];
    
    @weakify(self);
    [self.listView setDidSelectedCallback:^(NSInteger index, NSString *content) {
        @strongify(self);
        [self.sendBtn setImage:[UIImage imageNamed:@"jhOrder_listChannel_down"] forState:UIControlStateNormal];
        [self.sendBtn setTitle:content forState:UIControlStateNormal];
        [self.listView removeFromSuperview];
        self.isListShow = NO;
        if (self.didSelectedCallback) {
            self.didSelectedCallback(index,content);
        }
    }];

}

- (void)sendBtnClickAction:(UIButton *)button {
    self.listView.arrMDataSource = @[@"全部",@"直发",@"非直发"];
    if (!self.isListShow) {
        [button setImage:[UIImage imageNamed:@"jhOrder_listChannel_up"] forState:UIControlStateNormal];
        [[UIApplication sharedApplication].keyWindow addSubview:self.listView];
        [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-3.f);
            make.top.equalTo(self.sendBtn.mas_bottom).offset(-1.f);
            make.width.mas_equalTo(70.f);
            make.height.mas_equalTo(130.f);
        }];
        self.isListShow = YES;
    } else {
        [self.sendBtn setImage:[UIImage imageNamed:@"jhOrder_listChannel_down"] forState:UIControlStateNormal];
        [self.listView removeFromSuperview];
        self.isListShow = NO;
    }
}

- (JHOrderListZhiFaListView *)listView {
    if (!_listView) {
        _listView =  [[JHOrderListZhiFaListView alloc] init];
        _listView.cusFont = [UIFont fontWithName:kFontMedium size:12.f];
        _listView.tabColor = HEXCOLORA(0xFFFFFF,0);
        _listView.backgroundColor = HEXCOLORA(0xFFFFFF,0);
        _listView.noBackImage = NO;
    }
    return _listView;
}

- (void)removeListView {
    [self.listView removeFromSuperview];
    self.listView = nil;
}

/// 收起
- (void)putAwayListView {
    self.isListShow = NO;
    [self.listView removeFromSuperview];
    [self.sendBtn setImage:[UIImage imageNamed:@"jhOrder_listChannel_down"] forState:UIControlStateNormal];
}

- (void)dealloc {
    [self removeListView];
}

@end
