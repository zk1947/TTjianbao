//
//  JHRecycleLivingInfoTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/3/31.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleLivingInfoTableViewCell.h"

@interface JHRecycleLivingInfoTableViewCell ()
@property (nonatomic, strong)UIImageView *imgView;
@property (nonatomic, strong) UILabel    *nameLabel;
@property (nonatomic, strong) UILabel    *subNameLabel;
@end

@implementation JHRecycleLivingInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
}

@end
