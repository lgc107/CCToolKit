//
//  CCNumberKeyboard.h
//  CCNumberKeyboard
//
//  Created by Harry_L on 2018/6/30.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//! Project version number for CCNumberKeyboard.
FOUNDATION_EXPORT double CCNumberKeyboardVersionNumber;

//! Project version string for CCNumberKeyboard.
FOUNDATION_EXPORT const unsigned char CCNumberKeyboardVersionString[];

@class CCNumberKeyboard;

/**
 *  The @c CCNumberKeyboardDelegate protocol defines the messages sent to a delegate object as part of the sequence of editing text. All of the methods of this protocol are optional.
 */
@protocol CCNumberKeyboardDelegate <NSObject>
@optional

/**
 *  Asks whether the specified text should be inserted.
 *
 *  @param numberKeyboard The keyboard instance proposing the text insertion.
 *  @param text           The proposed text to be inserted.
 *
 *  @return Returns    @c YES if the text should be inserted or @c NO if it should not.
 */
- (BOOL)numberKeyboard:(CCNumberKeyboard *)numberKeyboard shouldInsertText:(NSString *)text;

/**
 *  Asks the delegate if the keyboard should process the pressing of the return button.
 *
 *  @param numberKeyboard The keyboard whose return button was pressed.
 *
 *  @return Returns    @c YES if the keyboard should implement its default behavior for the return button; otherwise, @c NO.
 */
- (BOOL)numberKeyboardShouldReturn:(CCNumberKeyboard *)numberKeyboard;

/**
 *  Asks the delegate if the keyboard should remove the character just before the cursor.
 *
 *  @param numberKeyboard The keyboard whose return button was pressed.
 *
 *  @return Returns    @c YES if the keyboard should implement its default behavior for the delete backward button; otherwise, @c NO.
 */
- (BOOL)numberKeyboardShouldDeleteBackward:(CCNumberKeyboard *)numberKeyboard;

@end

/**
 *  Specifies the style for the keyboard.
 */
typedef NS_ENUM(NSUInteger, CCNumberKeyboardStyle) {
    /**
     *  An automatic style. It sets the appropiate style to match the appearance of the system keyboard, for example, using rounded buttons on an iPad.
     */
    CCNumberKeyboardStyleAutomatic,
    
    /**
     *  A plain buttons keyboard style. The buttons take the full width of the keyboard and are divided by inline separators. This style is not supported when the keyboard needs to be inset.
     */
    CCNumberKeyboardStylePlainButtons,
    
    /**
     *  A rounded buttons keyboard style. The buttons are displayed with a rounded style, and can be inset from the sides of the keyboard.
     */
    CCNumberKeyboardStyleRoundedButtons
};

/**
 *  Specifies the style of a keyboard button.
 */
typedef NS_ENUM(NSUInteger, CCNumberKeyboardButtonStyle) {
    /**
     *  A white style button, such as those for the number keys.
     */
    CCNumberKeyboardButtonStyleWhite,
    
    /**
     *  A gray style button, such as the backspace key.
     */
    CCNumberKeyboardButtonStyleGray,
    
    /**
     *  A done style button, for example, a button that completes some task and returns to the previous view.
     */
    CCNumberKeyboardButtonStyleDone
};

/**
 *  A simple keyboard to use with numbers and, optionally, a decimal point.
 */
@interface CCNumberKeyboard : UIInputView

/**
 *  Initializes and returns a number keyboard view using the specified style information and locale.
 *
 *  An initialized view object or @c nil if the view could not be initialized.
 *
 *  @param frame          The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it.
 *  @param inputViewStyle The style to use when altering the appearance of the view and its subviews. For a list of possible values, see @c UIInputViewStyle
 *  @param locale         An @c NSLocale object that specifies options (specifically the @c NSLocaleDecimalSeparator) used for the keyboard. Specify @c nil if you want to use the current locale.
 *
 *  @returns An initialized view object or @c nil if the view could not be initialized.
 */
- (instancetype)initWithFrame:(CGRect)frame inputViewStyle:(UIInputViewStyle)inputViewStyle locale:(nullable NSLocale *)locale;

/**
 *  The receiver key input object. If @c nil the object at top of the responder chain is used.
 */
@property (weak, nonatomic, nullable) id <UIKeyInput> keyInput;

/**
 *  Delegate to change text insertion or return key behavior.
 */
@property (weak, nonatomic, nullable) id <CCNumberKeyboardDelegate> delegate;

/**
 *  Configures the special key with an image and an action block.
 *
 *  @param image   The image to display in the key.
 *  @param handler A handler block.
 */
- (void)configureSpecialKeyWithImage:(UIImage *)image actionHandler:(nullable dispatch_block_t)handler;

/**
 *  Configures the special key with an image and a target-action.
 *
 *  @param image  The image to display in the key.
 *  @param target The target object—that is, the object to which the action message is sent.
 *  @param action A selector identifying an action message. It cannot be NULL.
 */
- (void)configureSpecialKeyWithImage:(UIImage *)image target:(id)target action:(SEL)action;

/**
 *  If @c YES, the decimal separator key will be displayed.
 *
 *  @note The default value of this property is @c true.
 */
@property (assign, nonatomic) BOOL allowsDecimalPoint;

/**
 *  If @c YES, the number key will be random.
 *
 *  @note The default value of this property is @c false.
 */
@property (assign, nonatomic) BOOL allowsRandomNumber;
/**
 *  The visible title of the Return key.
 *
 *  @note The default visible title of the Return key is “Done”.
 */
@property (copy, nonatomic, null_resettable) NSString *returnKeyTitle;

/**
 *  The visible title of the Return key.
 *
 *  @note The default visible title of the Return key is “Done”.
 */
@property (copy, nonatomic, null_resettable) NSString *decimalPointKeyTitle;

/**
 *  The preferred keyboard style.
 *
 *  @note The default style for the keyboard is @c CCNumberKeyboardStyleAutomatic.
 */
@property (assign, nonatomic) CCNumberKeyboardStyle preferredStyle;

/**
 *  The button style of the Return key.
 *
 *  @note The default value of this property is @c CCNumberKeyboardButtonStyleDone.
 */
@property (assign, nonatomic) CCNumberKeyboardButtonStyle returnKeyButtonStyle;

/**
 *  A value indicating whether the Return key is automatically enabled when the user is entering numbers.
 *
 *  @note The default value for this property is @c NO. If you set it to @c YES, the keyboard disables the Return key when the text entry area contains no text. As soon as the user enters some text, the Return key is automatically enabled.
 */
@property (assign, nonatomic) BOOL enablesReturnKeyAutomatically;

@end

NS_ASSUME_NONNULL_END
