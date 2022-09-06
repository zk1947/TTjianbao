//
//  JHLotteryStateHeader.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryStateHeader.h"

@interface JHLotteryStateHeader ()
@property (nonatomic, strong) JHLotteryHomeInfoView *infoView;
@end

@implementation JHLotteryStateHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.f alpha:1.f];
        [self configUI];
    }
    return self;
}

- (void)configUI {
    _infoView = [[JHLotteryHomeInfoView alloc] init];
    [self addSubview:_infoView];
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    @weakify(self);
    _infoView.buttonClickBlock = ^(NSInteger type) {
        @strongify(self);
        if (self.activityStateEventBlock) {
            self.activityStateEventBlock(type);
        }
    };
}


#pragma mark -
#pragma mark - 设置数据
- (void)setActivityData:(JHLotteryActivityData *)data codeCount:(NSInteger)codeCount {
    _curData = data;
    _codeCount = codeCount;
    _infoView.type = [self getCurrentActivityType];
    _infoView.model = _curData;
    
    @weakify(self);
    _infoView.finshBlock = ^{
        @strongify(self);
        if(self.reloadBlock) {
            self.reloadBlock();
        }
    };
}

/// 0-未参与  1-参与未分享  2-分享未助力 3-分享满 4-开启提醒
- (NSInteger)getCurrentActivityType {
    //未参与
    if(_curData.state == 3)
    {
        return 4;
    }
    if (_curData.hit == 0) {
        return 0;
    }
    
    NSInteger type;
    if (_codeCount == _curData.codeMax) {
        type = 3; //分享满
    } else {
        type = [_curData.subtitle isNotBlank] ? 2 : 1; //subTitle不为空表示已分享过
    }
    return type;
}

@end
