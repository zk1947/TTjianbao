//
//  JHArbitramentReportCell.m
//  TTjianbao
//
//  Created by lihui on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHArbitramentReportCell.h"

@interface JHArbitramentReportCell ()
@property (nonatomic, strong) UIImageView *resultImageView;
@end

@implementation JHArbitramentReportCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    ///标题
    UILabel *titleLabel = [UILabel jh_labelWithFont:14. textColor:kColor333 addToSuperView:self.contentView];
    titleLabel.text = @"商品报告";
    
    UILabel *descLabel = [UILabel jh_labelWithFont:13. textColor:kColor666 addToSuperView:self.contentView];
    descLabel.text = @"图文鉴定结果";

    _resultImageView = [UIImageView jh_imageViewWithImage:kDefaultCoverImage addToSuperview:self.contentView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [_resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(49., 49.));
    }];
}

+ (CGFloat)cellHeight {
    return 71.f;
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
