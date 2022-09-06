//
//  JHPostDetailTextLinkCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPostDetailTextLinkCell.h"
#import <UIImageView+WebCache.h>
#import "JHPostDetailModel.h"
#import <YYKit.h>
#import "PPStickerDataManager.h"
#import "JHAttributeStringTool.h"
#import "JHTextView.h"
#import "JHLinkClickAction.h"

#define LINESPACE 6.f

@interface JHPostDetailTextLinkCell() <UITextViewDelegate>
@property (nonatomic, strong) JHTextView *textView;
@end

@implementation JHPostDetailTextLinkCell


- (void)setContent:(NSMutableAttributedString *)content isEssence:(BOOL)isEssence {
    NSMutableAttributedString *attri = content;
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
                           NSFontAttributeName:[UIFont fontWithName:kFontNormal size:16]
    } range:NSMakeRange(0, [content length])];
    
    if (isEssence == 1) {
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"sq_icon_essence"];
        attach.bounds = CGRectMake(0, 0, 31, 14);
        NSAttributedString *attachText = [NSAttributedString attributedStringWithAttachment:attach];
        //插入到开头
        [attri insertAttributedString:attachText atIndex:0];
    }
    
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:attri font:[UIFont fontWithName:kFontNormal size:16]];
        
    _textView.attributedText = [JHAttributeStringTool markAtBlueForPostDetail:attri];
    CGFloat textHeight = [_textView sizeThatFits:CGSizeMake(ScreenW-30, CGFLOAT_MAX)].height;
    [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textHeight);
    }];
}

- (void)dealloc {
    NSLog(@"%s被释放了🔥🔥🔥🔥", __func__);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        JHTextView *textView = [[JHTextView alloc] init];
        textView.font = [UIFont fontWithName:kFontNormal size:16];
        textView.delegate = self;
        [self.contentView addSubview:textView];
        textView.translatesAutoresizingMaskIntoConstraints = NO;
        textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
        _textView = textView;
                
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(0);
            make.bottom.equalTo(self.contentView);
        }];
        
        
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(toCopy:)];
        UIMenuItem *selectAllItem = [[UIMenuItem alloc] initWithTitle:@"全选" action:@selector(toSelectAll:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:copyItem,selectAllItem,nil]];
    }
    return self;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSArray *parameters = [URL.absoluteString componentsSeparatedByString:@","];
    if (parameters.count > 1) {
        NSString *urlString = parameters.firstObject;
        NSString *type = parameters.lastObject;
        if ([type isEqualToString:kToUserInfoPage]) {
            urlString = [urlString stringByURLDecode];
            [JHLinkClickAction linkClickActionWithUserName:urlString];
        }
        else {
            NSInteger linekType = [parameters.lastObject integerValue];
            [JHLinkClickAction linkClickActionWithType:linekType andUrl:urlString];
        }
        return NO;
    }
    
    return NO;
}

- (void)toCopy:(id)sender {
}

- (void)toSelectAll:(id)sender {
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
