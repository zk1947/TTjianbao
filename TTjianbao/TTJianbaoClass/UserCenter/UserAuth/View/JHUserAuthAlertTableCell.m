//
//  JHUserAuthAlertTableCell.m
//  TTjianbao
//
//  Created by lihui on 2021/3/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUserAuthAlertTableCell.h"
#import "JHUserAuthModel.h"

@interface JHUserAuthAlertTableCell ()
@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, strong) UILabel *label;
@end


@implementation JHUserAuthAlertTableCell

- (void)setAuthModel:(JHUserAuthModel *)authModel {
    if (!authModel) {
        return;
    }
    _authModel = authModel;
    _label.text = [self alertString];
    if (_authModel.authState == JHUserAuthStateUnPassed) {
        _alertView.backgroundColor = HEXCOLOR(0xFFF0ED);
        _label.textColor = HEXCOLOR(0xF03D37);
    }
    else {
        _alertView.backgroundColor = HEXCOLOR(0xFFF7E8);
        _label.textColor = HEXCOLOR(0xFF7B00);
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIView *alertView = [[UIView alloc] init];
    [self.contentView addSubview:alertView];
    _alertView = alertView;
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"";
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:kFontNormal size:12.];
    [alertView addSubview:label];
    _label = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alertView).offset(12);
        make.top.equalTo(alertView).offset(14);
        make.right.equalTo(alertView).offset(-14);
        make.bottom.equalTo(alertView).offset(-14);
    }];
}
- (NSString *)alertString {
    switch (_authModel.authState) {
        case JHUserAuthStateChecking:
            return @"您的资质正在审核中…";
            break;
        case JHUserAuthStatePassed:
            return @"审核通过：若重新上传需重新审核";
            break;
        case JHUserAuthStateUnPassed:
            return [_authModel.rejectReason isNotBlank]
            ? [NSString stringWithFormat:@"审核未通过：%@", _authModel.rejectReason] : @"审核未通过：";
            break;
        default:
            return @"";
            break;
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
