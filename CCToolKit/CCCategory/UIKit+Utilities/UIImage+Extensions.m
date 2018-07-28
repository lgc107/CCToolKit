//
//  UIImage+Extensions.m
//  CCToolKit
//
//  Created by 季秋 on 2017/5/7.
//  Copyright © 2017年 Freedom. All rights reserved.
//

#import "UIImage+Extensions.h"
#import <Accelerate/Accelerate.h>
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
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(bitmap, color.CGColor);//Fill Color
    CGContextFillRect(bitmap, rect);
    
    //shadowColor
    if (shadow) {
        CGPathRef roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0].CGPath;
        CGContextAddPath(bitmap, roundedRect);
        CGContextSetShadowWithColor(bitmap, shadow.offset, shadow.blur, shadow.color);
        CGContextSetStrokeColorWithColor(bitmap, [UIColor whiteColor].CGColor);
        CGContextStrokePath(bitmap);
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


- (UIImage *)cc_synthesizedWithImage:(UIImage *)otherImage Rect:(CGRect)rect {
        UIGraphicsBeginImageContext(self.size);
        [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
        // 四个参数为水印的位置
        [otherImage drawInRect: rect];
        UIImage * resultingImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return resultingImage;

}

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

-(UIImage *)cc_imageDrawToCirle{
    //1.开启图片大小的上下文
    CGSize size = CGSizeMake(self.size.width *self.scale, self.size.height *self.scale);
    UIGraphicsBeginImageContext(size);
    //2.获取上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    //3.在上下文中画一个园
    CGRect rect =  CGRectMake(0, 0, size.width, size.height);
    CGContextAddEllipseInRect(ref, rect);
    //4.裁剪出边界
    CGContextClip(ref);
    //5.绘制图片
    [self drawInRect:rect];
    //6.获得图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)cc_imageRoundedByCoreGraphicWithCornerRadius:(CGFloat)radius{
//    int w = .width;
//    int h = imageSize.height;
//    int radius = imageSize.width/2;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, self.size.width, self.size.height, 8, 4 * self.size.width, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, radius, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:imageMasked];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    return img;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

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
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(bitmap, 1, -1);
    CGContextTranslateCTM(bitmap, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
   
    CGFloat tempRadius = radius;
    
    if (tempRadius < 0) { tempRadius = 0;}
    //Max Value
    if (tempRadius > minSize * 0.5) { tempRadius = minSize  * 0.5; }
    
    if (borderWidth < minSize / 2) {
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(bitmap);
        [path addClip];
        CGContextDrawImage(bitmap, rect, self.CGImage);
        CGContextRestoreGState(bitmap);
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


// ------------------------------------------------------------------
// --------------------- 以下是自定义图像处理部分 ---------------------
// ------------------------------------------------------------------
-(UIImage *)dealImageWithCornerRadius:(CGFloat)radius{
    // CGDataProviderRef 把 CGImage 转 二进制流
  
    CGDataProviderRef provider = CGImageGetDataProvider(self.CGImage);
    void *imgData = (void *)CFDataGetBytePtr(CGDataProviderCopyData(provider));
    
    // 将图片二进制流进行处理
    int width = self.size.width * self.scale;
    int height = self.size.height * self.scale;
    cornerImage(imgData, width, height, radius);
    
    // 二进制流转换为图片
    CGDataProviderRef dataProviderRef = CGDataProviderCreateWithData(NULL, imgData, width * height * 4, releaseData);
    CGImageRef content = CGImageCreate(width, height, 8, 32, 4 * width , CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast, dataProviderRef, NULL, true, kCGRenderingIntentDefault);
    UIImage *result = [UIImage imageWithCGImage:content];
    
    CGDataProviderRelease(dataProviderRef);      // 释放空间
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
        
            UInt32 *leftTopP = img + y * width + x; // p 32位指针，RGBA排列，各8位
            // to 0.
            if (isCircle(c, c, c, x, y) == false) {
               
                     *leftTopP = 0;
//                    //优化 找到对称点 省去另外三个角的遍历
                    UInt32 *rightTopP = img + y * width +(width - x);
                    UInt32 *leftBottomP = img + (height -y) * width + x;
                    UInt32 *rightBottomP = img + (height -y) * width + (width - x);
                    *rightTopP = 0;
                    *leftBottomP = 0;
                    *rightBottomP = 0;
            }
        }
    }
//    // 右上 y:[0, c), x:[w-c+y, w)
//    int tmp = width-c;
//    for (int y=0; y<c; y++) {
//        for (int x=tmp+y; x<width; x++) {
//            UInt32 *p = img + y * width + x;
//            if (isCircle(width-c, c, c, x, y) == false) {
//                *p = 0;
//            }
//        }
//    }
//    // 左下 y:[h-c, h), x:[0, y-h+c)
//    tmp = height-c;
//    for (int y=height-c; y<height; y++) {
//        for (int x=0; x<y-tmp; x++) {
//            UInt32 *p = img + y * width + x;
//            if (isCircle(c, height-c, c, x, y) == false) {
//                *p = 0;
//            }
//        }
//    }
//    // 右下 y~[h-c, h), x~[w-c+h-y, w)
//    tmp = width-c+height;
//    for (int y=height-c; y<height; y++) {
//        for (int x=tmp-y; x<width; x++) {
//            UInt32 *p = img + y * width + x;
//            if (isCircle(width-c, height-c, c, x, y) == false) {
//                *p = 0;
//            }
//        }
//    }
}


/**
 Determine whether the point p(px,py) exists in the circle of radius c(cx,cy) with radius r
 
 @return  false  or  true .
 */
static inline bool isCircle(float cx, float cy, float r, float px, float py) {
    if ((px-cx) * (px-cx) + (py-cy) * (py-cy) > r * r ) {
        return false;
    }
    return true;
}





void releaseData(void *info,const void *  data, size_t size){
    free((void *)data);
}


// ------------------------------------------------------------------
// ---------------------         End          -----------------------
// ------------------------------------------------------------------


- (UIImage *)cc_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
    // Check pre-conditions.
    if (self.size.width < 1 || self.size.height < 1) {
        NSLog (@"*** error: 无效的 size: (%.2f x %.2f). x跟y必须 >= 1: %@", self.size.width, self.size.height, self);
        return nil;
    }
    if (!self.CGImage) {
        NSLog (@"*** error: image 必须支持 CGImage: %@", self);
        return nil;
    }
    if (maskImage && !maskImage.CGImage) {
        NSLog (@"*** error: maskImage 必须支持 CGImage: %@", maskImage);
        return nil;
    }
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            uint32_t radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        }
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                0,                    0,                    0,  1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            }
            else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        if (!effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped)
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end



@implementation UIImage (ScreenShot)
+ (UIImage *)cc_getScreenShotImage {
  return [self cc_CaptureWithView:[UIApplication sharedApplication].keyWindow];
}



+ (UIImage *)cc_CaptureWithView:(UIView *)view scope:(CGRect)scope{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self cc_CaptureWithView:view].CGImage, scope);
    UIGraphicsBeginImageContext(scope.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, scope.size.width, scope.size.height);
    CGContextTranslateCTM(context, 0, rect.size.height);//下移
    CGContextScaleCTM(context, 1.0f, -1.0f);//上翻
    CGContextDrawImage(context, rect, imageRef);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    CGContextRelease(context);
    return image;
}

+ (UIImage *)cc_CaptureWithView:(UIView *)view{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
        
    } else {
        
        UIGraphicsBeginImageContext(view.bounds.size);
        
    }
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    // get resulting cropped screenshot
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    // end image context
    UIGraphicsEndImageContext();
    return screenshot;

}

@end
