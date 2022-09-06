//
//  JHAddInfoTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/7/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAddInfoTableCell.h"
#import "YYControl.h"
#import "TTjianbaoMarcoUI.h"

@interface JHAddInfoTableCell ()

///添加描述
@property (nonatomic, strong) YYControl *addDescView;
///添加图标
@property (nonatomic, strong) UIImageView *addImageView;
///添加文字
@property (nonatomic, strong) UILabel *addDescLabel;


@end

@implementation JHAddInfoTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
    }
    return self;
}

- (void)handleClickAddEvent {
    if (self.editBlock) {
        self.editBlock();
    }
}

- (void)initSubViews {
    YYControl *addView = [[YYControl alloc] init];
    addView.backgroundColor = kColorF5F6FA;
    [self.contentView addSubview:addView];
    _addDescView = addView;
    _addDescView.exclusiveTouch = YES;
    @weakify(self);
    _addDescView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *touch = touches.anyObject;
            CGPoint p = [touch locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                //点击事件
                [self handleClickAddEvent];
            }
        }
    };
    
    UIImageView *addImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_anchor_add"]];
    addImgView.contentMode = UIViewContentModeScaleAspectFit;
    [addView addSubview:addImgView];
    _addImageView = addImgView;
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"点击添加";
    addLabel.textColor = kColor999;
    addLabel.font = [UIFont fontWithName:kFontNormal size:13];
    [addView addSubview:addLabel];
    _addDescLabel = addLabel;
    
    [self makeLayouts];
}

- (void)makeLayouts {
    [_addDescView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 15, 5, 15));
    }];
    
    [_addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.addDescView);
        make.centerY.equalTo(self.addDescView).offset(-12);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    
    [_addDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.addDescView);
        make.centerY.equalTo(self.addDescView).offset(12);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end
