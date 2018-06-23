//
//  UIView+Extensions.h
//  CCToolKit
//
//  Created by Harry_L on 2018/6/23.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utilities)

@property (nonatomic,assign) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic,assign) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic,assign) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic,assign) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic,assign) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic,assign) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic,assign) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic,assign) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic,assign) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic,assign) CGSize  size;        ///< Shortcut for frame.size.
/**
 Returns the view's view controller (may be nil).
 */
@property (nullable, nonatomic, readonly) UIViewController *viewController;

/**
 Returns the visible alpha on screen, taking into account superview and window.
 */
@property (nonatomic, readonly) CGFloat visibleAlpha;

/**
 Shortcut to set the view.layer's shadow
 
 @param color  Shadow Color
 @param offset Shadow offset
 @param radius Shadow radius
 */
- (void)setLayerShadow:(nullable UIColor*)color offset:(CGSize)offset radius:(CGFloat)radius;
/**
 Remove all subviews.
 
 @warning Never call this method inside your view's drawRect: method.
 */
- (void)cc_removeAllSubviews;

/**
 Converts a point from the receiver's coordinate system to that of the specified view or window.
 
 @param point A point specified in the local coordinate system (bounds) of the receiver.
 @param view  The view or window into whose coordinate system point is to be converted.
 If view is nil, this method instead converts to window base coordinates.
 @return The point converted to the coordinate system of view.
 */
- (CGPoint)cc_convertPoint:(CGPoint)point toViewOrWindow:(nullable UIView *)view;

/**
 Converts a point from the coordinate system of a given view or window to that of the receiver.
 
 @param point A point specified in the local coordinate system (bounds) of view.
 @param view  The view or window with point in its coordinate system.
 If view is nil, this method instead converts from window base coordinates.
 @return The point converted to the local coordinate system (bounds) of the receiver.
 */
- (CGPoint)cc_convertPoint:(CGPoint)point fromViewOrWindow:(nullable UIView *)view;

/**
 Converts a rectangle from the receiver's coordinate system to that of another view or window.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of the receiver.
 @param view The view or window that is the target of the conversion operation. If view is nil, this method instead converts to window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)cc_convertRect:(CGRect)rect toViewOrWindow:(nullable UIView *)view;

/**
 Converts a rectangle from the coordinate system of another view or window to that of the receiver.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of view.
 @param view The view or window with rect in its coordinate system.
 If view is nil, this method instead converts from window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)cc_convertRect:(CGRect)rect fromViewOrWindow:(nullable UIView *)view;



@end

@interface UIView (Snapshot)

/**
 Create a snapshot image of the complete view hierarchy.
 */
- (nullable UIImage *)cc_snapshotImage;

/**
 Create a snapshot image of the complete view hierarchy.
 @discussion It's faster than "snapshotImage", but may cause screen updates.
 See -[UIView drawViewHierarchyInRect:afterScreenUpdates:] for more information.
 */
- (nullable UIImage *)cc_snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;

/**
 Create a snapshot PDF of the complete view hierarchy.
 */
- (nullable NSData *)cc_snapshotPDF;

@end


