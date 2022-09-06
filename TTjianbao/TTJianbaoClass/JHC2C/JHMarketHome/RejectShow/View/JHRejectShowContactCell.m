//
//  JHRejectShowContactCell.m
//  TTjianbao
//
//  Created by plz on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRejectShowContactCell.h"
#import "UIButton+ImageTitleSpacing.h"

@interface JHRejectShowContactCell ()
@property (nonatomic, strong) UIButton *contactBtn;

@end

@implementation JHRejectShowContactCell

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
    static NSString *const identifier=@"JHRejectShowContactCell";
    JHRejectShowContactCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell=[[JHRejectShowContactCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    return 44;
}
#pragma mark - Network 3、网络请求

#pragma mark - Action Event 4、响应事件

#pragma mark - Call back 5、回调事件

#pragma mark - Delegate 6、代理、数据源

#pragma mark - interface 7、UI处理
-(void)setupSubViews{
    [self.contentView addSubview:self.contactBtn];
}

-(void)layoutUI{
    [self.contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.contentView).offset(2);
        make.bottom.equalTo(self.contentView).offset(-2);
    }];
}

#pragma mark - lazy loading 8、懒加载
-(UIButton *)contactBtn{
    if (!_contactBtn) {
        _contactBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_contactBtn setImage:[UIImage imageNamed:@"c2c_contactSeller_icon"] forState:UIControlStateNormal];
        [_contactBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
        _contactBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_contactBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_contactBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    return _contactBtn;
}
@end
