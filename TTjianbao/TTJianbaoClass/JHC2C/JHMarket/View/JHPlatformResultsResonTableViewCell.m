//
//  JHPlatformResultsResonTableViewCell.m
//  TTjianbao
//
//  Created by 张坤 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPlatformResultsResonTableViewCell.h"
#import "JHPhotoBrowserManager.h"
#import "UILabel+LabelHeightAndWidth.h"
#import "UIImageView+WebCache.h"

@interface JHPlatformResultsResonTableViewCell ()<UIGestureRecognizerDelegate>
/** 拒绝说明凭证 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 拒绝说明理由 */
@property (nonatomic, strong) UILabel *descLabel;
/** 拒绝说明图片展示 */
@property (nonatomic, strong) UIView *groundView;

@end

@implementation JHPlatformResultsResonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - life cyle 1、重写初始化方法
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *const identifier=@"JHPlatformResultsResonTableViewCell";
    JHPlatformResultsResonTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell=[[JHPlatformResultsResonTableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubViews];
        [self layoutUI];
        
        CGFloat imageWidth = 80;
        for (int i = 0; i < 6; i++) {
            UIImageView *imageView =[[UIImageView alloc]init];
            imageView.tag = 100+i;
            imageView.layer.cornerRadius = 8;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
            imageView.image = [UIImage imageNamed:@"common_photo_placeholder"];
            [self.groundView addSubview:imageView];
            imageView.frame = CGRectMake((i%3)*(imageWidth+10), (i/3)*(imageWidth+10), imageWidth, imageWidth);
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusGesture:)];
            tapGestureRecognizer.delegate = self;
            [imageView addGestureRecognizer:tapGestureRecognizer];
        }
        [self.groundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(imageWidth*2+10);
        }];
    }
    return self;
}

#pragma mark - 2、不同业务处理之间的方法以
+ (CGFloat)cellHeight{
    CGFloat height = 59;
    height += [UILabel getHeightByWidth:ScreenW-40 title:@"这是卖家拒绝的理由，这是卖家拒绝的理由，这是卖家拒绝的理由，这是卖家拒绝的理由，这是卖家拒绝的理由，这是卖家拒绝的理由，这是卖家拒绝的理由，这是卖家拒绝的理由，这是卖家拒绝的理由，这是卖家拒绝的理由，这是卖家拒绝的理由" font:[UIFont fontWithName:kFontNormal size:13]];
    height+=170;
    return height;
}
-(void)setupData {
    if (self.model == nil) return;
    self.descLabel.text = self.model.arbResultDesc;
    [self setupImgs:self.model.arbCertificate];
    
}
#pragma mark - Network 3、网络请求

#pragma mark - Action Event 4、响应事件
- (void)focusGesture:(UIGestureRecognizer*)sender {
    NSInteger index = sender.view.tag-100;
//    NSLog(@"index=%d",index);
    
//    [JHPhotoBrowserManager showPhotoBrowserThumbImages:self.postData.images_thumb mediumImages:self.postData.images_medium origImages:self.postData.images_origin sources:sourceViews currentIndex:index canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleZoom];
}
#pragma mark - Call back 5、回调事件

#pragma mark - Delegate 6、代理、数据源

#pragma mark - interface 7、UI处理
-(void)setupSubViews{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.groundView];
    
}

-(void)layoutUI{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(21);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    [self.groundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(0);
    }];
}

- (void)setupImgs:(NSArray *)imgs {
    
    for (UIImageView *iv in  self.groundView.subviews) {
        iv.hidden = YES;
    }
    
    for (int i=0; i<imgs.count; i++) {
        UIImageView *iv = self.groundView.subviews[i];
        iv.hidden = NO;
        JHPlatformResultImageInfo *imageInfo = imgs[i];
        NSString *imageStr = imageInfo.small;
        
        [iv sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"common_photo_placeholder"]];
    }
    
    CGFloat imageWidth = 80;
    [self.groundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(imageWidth*(imgs.count>=3?2:1)+10);
    }];
    
}

#pragma mark - lazy loading 8、懒加载
- (void)setModel:(JHPlatformResultInfo *)model {
    _model = model;
    [self setupData];
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.text = @"理由及凭证";
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    }
    return _titleLabel;
}

- (UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = HEXCOLOR(0x666666);
        _descLabel.text = @"这是客服后台输入的仲裁理由， 这是客服后台输入的仲裁理由，这是客服后台输入的仲裁理由 这是客服后台输入的仲裁理由，这是客服后台输入的仲裁理由，这是客服后台输入的仲裁理由";
        _descLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

-(UIView *)groundView{
    if (!_groundView) {
        _groundView = [[UIView alloc]init];
        _groundView.userInteractionEnabled = YES;
    }
    return _groundView;
}

@end
