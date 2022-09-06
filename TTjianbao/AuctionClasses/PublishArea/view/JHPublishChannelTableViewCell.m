//
//  JHPublishChannelTableViewCell.m
//  TTjianbao
//
//  Created by apple on 2019/7/7.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHPublishChannelTableViewCell.h"
#import "TTjianbaoHeader.h"

@interface JHPublishChannelTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *yellowView;

@end

@implementation JHPublishChannelTableViewCell
@dynamic title;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        self.titleLabel.textColor = HEXCOLOR(0x666666);
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.left.greaterThanOrEqualTo(@5);
            make.right.lessThanOrEqualTo(@-5);
        }];
        
        self.yellowView = [[UIView alloc]init];
        self.yellowView.backgroundColor = HEXCOLOR(0xFEE100);
        [self.contentView addSubview:self.yellowView];
        [self.yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.centerY.equalTo(@0);
            make.width.equalTo(@4);
            make.height.equalTo(@41);
        }];
        self.yellowView.hidden = YES;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        self.titleLabel.textColor = HEXCOLOR(0x333333);
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.yellowView.hidden = NO;
    } else {
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        self.titleLabel.textColor = HEXCOLOR(0x666666);
        
        self.contentView.backgroundColor = HEXCOLOR(0xF8F8F8);
        
        self.yellowView.hidden = YES;
    }
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end


@interface JHPublishSubCateCollectionCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JHPublishSubCateCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [UIImageView new];
        self.imgView.backgroundColor = HEXCOLOR(0xF6F6F6);
        self.imgView.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@0);
            make.width.height.equalTo(@81);
        }];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        self.titleLabel.textColor = HEXCOLOR(0x666666);
        self.titleLabel.numberOfLines = 1;
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom);
            make.centerX.equalTo(@0);
        }];
    }
    return self;
}

- (void)setImageUrl:(NSString *)imgUrl title:(NSString *)title {
    [self.imgView jhSetImageWithURL:[NSURL URLWithString:imgUrl] placeholder:kDefaultCoverImage];
    self.titleLabel.text = title;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imgView.image = nil;
    self.titleLabel.text = nil;
}

@end


@interface JHPublishCollectionHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JHPublishCollectionHeaderView
@dynamic title;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [UILabel new];
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        self.titleLabel.textColor = HEXCOLOR(0x333333);
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(@0);
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
