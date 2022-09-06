//
//  JHBlankPostTableViewCell.m
//  TTjianbao
//
//  Created by lihui on 2020/9/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBlankPostTableViewCell.h"
#import "TTjianbaoMarcoUI.h"
#import "JHSQModel.h"

@interface JHBlankPostTableViewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *blankLabel;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation JHBlankPostTableViewCell

- (void)dealloc {
    NSLog(@"%s被释放了🔥🔥🔥🔥🔥", __func__);
}

- (void)setPostData:(JHPostData *)postData {
    if (!postData) {
        return;
    }
    _postData = postData;
    _deleteButton.hidden = !_postData.is_self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kColorF5F6FA;
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = kColorFFF;
    [self.contentView addSubview:bgView];
    _bgView = bgView;
    
    UILabel *blankLabel = [[UILabel alloc] init];
    blankLabel.backgroundColor = HEXCOLOR(0xF9F9F9);
    blankLabel.text = @"帖子已被删除";
    blankLabel.font = [UIFont fontWithName:kFontNormal size:15];
    blankLabel.textColor = kColor999;
    blankLabel.textAlignment = NSTextAlignmentCenter;
    blankLabel.layer.cornerRadius = 8.f;
    blankLabel.layer.masksToBounds = YES;
    [_bgView addSubview:blankLabel];
    _blankLabel = blankLabel;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn setTitleColor:kColor666 forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:kFontMedium size:13];
    [btn addTarget:self action:@selector(__handleDeleteEvent) forControlEvents:UIControlEventTouchUpInside];
    _deleteButton = btn;
    [_bgView addSubview:btn];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    
    [_blankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.bgView).offset(15);
        make.trailing.equalTo(self.bgView).offset(-15);
        make.height.mas_equalTo(64);
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.blankLabel);
        make.bottom.equalTo(self.bgView);
        make.height.mas_equalTo(48);
    }];
}

#pragma mark -
#pragma mark - 事件处理

- (void)__handleDeleteEvent {
    if (self.deleteBlock) {
        self.deleteBlock(self.indexPath.row);
    }
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
