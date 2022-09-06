//
//  JHBusinessFansMissionProgressView.m
//  TTjianbao
//
//  Created by user on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansMissionProgressView.h"

@interface JHBusinessFansMissionProgressView ()
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *lineArray;
@property (nonatomic, strong) NSMutableArray *tapArray;
@end

@implementation JHBusinessFansMissionProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _canClick = NO;
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _labelArray;
}

- (NSMutableArray *)lineArray {
    if (!_lineArray) {
        _lineArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _lineArray;
}

- (NSMutableArray *)tapArray {
    if (!_tapArray) {
        _tapArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _tapArray;
}

- (void)setupViews {
    NSArray *nameArr = @[@"等级设置",@"任务设置",@"权益设置"];
    CGFloat labelWidth = 60.f;
    CGFloat labelLeft  = 30.f;
    CGFloat labelSpace = (ScreenW - labelWidth*3 - labelLeft*2)/2.f;
    CGFloat lineLeft   = (labelLeft + labelWidth) + 11.f;
    CGFloat lineSpace  = labelWidth + 11.f*2;
    CGFloat lineWidth  = (ScreenW - labelWidth*3 - labelLeft*2)/2.f - 11.f*2;

    for (int i = 0; i< nameArr.count; i++) {
        UILabel *titleLabel               = [[UILabel alloc] init];
        titleLabel.text                   = nameArr[i];
        titleLabel.userInteractionEnabled = YES;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(labelLeft +(labelSpace + labelWidth)*i);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(labelWidth);
            make.height.mas_equalTo(21.f);
        }];
        [self.labelArray addObject:titleLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelDidClicked:)];
        [titleLabel addGestureRecognizer:tap];
        [self.tapArray addObject:tap];
        
        if (i < 2) {
            UIView *lineView                  = [[UIView alloc] init];
            lineView.layer.cornerRadius       = 1.f;
            lineView.layer.masksToBounds      = YES;
            [self addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(lineLeft + (lineSpace + lineWidth)*i);
                make.centerY.equalTo(self.mas_centerY);
                make.width.mas_equalTo(lineWidth);
                make.height.mas_equalTo(2);
            }];
            [self.lineArray addObject:lineView];
        }
    }
}

- (void)setLabelStatus:(JHBusinessFansMissionSettingStatus)status {
    for (int i = 0; i < self.labelArray.count; i++) {
        UILabel *titleLabel = self.labelArray[i];
        if (status >= i) {
            titleLabel.textColor = HEXCOLOR(0xFFD70F);
            titleLabel.font      = [UIFont fontWithName:kFontMedium size:15.f];
        } else {
            titleLabel.textColor = HEXCOLOR(0x999999);
            titleLabel.font      = [UIFont fontWithName:kFontNormal size:15.f];
        }
    }
    NSInteger index = 0;
    if (status == 0) {
        index = 0;
    } else {
        index = 1;
    }
    for (int i = 0; i< self.lineArray.count; i++) {
        UIView *lineView = self.lineArray[i];
        if (index >= i) {
            lineView.backgroundColor = HEXCOLOR(0xFFD70F);
        } else {
            lineView.backgroundColor = HEXCOLOR(0x999999);
        }
    }
}

- (void)titleLabelDidClicked:(UIGestureRecognizer *)tap {
    if (!self.canClick) {
        return;
    }
    for (UITapGestureRecognizer *clickTap in self.tapArray) {
        if (clickTap == tap) {
            if (self.clickBlock) {
                NSInteger index = [self.tapArray indexOfObject:clickTap];
                self.clickBlock(index);
            }
        }
    }
}

@end
