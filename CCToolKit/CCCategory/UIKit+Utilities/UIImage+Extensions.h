//
//  UIImage+Extensions.h
//  CCToolKit
//
//  Created by Harry_L on 2017/5/7.
//  Copyright © 2017年 Freedom. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
  Shadow Class
 */
@interface Shadow : NSObject


/**
 shadow offset,Default value is (-2,-2);
 */
@property (nonatomic,assign) CGSize offset;
/**
 shadow blur,Default value is 1.0;
 */
@property (nonatomic,assign) CGFloat blur;
/**
 shadow color ,Default value is black Color;
 */
@property (nonatomic,assign) CGColorRef _Nullable color;

@end

@interface UIImage (Init)



/**
 Creates and returns an image object by loading the image data from the file at the specified directory.
 
 @param imageName Image's file name
 @param bundleName specified directory, don't need to fill in the Bundle suffix
 */

+ (UIImage *_Nullable)cc_imageWithName:(NSString *_Nonnull)imageName inBundle:(NSString *_Nullable)bundleName;
/**

 Create and return a 1x1 point size image with the given color.
 
 @param color The Color
 */
+(UIImage *_Nullable)cc_imageWithColor:(UIColor *_Nullable)color;

/**
 Create and return a pure color image with the given color and size.
 
 @param color  The color.
 @param size   New image's size.
 */
+(UIImage *_Nullable)cc_imageWithColor:(UIColor *_Nullable)color Size:(CGSize)size;


/**
 Create and return a pure color image with the given color、shadow and size.

 @param color The color
 @param shadow Shadow object
 @param size New image's size
 */
+ (UIImage *_Nullable)cc_imageWithColor:(UIColor *_Nullable)color Shadow:(Shadow *_Nullable)shadow Size:(CGSize)size;



/**
 Create and return a image vertically through the array of images.

 */
+ (UIImage *_Nullable)verticalImageFromArray:(NSArray <UIImage *>*_Nullable)imagesArray;

@end

@interface  UIImage (ImageInfo)

/**
 Whether this image has alpha channel.
 */
- (BOOL)cc_hasAlphaChannel;

@end


@interface UIImage (Modify)

/**
 Return a newImage By synthesized with other Image.
 otherImage add to self with special rect.
 */
- (UIImage *)cc_synthesizedWithImage:(UIImage *)otherImage Rect:(CGRect)rect;

/**
 Return a new image which is scaled from this image.
 The image will be stretched as needed.
 
 @param size  The new size to be scaled, values should be positive.
 
 @return      The new image with the given size.
 */
- (UIImage *_Nullable)cc_imageByResizeToSize:(CGSize)size;

/**
 Returns a new image which is cropped from this image.
 
 @param rect  Image's inner rect.
 
 @return      The new image, or nil if an error occurs.
 */
- (nullable UIImage *)cc_imageByCropToRect:(CGRect)rect;


- (nullable UIImage *)cc_imageDrawToCirle;


- (nullable UIImage *)cc_imageRoundedByCoreGraphicWithCornerRadius:(CGFloat)radius;
/**
Rounds a new image with a given corner size.

@param radius  The radius of each corner oval. Values larger than half the
rectangle's width or height are clamped appropriately to half
the width or height. [0, Min(width | height) / 2)
*/
- (nullable UIImage *)cc_imageByRoundCornerRadius:(CGFloat)radius;

/**
 Rounds a new image with a given corner size.
 
 @param radius       The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to
 half the width or height. [0, Min(width | height) / 2)
 
 @param borderWidth  The inset border line width. Values larger than half the rectangle's
 width or height are clamped appropriately to half the width
 or height.   [0, Min(width | height) / 2)
 
 @param borderColor  The border stroke color. nil means clear color.
 */
- (nullable UIImage *)cc_imageByRoundCornerRadius:(CGFloat)radius
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor;

/**
 Rounds a new image with a given corner size.
 
 @param radius       The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to
 half the width or height.  [0, Min(width | height) / 2)
 
 @param corners      A bitmask value that identifies the corners that you want
 rounded. You can use this parameter to round only a subset
 of the corners of the rectangle.
 
 @param borderWidth  The inset border line width. Values larger than half the rectangle's
 width or height are clamped appropriately to half the width
 or height.    ->     [0, Min(width | height) / 2)
 
 @param borderColor  The border stroke color. nil means clear color.
 
 @param borderLineJoin The border line join. For example,    kCGLineJoinMiter,kCGLineJoinRound,kCGLineJoinBevel
 */
- (nullable UIImage *)cc_imageByRoundCornerRadius:(CGFloat)radius
                                          corners:(UIRectCorner)corners
                                      borderWidth:(CGFloat)borderWidth
                                      borderColor:(nullable UIColor *)borderColor
                                   borderLineJoin:(CGLineJoin)borderLineJoin;



/**
 自定义图片切圆角算法,有毛边效果不是很好. (来源于 [一种高效裁剪圆角的算法](http://www.jianshu.com/p/bbb50b2cb7e6)
 )
 
 Rounds a new image with a given corner size.
 
 @param radius  The radius of each corner oval. Values larger than half the
 rectangle's width or height are clamped appropriately to half
 the width or height.
 
 */
-(nullable UIImage *)dealImageWithCornerRadius:(CGFloat)radius;


@end


