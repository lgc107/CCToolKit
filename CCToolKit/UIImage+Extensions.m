//
//  UIImage+Extensions.m
//  CCToolKit
//
//  Created by 季秋 on 2017/5/7.
//  Copyright © 2017年 Freedom. All rights reserved.
//

#import "UIImage+Extensions.h"

@implementation Shadow

- (instancetype)init{
    self = [super init];
    if (self) {
        self.color = [UIColor blackColor].CGColor;
        self.blur = 5.0;
        self.offset = CGSizeMake(-2, -2);
    }
    return self;
}

@end

@implementation UIImage (Init)

#pragma mark -- FilePath
+ (UIImage *)cc_imageWithName:(NSString *)imageName inBundle:(NSString *)bundleName{
    // if bundleName hasSuffix “.bundle”, delete ".bundle"
    if ([bundleName hasSuffix:@".bundle"]) {
        bundleName = bundleName.stringByDeletingPathExtension;
    }
    NSString *path = [[NSBundle mainBundle]pathForResource:bundleName ofType:@"bundle"];
    if (path == nil) {return nil;}
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    if (bundle == nil) {return nil;}
    NSString *file = [bundle.resourcePath stringByAppendingPathComponent:imageName];
    if (file == nil) {return nil;}
    UIImage *newImage = [UIImage imageWithContentsOfFile:file];
    return  newImage;
}

#pragma mark -- Drawing
+(UIImage *)cc_imageWithColor:(UIColor *)color{
    return  [self cc_imageWithColor:color Size:CGSizeMake(1, 1)];
}

+(UIImage *)cc_imageWithColor:(UIColor *)color Size:(CGSize)size{
    return [self cc_imageWithColor:color Shadow:nil Size:size];
}


+ (UIImage *)cc_imageWithColor:(UIColor *)color Shadow:(Shadow *)shadow Size:(CGSize)size{
    if (!color || size.width <= 0 || size.height <= 0) { return nil;}
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    //This function is equivalent to calling the UIGraphicsBeginImageContextWithOptions function with the opaque parameter set to NO and a scale factor of 1.0.
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);//Fill Color
    CGContextFillRect(context, rect);
    
    //shadowColor
    if (shadow) {
        CGPathRef roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0].CGPath;
        CGContextAddPath(context, roundedRect);
        CGContextSetShadowWithColor(context, shadow.offset, shadow.blur, shadow.color);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextStrokePath(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (shadow) {
        CGSize size = image.size;
        
        UIEdgeInsets insets = UIEdgeInsetsMake(truncf(size.height-1)/2, truncf(size.width-1)/2, truncf(size.height-1)/2, truncf(size.width-1)/2);
        
        return [image resizableImageWithCapInsets:insets];
 
    }
    return image;
}


#pragma mark -- append
+ (UIImage *)verticalImageFromArray:(NSArray <UIImage *>*)imagesArray
{
    if (imagesArray == nil || imagesArray.count == 0) {
        return nil;
    }
    UIImage *unifiedImage = nil;
    CGSize totalImageSize = verticalAppendedTotalImageSizeFromImagesArray(imagesArray);
    UIGraphicsBeginImageContextWithOptions(totalImageSize, NO, 0.f);
    // For each image found in the array, create a new big image vertically
    int imageOffsetFactor = 0;
    for (UIImage *img in imagesArray) {
        [img drawAtPoint:CGPointMake(0, imageOffsetFactor)];
        imageOffsetFactor += img.size.height;
    }
    
    unifiedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return unifiedImage;
}

CGSize verticalAppendedTotalImageSizeFromImagesArray(NSArray *imagesArray){
    CGSize totalSize = CGSizeZero;
    for (UIImage *im in imagesArray) {
        CGSize imSize = [im size];
        totalSize.height += imSize.height;
        // The total width is gonna be always the wider found on the array
        totalSize.width = MAX(totalSize.width, imSize.width);
    }
    return totalSize;
}

@end

#pragma mark -- ImageInfo

@implementation UIImage (ImageInfo)

- (BOOL)cc_hasAlphaChannel{
    if (!self || self.CGImage == NULL) {return NO;}
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage) & kCGBitmapAlphaInfoMask;
    return (alpha == kCGImageAlphaPremultipliedLast /* For example, premultiplied RGBA */ || alpha == kCGImageAlphaPremultipliedFirst /* For example, premultiplied ARGB */ || alpha == kCGImageAlphaLast /* For example, non-premultiplied RGBA */ || alpha == kCGImageAlphaFirst);
}

@end


#pragma mark --  Modify Image


@implementation UIImage (Modify)

// ------------------------------------------------------------------
// --------------------- 以下是自定义图像处理部分 -----------------------
// ------------------------------------------------------------------
- (UIImage *)cc_imageByResizeToSize:(CGSize)size{
    if (!self || size.width <= 0 || size.height <= 0) { return nil; }
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



- (UIImage *)cc_imageByCropToRect:(CGRect)rect{
    if (!self || CGRectGetWidth(rect) <= 0 || CGRectGetHeight(rect) <= 0 ) {return nil;}
    rect.origin.x *= self.scale;
    rect.origin.y *= self.scale;
    rect.size.width *= self.scale;
    rect.size.height *= self.scale;
    
    CGImageRef imageRef =  CGImageCreateWithImageInRect(self.CGImage, rect);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return newImage;
    
}

#pragma mark -- Corner radius

- (UIImage *)cc_imageByRoundCornerRadius:(CGFloat)radius {
    return [self cc_imageByRoundCornerRadius:radius borderWidth:0 borderColor:nil];
}

- (UIImage *)cc_imageByRoundCornerRadius:(CGFloat)radius
                             borderWidth:(CGFloat)borderWidth
                             borderColor:(UIColor *)borderColor {
    return [self cc_imageByRoundCornerRadius:radius corners:UIRectCornerAllCorners borderWidth:borderWidth borderColor:borderColor borderLineJoin:kCGLineJoinMiter];
}

- (UIImage *)cc_imageByRoundCornerRadius:(CGFloat)radius
                                 corners:(UIRectCorner)corners
                             borderWidth:(CGFloat)borderWidth
                             borderColor:(UIColor *)borderColor
                          borderLineJoin:(CGLineJoin)borderLineJoin {
    
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }
    
 
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
   
    CGFloat tempRadius = radius;
    
    if (tempRadius < 0) { tempRadius = 0;}
    //Max Value
    if (tempRadius > minSize * 0.5) { tempRadius = minSize  * 0.5; }
    
    if (borderWidth < minSize / 2) {
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        if (borderLineJoin) {path.lineJoinStyle = borderLineJoin;}
        
        [borderColor setStroke];
        
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



-(UIImage *)dealImageWithCornerRadius:(CGFloat)radius{
    // CGDataProviderRef 把 CGImage 转 二进制流
    CGDataProviderRef provider = CGImageGetDataProvider(self.CGImage);
    void *imgData = (void *)CFDataGetBytePtr(CGDataProviderCopyData(provider));
    
    // 将图片二进制流进行处理
    int width = self.size.width * self.scale;
    int height = self.size.height * self.scale;
    cornerImage(imgData, width, height, radius);
    
    // 二进制流转换为图片
    CGDataProviderRef pv = CGDataProviderCreateWithData(NULL, imgData, width * height * 4, releaseData);
    CGImageRef content = CGImageCreate(width, height, 8, 32, 4 * width , CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast, pv, NULL, true, kCGRenderingIntentDefault);
    UIImage *result = [UIImage imageWithCGImage:content];
    
    CGDataProviderRelease(pv);      // 释放空间
    CGImageRelease(content);
    
    return result;
}



// ------------------------------------------------------------------
// ---------------------     Start            -----------------------
// ------------------------------------------------------------------

/**
 Clipping Image, set the alpha of the pixels outside the circle to 0.
 
 @param img Image's Pointer
 @param width Image's Original Width
 @param height Image's Original Height
 @param cornerRadius  The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to half
 the width or height.
 */
void cornerImage(UInt32 * const img, int width, int height, CGFloat cornerRadius){
    CGFloat c = cornerRadius;
    CGFloat min = width > height ? height : width;
    if (c < 0) { c = 0;}
    //Max Value
    if (c > min * 0.5) { c = min  * 0.5; }
    
    //左上 y:[0, c), x:[0, c-y)
    for (int y = 0; y < c; y++) {
        for (int x = 0; x < c-y; x++) {
            // y*w+x pointer
            UInt32 *p = img + y * width + x;    // p 32位指针，RGBA排列，各8位
            // to 0.
            if (isCircle(c, c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
    // 右上 y:[0, c), x:[w-c+y, w)
    int tmp = width-c;
    for (int y=0; y<c; y++) {
        for (int x=tmp+y; x<width; x++) {
            UInt32 *p = img + y * width + x;
            if (isCircle(width-c, c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
    // 左下 y:[h-c, h), x:[0, y-h+c)
    tmp = height-c;
    for (int y=height-c; y<height; y++) {
        for (int x=0; x<y-tmp; x++) {
            UInt32 *p = img + y * width + x;
            if (isCircle(c, height-c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
    // 右下 y~[h-c, h), x~[w-c+h-y, w)
    tmp = width-c+height;
    for (int y=height-c; y<height; y++) {
        for (int x=tmp-y; x<width; x++) {
            UInt32 *p = img + y * width + x;
            if (isCircle(width-c, height-c, c, x, y) == false) {
                *p = 0;
            }
        }
    }
}


/**
 Determine whether the point p(px,py) exists in the circle of radius c(cx,cy) with radius r
 
 @return  false  or  true .
 */
static inline bool isCircle(float cx, float cy, float px, float py, float r){
    if ((px - cx) * (px - cx) + (py - cy) * (py - cy) > r * r) {
        return  false;
    }
    return  true;
}

void releaseData(void *info,const void *  data, size_t size){
    free((void *)data);
}


// ------------------------------------------------------------------
// ---------------------         End          -----------------------
// ------------------------------------------------------------------




@end



