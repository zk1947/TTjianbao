//
//  JHPlatformResultsDescCell.m
//  TTjianbao
//
//  Created by 张坤 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPlatformResultsDescCell.h"
#import "UILabel+LabelHeightAndWidth.h"

@interface JHPlatformResultsDescCell ()
/** 拒绝说明 */
@property (nonatomic, strong) UILabel *titleLabel;
/** 拒绝说明描述 */
@property (nonatomic, strong) UILabel *descLabel;
@end

@implementation JHPlatformResultsDescCell

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
    static NSString *const identifier=@"JHPlatformResultsDescCell";
    JHPlatformResultsDescCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell=[[JHPlatformResultsDescCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubViews];
        [self layoutUI];
    }
    return self;
}

#pragma mark - 2、不同业务处理之间的方法以
+ (CGFloat)cellHeight{
    CGFloat height = 51;
    height += [UILabel getHeightByWidth:ScreenW-40 title:@"同意退款" font:[UIFont fontWithName:kFontNormal size:13]];
    return height;
}
#pragma mark - Network 3、网络请求

#pragma mark - Action Event 4、响应事件

#pragma mark - Call back 5、回调事件

#pragma mark - Delegate 6、代理、数据源

#pragma mark - interface 7、UI处理
-(void)setupSubViews{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descLabel];
}

-(void)layoutUI{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(21);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
}

- (void)setReasonText:(NSString *)reasonText {
    _reasonText = reasonText;
    self.descLabel.text = reasonText;
}

#pragma mark - lazy loading 8、懒加载
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.text = @"平台介入结果";
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    }
    return _titleLabel;
}

- (UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = HEXCOLOR(0x666666);
        _descLabel.text = @"同意退款";
        _descLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}
@end
