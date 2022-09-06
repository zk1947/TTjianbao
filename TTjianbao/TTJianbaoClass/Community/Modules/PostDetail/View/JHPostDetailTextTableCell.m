//
//  JHPostDetailTextTableCell.m
//  TTjianbao
//
//  Created by lihui on 2020/8/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPostDetailTextTableCell.h"
#import "UIImageView+JHWebImage.h"
#import "JHPostDetailModel.h"
#import "PPStickerDataManager.h"

#define LINESPACE 6.f

@interface JHPostDetailTextTableCell ()

@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation JHPostDetailTextTableCell


- (void)setContent:(NSString *)content isEssence:(BOOL)isEssence {
    if ([content isNotBlank]) {
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:content];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:LINESPACE];//调整行间距
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.hyphenationFactor = 1.0;
        paragraphStyle.firstLineHeadIndent = 0.0;
        paragraphStyle.paragraphSpacingBefore = 0.0;
        paragraphStyle.headIndent = 0;
        paragraphStyle.tailIndent = 0;
        [attri addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,
                               NSFontAttributeName:[UIFont fontWithName:kFontNormal size:16],
                               NSForegroundColorAttributeName:kColor333
        } range:NSMakeRange(0, [content length])];

        if (isEssence == 1) {
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            attach.image = [UIImage imageNamed:@"sq_icon_essence"]; //精华帖
            attach.bounds = CGRectMake(0, 0, 31, 14);
            NSAttributedString *icon = [NSAttributedString attributedStringWithAttachment:attach];
            [attri insertAttributedString:icon atIndex:0];
            [attri insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:1];
        }
        [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:attri font:_detailLabel.font];
        _detailLabel.attributedText = attri.mutableCopy;
    }
}

- (void)dealloc {
    NSLog(@"%s被释放了🔥🔥🔥🔥", __func__);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:kFontNormal size:16];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:label];
        _detailLabel = label;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 15, 10, 15));
        }];
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
