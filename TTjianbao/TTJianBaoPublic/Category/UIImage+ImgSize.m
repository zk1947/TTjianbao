//
//  UIImage+ImgSize.m
//  TTjianbao
//
//  Created by YJ on 2021/1/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "UIImage+ImgSize.h"
#import <ImageIO/ImageIO.h>
#import "SDImageCache.h"

@implementation UIImage (ImgSize)

+(CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]])
    {
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]])
    {
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        
    return CGSizeZero;
    
    NSString* absoluteString = URL.absoluteString;
    
    UIImage *image;

    if ([[SDImageCache sharedImageCache] diskImageDataExistsWithKey:absoluteString])
    {
        NSData *data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataForKey:) withObject:URL.absoluteString];
        image = [UIImage imageWithData:data];
        return image.size;
    }
    else
    {
        CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)URL, NULL);
        CGFloat width = 0, height = 0;
            
        if (imageSourceRef)
        {
            CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
                
            if (imageProperties != NULL)
            {
                CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
       #if defined(__LP64__) && __LP64__
                if (widthNumberRef != NULL)
                {
                    CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
                }
                CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
                if (heightNumberRef != NULL)
                {
                    CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
                }
        #else
                if (widthNumberRef != NULL)
                {
                    CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
                }
                    
                CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
                    
                if (heightNumberRef != NULL)
                {
                    CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
                }
        #endif
                NSInteger orientation = [(__bridge NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyOrientation) integerValue];
                CGFloat temp = 0;
                switch (orientation)
                {
                    case UIImageOrientationLeft:
                    case UIImageOrientationRight:
                    case UIImageOrientationLeftMirrored:
                    case UIImageOrientationRightMirrored:
                    {
                        temp = width;
                        width = height;
                        height = temp;
                    }
                    break;
                    default:
                    break;
                }
                    
                CFRelease(imageProperties);
            }
                CFRelease(imageSourceRef);
        }
            return CGSizeMake(width, height);
    }
}


@end
