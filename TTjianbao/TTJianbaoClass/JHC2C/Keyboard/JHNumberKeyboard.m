//
//  JHNumberKeyboard.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/6/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNumberKeyboard.h"

static CGFloat const Spacing = 1.0f;
static CGFloat const DeleteWidth = 92.0f;

@interface JHNumberKeyboard()
/// 数字
@property (nonatomic, strong) UIView *numberView;
/// 删除按钮
@property (nonatomic, strong) UIButton *deleteButton;
/// 完成按钮
@property (nonatomic, strong) UIButton *endButton;

@end

@implementation JHNumberKeyboard

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}

#pragma mark - Event
- (void)didClickDelete : (UIButton *)sender {
    if (self.handler) {
        self.handler(KeyboardDeleteId);
    }

    NSLog(@"%@",KeyboardDeleteId)
}
- (void)didClickEnd : (UIButton *)sender {
    if (self.handler) {
        self.handler(KeyboardEndId);
    }
    NSLog(@"%@",KeyboardEndId);
}
- (void)didClickNumber : (UIButton *)sender {
    NSString *text = [NSString stringWithFormat:@"%ld", (long)sender.tag];
    if (self.handler) {
        
        self.handler(text);
    }
    NSLog(@"%@",text);
}
#pragma mark - UI

- (void)setupUI {
    self.backgroundColor = HEXCOLOR(0xd8d8d8);
    [self addSubview:self.numberView];
    [self addSubview:self.endButton];
    [self addSubview:self.deleteButton];
    [self createKeyboard];
}
- (void)layoutViews {

    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Spacing);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.deleteButton.mas_left).offset(-Spacing);
        make.height.mas_equalTo(207);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.numberView);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(104);
        make.width.mas_equalTo(DeleteWidth);
    }];
    [self.endButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.deleteButton.mas_bottom);
        make.height.mas_equalTo(104);
        make.right.width.mas_equalTo(self.deleteButton);
    }];
    
    UIView *place = [UIView new];
    place.backgroundColor = UIColor.whiteColor;
    [self addSubview:place];

    [place mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberView.mas_bottom).offset(1);
        make.right.bottom.left.equalTo(@0);
    }];

    
}
- (void)createKeyboard {
    NSArray *items = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",KeyboardDecimalId,@"0",KeyboardABCId,];
    
    CGFloat btnWidth = (ScreenW - DeleteWidth - Spacing * 3) / 3;
    CGFloat btnHeight = 51;
    int col = 3;
    for (int i = 0; i < items.count; i++) {
        UIButton *btn = [self getButtonWithTitle:items[i]];
        btn.frame = CGRectMake(i % col * (btnWidth + Spacing), i / col * (btnHeight + Spacing), btnWidth, btnHeight);
        
        
        [self.numberView addSubview:btn];
    }
}
- (UIButton *)getButtonWithTitle : (NSString *) title {
    int tag = [title intValue];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = tag;
    btn.backgroundColor = HEXCOLOR(0xffffff);
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:kFontBoldDIN size:20];
    [btn addTarget:self action:@selector(didClickNumber:) forControlEvents:UIControlEventTouchDown];
    
    if (tag == 10) {
        [btn setTitle:@"." forState:UIControlStateNormal];
    }else if (tag == 12) {
        [btn setImage:[UIImage imageNamed:@"Keyboard_icon"] forState:UIControlStateNormal];
    }else {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    
    return btn;
}
#pragma mark - LAZY
- (UIView *)numberView {
    if (!_numberView) {
        _numberView = [[UIView alloc] initWithFrame:CGRectZero];
        _numberView.backgroundColor = HEXCOLOR(0xd8d8d8);
    }
    return _numberView;
}
- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"Keyboard_delete_icon"] forState:UIControlStateNormal];
        _deleteButton.backgroundColor = HEXCOLOR(0xffffff);
        [_deleteButton addTarget:self action:@selector(didClickDelete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
- (UIButton *)endButton {
    if (!_endButton) {
        _endButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_endButton setTitle:@"完成" forState:UIControlStateNormal];
        [_endButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _endButton.backgroundColor = HEXCOLOR(0xffd70f);
        [_endButton addTarget:self action:@selector(didClickEnd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endButton;
}

@end
