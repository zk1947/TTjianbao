//
//  JHGuaranteeTableViewCell.m
//  TTjianbao
//
//  Created by lihui on 2020/3/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGuaranteeTableViewCell.h"
#import <UIColor+YYAdd.h>
#import "UIButton+ImageTitleSpacing.h"


@implementation JHGuaranteePanelMode

@end

@interface JHGuaranteeTableViewCell ()

@property (nonatomic, copy) NSArray *guarantees;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *lineArray;

@end


@implementation JHGuaranteeTableViewCell

+ (CGFloat)cellHeight {
    return 34;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self loadGraduateeData];
        [self initViews];
    }
    return self;
}

- (void)loadGraduateeData {
    NSArray *dataArray = [JHGuaranteePanelMode mj_objectArrayWithFilename:@"JHGraduatee.plist"];
    _guarantees = [NSMutableArray arrayWithArray:dataArray];
}

- (void)initViews {
    CGFloat nextWidth = 10;
    _buttonArray = [NSMutableArray array];
    _lineArray = [NSMutableArray array];
    for (int i = 0; i < _guarantees.count; i ++) {
        JHGuaranteePanelMode *model = _guarantees[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:10];
        [btn setTitle:model.title forState:UIControlStateNormal];
        [btn setTitle:model.title forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:model.iconNorImgName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:model.iconSelImgName] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:model.titleNorColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:model.titleSelColor] forState:UIControlStateSelected];
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [self.contentView addSubview:btn];
        [_buttonArray addObject:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(nextWidth);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo((ScreenW - 20-3)/4);
        }];
        
        if (i < _guarantees.count-1) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = HEXCOLOR(0x999999);
            [self.contentView addSubview:line];
            [_lineArray addObject:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(btn.mas_right);
                make.size.mas_equalTo(CGSizeMake(1, 10));
                make.centerY.equalTo(self.contentView);
            }];
        }
        [btn layoutIfNeeded]; ///这句必须加！！！
        nextWidth += (btn.width+1);
    }
}

- (void)transformGuaranteeStyle:(BOOL)isActivity {
    ///当前有活动
    for (UIButton *btn in _buttonArray) {
        btn.selected = isActivity;
    }
    for (UIView *line in _lineArray) {
        line.backgroundColor = [UIColor colorWithHexString:isActivity ? @"ffffff" : @"666666"];
    }
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
