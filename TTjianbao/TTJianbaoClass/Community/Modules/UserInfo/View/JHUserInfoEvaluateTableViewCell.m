//
//  JHUserInfoEvaluateTableViewCell.m
//  TTjianbao
//
//  Created by hao on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUserInfoEvaluateTableViewCell.h"
#import "TTjianbaoHeader.h"
#import "JHUIFactory.h"
#import "JHNewShopCommentPhotoView.h"
#import "JHPhotoBrowserManager.h"
#import "JHUserInfoEvaluateModel.h"


@interface JHUserInfoEvaluateTableViewCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *userView;
@property (nonatomic, strong) YYLabel *descLabel;
@property (nonatomic, strong) JHNewShopCommentPhotoView *photoView; //图片组
@property (nonatomic, strong) UIView *imagesView;
@property (nonatomic, strong) JHCustomLine *line;
@end

@implementation JHUserInfoEvaluateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f));
    }];
    //头像
    [self.backView addSubview:self.headImage];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.offset(12);
    }];
    //昵称
    [self.backView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImage);
        make.left.equalTo(self.headImage.mas_right).offset(8);
        make.right.equalTo(self.backView).offset(-100);
    }];
    //评论时间
    [self.backView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImage);
        make.right.equalTo(self.backView).offset(-12);
    }];
    //用户点击区域
    [self.backView addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(10);
        make.height.mas_equalTo(40);
        make.left.right.equalTo(self.backView);
    }];
    
    //评论内容
    [self.backView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImage.mas_bottom).offset(12);
        make.left.equalTo(self.backView).offset(12);
        make.right.equalTo(self.backView).offset(-12);
    }];
    //图片
    [self.backView addSubview:self.imagesView];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(0);
        make.left.equalTo(self.backView).offset(12);
        make.right.equalTo(self.backView).offset(-12);
        make.height.mas_offset(0);
    }];
    
    [self.backView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imagesView.mas_bottom).offset(10);
        make.bottom.equalTo(self.backView.mas_bottom).offset(0);
        make.height.offset(0.5);
        make.left.equalTo(self.backView).offset(12);
        make.right.equalTo(self.backView).offset(-12);
    }];
    
    [self addSeeMoreButton];
    
}

///点击用户头像
- (void)clickUserInfoAction{
    if (self.userInfoClick){
        self.userInfoClick();
    }
}


- (void)bindViewModel:(id)dataModel params:(NSDictionary *)parmas{
    JHEvaluateresultListModel *listModel = dataModel;
    if (listModel.isOpen) {
        self.descLabel.numberOfLines = 0;
    } else {
        self.descLabel.numberOfLines = 2;
    }
    //头像
    [self.headImage jhSetImageWithURL:[NSURL URLWithString:listModel.customerImg.small] placeholder:JHImageNamed(@"newStore_default_avatar_placehold")];
    //姓名
    self.nameLabel.text = listModel.customerName;
    //时间
    self.timeLabel.text = listModel.createTime;
    //内容
    self.descLabel.text = listModel.commentContent;

    //评价图片
    if (listModel.commentImgs.count > 0) {
        [self.imagesView removeAllSubviews];
        NSArray *imagesArr = listModel.commentImgs;
        CGFloat imagesViewHeight = (ScreenW -24-3*8)/4;
        [self.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descLabel.mas_bottom).offset(10);
            make.height.mas_offset(imagesViewHeight);
        }];
        self.photoView = [[JHNewShopCommentPhotoView alloc] initWithFrame:CGRectMake(0, 0, ScreenW -24, imagesViewHeight)];
        self.photoView.images = imagesArr;
        self.photoView.clickPhotoBlock = ^(NSArray *sourceViews, NSInteger index) {
            //浏览图片
            [JHPhotoBrowserManager showPhotoBrowserThumbImages:imagesArr mediumImages:imagesArr origImages:imagesArr sources:sourceViews currentIndex:index canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleZoom];
        };
        [self.imagesView addSubview:self.photoView];
    }
    
    
}

- (void)addSeeMoreButton {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@" ...展开"];
    [text setColor:[UIColor colorWithHexString:@"408FFE"] range:[text.string rangeOfString:@"展开"]];
    [text setColor:[UIColor colorWithHexString:@"222222"] range:[text.string rangeOfString:@"..."]];
    text.font = self.descLabel.font;
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    seeMore.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openButtonClickAction)];
    [seeMore addGestureRecognizer:tapGesture];
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.size alignToFont:text.font alignment:YYTextVerticalAlignmentCenter];
    self.descLabel.truncationToken = truncationToken;
}

/// 展开
- (void)openButtonClickAction {
    if (self.openClickBlock) {
        self.openClickBlock();
    }
}


- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
    }
    return _backView;
}
- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]init];
        _headImage.image = kDefaultAvatarImage;
        _headImage.contentMode = UIViewContentModeScaleAspectFill;
        [_headImage jh_cornerRadius:20];
    }
    return _headImage;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _nameLabel.textColor = [CommHelp toUIColorByStr:@"#222222"];
    }
    return _nameLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0x999999);
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont fontWithName:kFontMedium size:12];
    }
    return _timeLabel;
}
- (UIView *)userView{
    if (!_userView) {
        _userView = [[UIView alloc] init];
        UITapGestureRecognizer *jh_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserInfoAction)];
        [_userView addGestureRecognizer:jh_tapGesture];
    }
    return _userView;
}
- (YYLabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[YYLabel alloc]init];
        _descLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _descLabel.textColor = [CommHelp toUIColorByStr:@"#222222"];
        _descLabel.preferredMaxLayoutWidth = kScreenWidth - 24;
        _descLabel.numberOfLines = 2;
    }
    return _descLabel;
}
- (UIView *)imagesView{
    if (!_imagesView) {
        _imagesView = [[UIView alloc] init];
        _imagesView.backgroundColor = UIColor.clearColor;
    }
    return _imagesView;
}

- (JHCustomLine *)line{
    if (!_line) {
        _line = [JHUIFactory createLine];
    }
    return _line;
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
