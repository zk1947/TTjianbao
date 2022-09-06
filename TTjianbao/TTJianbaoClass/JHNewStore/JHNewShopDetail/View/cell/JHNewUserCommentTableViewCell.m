//
//  JHNewUserCommentTableViewCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewUserCommentTableViewCell.h"
#import "TTjianbaoHeader.h"
#import "JHUIFactory.h"
#import "JHNewShopCommentGoodsTagsView.h"
#import "JHNewShopCommentPhotoView.h"
#import "JHPhotoBrowserManager.h"


@interface JHNewUserCommentTableViewCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UIView * starView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *replyView;
@property (nonatomic, strong) UILabel *replyContentLabel;
@property (nonatomic, strong) JHNewShopCommentPhotoView *photoView; //图片组
@property (nonatomic, strong) JHNewShopCommentGoodsTagsView *tagsView;
@property (nonatomic, strong) UIView *imagesView;
@property (nonatomic, strong) UIButton *unfoldButton;
@property (nonatomic, strong) JHCustomLine *line;

@end


@implementation JHNewUserCommentTableViewCell

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
        make.top.equalTo(self.backView).offset(13);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.offset(12);
    }];
    
    //昵称
    [self.backView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImage.mas_top).offset(2);
        make.left.equalTo(self.headImage.mas_right).offset(8);
        make.right.equalTo(self.backView.mas_right).offset(-90);
    }];
    
    //评分
    [self.backView addSubview:self.starView];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(4);
        make.left.equalTo(self.headImage.mas_right).offset(4);
        make.size.mas_equalTo(CGSizeMake(60, 10));
    }];
        
    //评论时间
    [self.backView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headImage);
        make.right.equalTo(self.backView.mas_right).offset(-12);
    }];
    
    //评论标签
    [self.backView addSubview:self.tagsView];
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImage.mas_bottom).offset(6);
        make.left.equalTo(self.backView).offset(8);
        make.right.equalTo(self.backView).offset(-8);
        make.height.mas_offset(0);
    }];
    
    //评论内容
    [self.backView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagsView.mas_bottom).offset(10);
        make.left.equalTo(self.backView).offset(12);
        make.right.equalTo(self.backView).offset(-12);
    }];
    
    //图片
    [self.backView addSubview:self.imagesView];
    [self.imagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(0);
        make.left.equalTo(self.backView).offset(12);
        make.right.equalTo(self.backView).offset(-12);
        make.height.mas_offset(10);
    }];
    
    //商家回复
    [self.backView addSubview:self.replyView];
    [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imagesView.mas_bottom).offset(10);
        make.left.equalTo(self.backView).offset(12);
        make.right.equalTo(self.backView).offset(-12);
    }];

    [self.replyView addSubview:self.replyContentLabel];
    [self.replyContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.replyView).offset(10);
        make.left.equalTo(self.replyView).offset(12);
        make.right.equalTo(self.replyView).offset(-12);
        make.bottom.equalTo(self.replyView).offset(-10);
    }];

    
   //展开收起
    [self.replyView addSubview:self.unfoldButton];
    [self.unfoldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.replyView).offset(-12);
        make.bottom.equalTo(self.replyView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    
    [self.backView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.replyView.mas_bottom).offset(14);
        make.bottom.equalTo(self.backView.mas_bottom).offset(0);
        make.height.offset(0.5);
        make.left.equalTo(self.backView).offset(12);
        make.right.equalTo(self.backView).offset(-12);
    }];
    
}

- (void)clickUnfoldButtonAction:(UIButton *)sender{
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickUnfoldButtonAction:)]){
        [self.delegate clickUnfoldButtonAction:self];
    }
}

- (void)setCommentListModel:(JHNewShopUserCommentListModel *)commentListModel{
    _commentListModel = commentListModel;
    NSString *headImageUrl = [commentListModel.customerImg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
    [self.headImage jh_setImageWithUrl:headImageUrl];
    self.nameLabel.text = commentListModel.customerName;
    self.timeLabel.text = commentListModel.createTime;
    
    //评分
    [self.starView removeAllSubviews];
    for (int i=0; i < [commentListModel.pass intValue]; i++) {
        UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 10000+i;
        [button setImage:[UIImage imageNamed:@"newStore_star_yellow_icon"] forState:UIControlStateSelected];
        [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        button.frame = CGRectMake(4+i*14, 0, 10, 10);
        [self.starView addSubview:button];
        button.selected = YES;
    }
    //标签
    NSMutableArray *tagsArr = [NSMutableArray array];
    for (int i = 0; i < commentListModel.commentTagsList.count; ++i) {
        [tagsArr addObject:commentListModel.commentTagsList[i][@"tagName"]];
    }
    [self.tagsView removeAllSubviews];
    self.tagsView.tagsArray = [NSArray arrayWithArray:tagsArr];
    [self.tagsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(self.tagsView.tagsViewHeight-4);
    }];
    
    //评价内容
    self.descLabel.text = commentListModel.commentContent;
    
    //评价图片
    [self.imagesView removeAllSubviews];
    NSArray *imagesArr = commentListModel.commentImgsList;
    CGFloat imagesViewHeight = 0.0;
    if (imagesArr.count == 1) {
        imagesViewHeight = 205;
    }else if (imagesArr.count > 1) {
        imagesViewHeight = (ScreenW-24 - 8*(imagesArr.count-1))/imagesArr.count;
    }
    [self.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (commentListModel.commentImgsList.count > 0) {
            make.top.equalTo(self.descLabel.mas_bottom).offset(10);
        }else{
            make.top.equalTo(self.descLabel.mas_bottom).offset(0);
        }
        make.height.mas_offset(imagesViewHeight);
    }];
    self.photoView = [[JHNewShopCommentPhotoView alloc] initWithFrame:CGRectMake(0, 0, ScreenW -24, imagesViewHeight)];
    self.photoView.images = imagesArr;
    self.photoView.clickPhotoBlock = ^(NSArray *sourceViews, NSInteger index) {
        //浏览图片
        [JHPhotoBrowserManager showPhotoBrowserThumbImages:imagesArr origImages:imagesArr sources:sourceViews currentIndex:index canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleZoom hideDownload:YES];
    };
    [self.imagesView addSubview:self.photoView];
    
    
    
    //商家回复
    if (commentListModel.shopReply.length > 0) {
        self.replyContentLabel.text = [NSString stringWithFormat:@"商家回复：%@",commentListModel.shopReply];
        self.replyContentLabel.attributedText = [self getAcolorfulStringWithSpecialText:@"商家回复：" specialColor:HEXCOLOR(0x666666) specialFont:[UIFont fontWithName:kFontMedium size:14] AllText:_replyContentLabel.text];
        if ([self needLinesWithWidth:ScreenW-48 currentLabel:_replyContentLabel] > 2) {
            self.unfoldButton.hidden = NO;
            // 修改按钮的折叠打开状态
            if (commentListModel.isShowMore) {
                self.replyContentLabel.numberOfLines = 0;
                [self.unfoldButton setTitle:@"收起" forState:UIControlStateNormal];
            }else{
                self.replyContentLabel.numberOfLines = 2;
                [self.unfoldButton setTitle:@"展开" forState:UIControlStateNormal];
    
            }
        }else{
            self.replyContentLabel.numberOfLines = 0;
            self.unfoldButton.hidden = YES;
        }
        [self.replyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imagesView.mas_bottom).offset(10);
        }];
        [self.replyContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.replyView).offset(10);
            make.bottom.equalTo(self.replyView).offset(-10);
        }];
    }else{
        self.replyContentLabel.text = @"";
        [self.replyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imagesView.mas_bottom).offset(0);
        }];
        [self.replyContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.replyView).offset(0);
            make.bottom.equalTo(self.replyView).offset(0);
        }];
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
        _headImage.layer.masksToBounds = YES;
        _headImage.layer.cornerRadius = 20;
    }
    return _headImage;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"郄***苑";
        _nameLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _nameLabel.textColor = [CommHelp toUIColorByStr:@"#333333"];
    }
    return _nameLabel;
}
- (UIView *)starView{
    if (!_starView) {
        _starView = [[UIView alloc]init];
    }
    return _starView;
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
- (JHNewShopCommentGoodsTagsView *)tagsView{
    if (!_tagsView) {
        _tagsView = [[JHNewShopCommentGoodsTagsView alloc] init];
        _tagsView.tagHeight = 21;
        _tagsView.tagsMargin = 4;
        _tagsView.tagsLineSpacing = 4;
        _tagsView.tagsMinPadding = 4;
    }
    return _tagsView;
}

- (UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc]init];
        _descLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _descLabel.textColor = [CommHelp toUIColorByStr:@"#222222"];
        _descLabel.numberOfLines = 0;
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
- (UIView *)replyView{
    if (!_replyView) {
        _replyView = [[UIView alloc] init];
        _replyView.backgroundColor = HEXCOLOR(0xF7F7F7);
        _replyView.layer.cornerRadius = 4;
        _replyView.layer.masksToBounds = YES;
    }
    return _replyView;
}
- (UILabel *)replyContentLabel{
    if (!_replyContentLabel) {
        _replyContentLabel = [[UILabel alloc] init];
        _replyContentLabel.textColor = HEXCOLOR(0x666666);
        _replyContentLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _replyContentLabel.numberOfLines = 2;
        
    }
    return _replyContentLabel;
}
- (UIButton *)unfoldButton{
    if (!_unfoldButton) {
        _unfoldButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_unfoldButton setBackgroundImage:JHImageNamed(@"newStore_shopComment_icon") forState:UIControlStateNormal];
        [_unfoldButton setTitleColor:HEXCOLOR(0x2F66A0) forState:UIControlStateNormal];
        [_unfoldButton setTitle:@"展开" forState:UIControlStateNormal];
        _unfoldButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _unfoldButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _unfoldButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
        [_unfoldButton addTarget:self action:@selector(clickUnfoldButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _unfoldButton.hidden = YES;

    }
    return _unfoldButton;
}
- (JHCustomLine *)line{
    if (!_line) {
        _line = [JHUIFactory createLine];
    }
    return _line;
}
- (NSMutableAttributedString *)getAcolorfulStringWithSpecialText:(NSString *)text specialColor:(UIColor *)color specialFont:(UIFont *)font AllText:(NSString *)allText{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allText];
    [str beginEditing];
    if (text) {
        NSRange range1 = [allText rangeOfString:text];
        [str addAttribute:(NSString *)(NSForegroundColorAttributeName) value:color range:range1];
        if (font) {
            [str addAttribute:NSFontAttributeName value:font range:range1];
        }
    }
    [str endEditing];
    return str;
}
//获取文字所需行数
- (NSInteger)needLinesWithWidth:(CGFloat)width currentLabel:(UILabel *)currentLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = currentLabel.font;
    NSString *text = currentLabel.text;
    NSInteger sum = 0;
    //加上换行符
    NSArray *rowType = [text componentsSeparatedByString:@"\n"];
    for (NSString *currentText in rowType) {
        label.text = currentText;
        //获取需要的size
        CGSize textSize = [label systemLayoutSizeFittingSize:CGSizeZero];
        NSInteger lines = ceil(textSize.width/width);
        lines = lines == 0 ? 1 : lines;
        sum += lines;
    }
    return sum;
}
@end
