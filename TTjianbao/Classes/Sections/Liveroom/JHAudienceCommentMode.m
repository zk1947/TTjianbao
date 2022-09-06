//
//  JHAudienceCommentMode.m
//  TTjianbao
//
//  Created by jiangchao on 2019/5/15.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHAudienceCommentMode.h"
#import "LXTagsView.h"
#import "NSString+Extension.h"
@implementation JHAudienceCommentMode

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id" : @"id",
    };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"commentTagsList" : @"CommentTagMode",
        @"orderServiceComments" : @"CommentReplyMode",
    };
    
}
-(CGFloat)height{
    return  [self calculateCellheigh];
}
- (CGFloat)calculateCellheigh
{
    CGFloat cellheight=15+34;
    
    CGFloat tagViewHeight=0;
    if (self.commentTagsList.count>0) {
        CGFloat viewHMargin = 15;
        CGFloat tagInnerSpace = 10;
        CGFloat tagHMargin = 10;
        BOOL isChange=NO;
        CGFloat tagLineWidth = 15;
        for (NSUInteger i = 0; i< self.commentTagsList.count; i ++) {
            CommentTagMode * mode=self.commentTagsList[i];
            NSString *tagTitle = mode.tagName;
            CGFloat tagWidth  = [tagTitle sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(MAXFLOAT, 26)].width + 2 *tagInnerSpace + 0.5;
            tagLineWidth +=  tagWidth + tagHMargin;
            if (tagLineWidth  > ScreenW - viewHMargin) {
                isChange = YES;
            }
        }
        if (!isChange) {
            tagViewHeight=8+26;
        }
        else{
            tagViewHeight=8+26+26+5;
        }
    }
    CGFloat descHeight=0;
    if ([self.commentContent length]>0) {
        NSDictionary *attribute =@{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat titleH = [self.commentContent boundingRectWithSize:CGSizeMake((ScreenW-20), 25 * 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.height;
        descHeight=10+titleH;
        
    }
    CGFloat imagesHeight=0;
    if (self.commentImgsList.count>0) {
        imagesHeight=(ScreenW-25)/4+10;
    }
    
    CGFloat productHeight=35+10;
    
    CGFloat replyHeight=10;//底部的距离
    
    if (self.orderServiceComments.count>0 ) {
        
        replyHeight=replyHeight+20;//顶部的距离
        
        for (int i=0;i< self.orderServiceComments.count  ;i++) {
            CommentReplyMode * mode  = self.orderServiceComments[i];
            NSString * title;
            if (mode.type==0) {
                title=[NSString stringWithFormat:@"客服回复:%@",mode.comment];
               
            }
            else   if (mode.type==1) {
                title=[NSString stringWithFormat:@"主播回复:%@",mode.comment];
            }
            
            CGFloat space=0;
            if (i>0) {
                space=5;
            }

    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0,5)];
    CGFloat titleH = [attString boundingRectWithSize:CGSizeMake((ScreenW-20), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
     
//
//            NSDictionary *attribute =@{NSFontAttributeName:[UIFont systemFontOfSize:12]};
//            CGFloat titleH = [title boundingRectWithSize:CGSizeMake((ScreenW-20), 25 * 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.height;
            replyHeight=replyHeight+5+titleH;
        }
    }
    
    cellheight=cellheight+tagViewHeight+descHeight+imagesHeight+productHeight+replyHeight;
    
    return cellheight;
}
@end
@implementation CommentTagMode
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id" : @"id",
    };
}
@end

@implementation CommentReplyMode

@end
