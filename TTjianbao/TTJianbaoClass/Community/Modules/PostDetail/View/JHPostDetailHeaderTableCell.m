//
//  JHPostDetailHeaderTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPostDetailHeaderTableCell.h"
#import "JHPostUserInfoView.h"
#import "JHPostDetailModel.h"
#import "UIImageView+JHWebImage.h"
#import "JHSQModel.h"
#import "JHUserInfoViewController.h"

@interface JHPostDetailHeaderTableCell ()
@property (nonatomic, strong) JHPostUserInfoView *userInfoView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JHPostDetailHeaderTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    JHPostUserInfoView *view = [[JHPostUserInfoView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:view];
    _userInfoView = view;
    @weakify(self);
    _userInfoView.followBlock = ^(BOOL isFollow) {
        @strongify(self);
        self.followBlock(isFollow);
    };
    _userInfoView.iconEnterBlock = ^{
        @strongify(self);
        self.iconEnterBlock();
    };
    
    _titleLabel = [UILabel new];
    [_titleLabel setFont:[UIFont fontWithName:kFontMedium size:22]];
    [_titleLabel setTextColor:kColor333];
    _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];

    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.leading.trailing.equalTo(self.contentView);
        make.height.mas_equalTo(68.f);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userInfoView.mas_bottom);
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)setPostDetailInfo:(JHPostDetailModel *)postDetailInfo {
    if (!postDetailInfo) {
        return;
    }
    _postDetailInfo = postDetailInfo;
    _userInfoView.postInfo = _postDetailInfo;
    CGFloat space = 0;
    ///这块显示标题只是针对于长文章 ！！！！！
//    if (_postDetailInfo.item_type == JHPostItemTypePost && [_postDetailInfo.title isNotBlank]) {
    if (_postDetailInfo.item_type == JHPostItemTypePost && [_postDetailInfo.title isNotBlank]) {
        space = -10;

        _postDetailInfo.title = [_postDetailInfo.title stringByTrim];
        UIFont *font = [UIFont fontWithName:kFontMedium size:22];
        NSMutableAttributedString *titleAttr = [[NSMutableAttributedString alloc] initWithString:_postDetailInfo.title];
        titleAttr.font = font;
        titleAttr.color = kColor333;
       
        BOOL isEssence = (_postDetailInfo.content_level == 1);
        UIImage *image = nil;
        if (isEssence) {
           image = [UIImage imageNamed:@"sq_icon_essence"];
        }
        if (image) {
//           NSAttributedString *icon = [NSAttributedString attachmentStringWithContent:image
//                                                                          contentMode:UIViewContentModeCenter
//                                                                       attachmentSize:CGSizeMake(image.size.width, image.size.height)
//                                                                          alignToFont:font
//                                                                            alignment:YYTextVerticalAlignmentCenter];
//            [titleAttr insertAttributedString:icon atIndex:0];
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            attach.image = image; //精华帖
            attach.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
            NSAttributedString *icon = [NSAttributedString attributedStringWithAttachment:attach];
            [titleAttr insertAttributedString:icon atIndex:0];
            [titleAttr insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:1];
        }
        _titleLabel.attributedText = titleAttr;
    }
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(space);
    }];
}

- (void)setUserInfo:(User *)userInfo content:(NSString *)content publishTime:(NSString *)publishTime {
    [self.userInfoView setUserInfo:userInfo publishTime:publishTime];
    _titleLabel.text = content;
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
