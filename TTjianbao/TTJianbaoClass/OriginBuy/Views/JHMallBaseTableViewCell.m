//
//  JHMallBaseTableViewCell.m
//  TTjianbao
//
//  Created by lihui on 2020/12/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallBaseTableViewCell.h"

@implementation JHMallBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
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
