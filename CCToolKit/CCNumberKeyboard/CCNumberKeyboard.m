//
//  CCNumberKeyboard.m
//  CCNumberKeyboard
//
//  Created by Harry_L on 2018/6/30.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import "CCNumberKeyboard.h"
#import "CCKeyboardButton.h"
#import "CCTextInputDelegateProxy.h"

typedef NS_ENUM(NSUInteger, CCNumberKeyboardButton) {
    CCNumberKeyboardButtonNumberMin,
    CCNumberKeyboardButtonNumberMax = CCNumberKeyboardButtonNumberMin + 10, // Ten digits.
    CCNumberKeyboardButtonBackspace,
    CCNumberKeyboardButtonDone,
    CCNumberKeyboardButtonSpecial,
    CCNumberKeyboardButtonDecimalPoint,
    CCNumberKeyboardButtonNone = NSNotFound,
};

@interface CCNumberKeyboard () <UIInputViewAudioFeedback, UITextInputDelegate>

@property (strong, nonatomic) NSDictionary *buttonDictionary;
@property (strong, nonatomic) NSMutableArray *separatorViews;
@property (strong, nonatomic) NSLocale *locale;
@property (strong, nonatomic) CCTextInputDelegateProxy *keyInputProxy;

@property (copy, nonatomic) dispatch_block_t specialKeyHandler;

@end

static __weak id currentFirstResponder;

@implementation UIResponder (FirstResponder)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-repeated-use-of-weak"
+ (id)CC_currentFirstResponder
{
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(CC_findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}
#pragma clang diagnostic pop

- (void)CC_findFirstResponder:(id)sender
{
    currentFirstResponder = self;
}

@end

@implementation CCNumberKeyboard

static const NSInteger CCNumberKeyboardRows = 4;
static const CGFloat CCNumberKeyboardRowHeight = 55.0f;
static const CGFloat CCNumberKeyboardPadBorder = 7.0f;
static const CGFloat CCNumberKeyboardPadSpacing = 8.0f;

#define UIKitLocalizedString(key) [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] localizedStringForKey:key value:@"" table:nil]

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame inputViewStyle:UIInputViewStyleKeyboard];
    if (self) {
        [self _coCConInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame inputViewStyle:(UIInputViewStyle)inputViewStyle
{
    self = [super initWithFrame:frame inputViewStyle:inputViewStyle];
    if (self) {
        [self _coCConInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame inputViewStyle:(UIInputViewStyle)inputViewStyle locale:(NSLocale *)locale
{
    self = [super initWithFrame:frame inputViewStyle:inputViewStyle];
    if (self) {
        self.locale = locale;
        [self _coCConInit];
    }
    return self;
}

- (void)_coCConInit
{
    // Configure buttons.
    [self _configureButtonsForCurrentStyle];
    
    // Initialize an array for the separators.
    self.separatorViews = [NSMutableArray array];
    
    // Add default action.
    UIImage *dismissImage = [self.class _keyboardImageNamed:@"CCNumberKeyboardDismissKey.png"];
    
    [self configureSpecialKeyWithImage:dismissImage target:self action:@selector(_dismissKeyboard:)];
    
    // Add default return key title.
    [self setReturnKeyTitle:nil];
    
    // Add default return key style.
    [self setReturnKeyButtonStyle:CCNumberKeyboardButtonStyleDone];
    
    [self setAllowsRandomNumber:false];
    
    [self setAllowsDecimalPoint:true];
    // If an input view contains the .flexibleHeight option, the view will be sized as the default keyboard. This doesn't make much sense in the iPad, as we prefer a more compact keyboard.
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    } else {
        [self sizeToFit];
    }
}

- (void)_configureButtonsForCurrentStyle
{
    NSMutableDictionary *buttonDictionary = [NSMutableDictionary dictionary];
    
    const NSInteger numberMin = CCNumberKeyboardButtonNumberMin;
    const NSInteger numberMax = CCNumberKeyboardButtonNumberMax;
    
    const CGFloat buttonFontPointSize = 28.0f;
    UIFont *buttonFont = ({
        UIFont *font = nil;
#if defined(__has_attribute) && __has_attribute(availability)
        if (@available(iOS 8.2, *)) {
            font = [UIFont systemFontOfSize:buttonFontPointSize weight:UIFontWeightLight];
        }
#else
        if ([UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
            font = [UIFont systemFontOfSize:buttonFontPointSize weight:UIFontWeightLight];
        }
#endif
        font ?: [UIFont fontWithName:@"HelveticaNeue-Light" size:buttonFontPointSize];
    });
    
    UIFont *doneButtonFont = [UIFont systemFontOfSize:17.0f];
    
    for (CCNumberKeyboardButton key = numberMin; key < numberMax; key++) {
        UIButton *button = [CCKeyboardButton keyboardButtonWithStyle:CCNumberKeyboardButtonStyleWhite];
        NSString *title = @(key - numberMin).stringValue;
        
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:buttonFont];
        
        [buttonDictionary setObject:button forKey:@(key)];
    }
    
    UIImage *backspaceImage = [self.class _keyboardImageNamed:@"CCNumberKeyboardDeleteKey.png"];
    
    UIButton *backspaceButton = [CCKeyboardButton keyboardButtonWithStyle:CCNumberKeyboardButtonStyleGray];
    [backspaceButton setImage:[backspaceImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    [(CCKeyboardButton *)backspaceButton addTarget:self action:@selector(_backspaceRepeat:) forContinuousPressWithTimeInterval:0.15f];
    
    [buttonDictionary setObject:backspaceButton forKey:@(CCNumberKeyboardButtonBackspace)];
    
    UIButton *specialButton = [CCKeyboardButton keyboardButtonWithStyle:CCNumberKeyboardButtonStyleGray];
    
    [buttonDictionary setObject:specialButton forKey:@(CCNumberKeyboardButtonSpecial)];
    
    UIButton *doneButton = [CCKeyboardButton keyboardButtonWithStyle:CCNumberKeyboardButtonStyleDone];
    [doneButton.titleLabel setFont:doneButtonFont];
    [doneButton setTitle:UIKitLocalizedString(@"Done") forState:UIControlStateNormal];
    
    [buttonDictionary setObject:doneButton forKey:@(CCNumberKeyboardButtonDone)];
    
    UIButton *decimalPointButton = [CCKeyboardButton keyboardButtonWithStyle:CCNumberKeyboardButtonStyleWhite];
    [decimalPointButton setTitle:@"X" forState:UIControlStateNormal];
    
    [buttonDictionary setObject:decimalPointButton forKey:@(CCNumberKeyboardButtonDecimalPoint)];
    
    for (UIButton *button in buttonDictionary.objectEnumerator) {
        [button setExclusiveTouch:YES];
        [button addTarget:self action:@selector(_buttonInput:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(_buttonPlayClick:) forControlEvents:UIControlEventTouchDown];
        
        [self addSubview:button];
    }
    
    UIPanGestureRecognizer *highlightGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleHighlightGestureRecognizer:)];
    [self addGestureRecognizer:highlightGestureRecognizer];
    
    if (self.buttonDictionary) {
        [self.buttonDictionary.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    self.buttonDictionary = buttonDictionary;
}

- (void)_configureButtonsForKeyInputState
{
    const BOOL hasText = self.keyInput.hasText;
    const BOOL enablesReturnKeyAutomatically = self.enablesReturnKeyAutomatically;
    
    CCKeyboardButton *button = self.buttonDictionary[@(CCNumberKeyboardButtonDone)];
    if (button) {
        button.enabled = (!enablesReturnKeyAutomatically) || (enablesReturnKeyAutomatically && hasText);
    }
}

#pragma mark - Input.

- (void)_handleHighlightGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged || gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        for (UIButton *button in self.buttonDictionary.objectEnumerator) {
            BOOL points = CGRectContainsPoint(button.frame, point) && !button.isHidden;
            
            if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
                [button setHighlighted:points];
            } else {
                [button setHighlighted:NO];
            }
            
            if (gestureRecognizer.state == UIGestureRecognizerStateEnded && points) {
                [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

- (void)_buttonPlayClick:(UIButton *)button
{
    [[UIDevice currentDevice] playInputClick];
}

- (void)_buttonInput:(UIButton *)button
{
    __block CCNumberKeyboardButton keyboardButton = CCNumberKeyboardButtonNone;
    
    [self.buttonDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        CCNumberKeyboardButton k = [key unsignedIntegerValue];
        if (button == obj) {
            keyboardButton = k;
            *stop = YES;
        }
    }];
    
    if (keyboardButton == CCNumberKeyboardButtonNone) {
        return;
    }
    
    // Get first responder.
    id <UIKeyInput> keyInput = self.keyInput;
    id <CCNumberKeyboardDelegate> delegate = self.delegate;
    
    if (!keyInput) {
        return;
    }
    
    // Handle number.
    const NSInteger numberMin = CCNumberKeyboardButtonNumberMin;
    const NSInteger numberMax = CCNumberKeyboardButtonNumberMax;
    
    if (keyboardButton >= numberMin && keyboardButton < numberMax) {
        NSNumber *number = @(keyboardButton - numberMin);
        NSString *string = number.stringValue;
        
        if ([delegate respondsToSelector:@selector(numberKeyboard:shouldInsertText:)]) {
            BOOL shouldInsert = [delegate numberKeyboard:self shouldInsertText:string];
            if (!shouldInsert) {
                return;
            }
        }
        
        [keyInput insertText:string];
    }
    
    // Handle backspace.
    else if (keyboardButton == CCNumberKeyboardButtonBackspace) {
        BOOL shouldDeleteBackward = YES;
        
        if ([delegate respondsToSelector:@selector(numberKeyboardShouldDeleteBackward:)]) {
            shouldDeleteBackward = [delegate numberKeyboardShouldDeleteBackward:self];
        }
        
        if (shouldDeleteBackward) {
            [keyInput deleteBackward];
        }
    }
    
    // Handle done.
    else if (keyboardButton == CCNumberKeyboardButtonDone) {
        BOOL shouldReturn = YES;
        
        if ([delegate respondsToSelector:@selector(numberKeyboardShouldReturn:)]) {
            shouldReturn = [delegate numberKeyboardShouldReturn:self];
        }
        
        if (shouldReturn) {
            [self _dismissKeyboard:button];
        }
    }
    
    // Handle special key.
    else if (keyboardButton == CCNumberKeyboardButtonSpecial) {
        dispatch_block_t handler = self.specialKeyHandler;
        if (handler) {
            handler();
        }
    }
    
    // Handle .
    else if (keyboardButton == CCNumberKeyboardButtonDecimalPoint) {
        NSString *decimalText = [button titleForState:UIControlStateNormal];
        if ([delegate respondsToSelector:@selector(numberKeyboard:shouldInsertText:)]) {
            BOOL shouldInsert = [delegate numberKeyboard:self shouldInsertText:decimalText];
            if (!shouldInsert) {
                return;
            }
        }
        
        [keyInput insertText:decimalText];
    }
    
    [self _configureButtonsForKeyInputState];
}

- (void)_backspaceRepeat:(UIButton *)button
{
    id <UIKeyInput> keyInput = self.keyInput;
    
    if (![keyInput hasText]) {
        return;
    }
    
    [self _buttonPlayClick:button];
    [self _buttonInput:button];
}

- (id<UIKeyInput>)keyInput
{
    id <UIKeyInput> keyInput = _keyInput;
    
    if (!keyInput) {
        keyInput = [UIResponder CC_currentFirstResponder];
        
        if (![keyInput conformsToProtocol:@protocol(UIKeyInput)]) {
            NSLog(@"Warning: First responder %@ does not conform to the UIKeyInput protocol.", keyInput);
            keyInput = nil;
        }
    }
    
    CCTextInputDelegateProxy *keyInputProxy = _keyInputProxy;
    
    if (keyInput != _keyInput) {
        if ([_keyInput conformsToProtocol:@protocol(UITextInput)]) {
            [(id <UITextInput>)_keyInput setInputDelegate:keyInputProxy.previousTextInputDelegate];
        }
        
        if ([keyInput conformsToProtocol:@protocol(UITextInput)]) {
            keyInputProxy = [CCTextInputDelegateProxy proxyForTextInput:(id <UITextInput>)keyInput delegate:self];
            [(id <UITextInput>)keyInput setInputDelegate:(id)keyInputProxy];
        } else {
            keyInputProxy = nil;
        }
    }
    
    _keyInput = keyInput;
    _keyInputProxy = keyInputProxy;
    
    return keyInput;
}

#pragma mark - <UITextInputDelegate>

- (void)selectionWillChange:(id <UITextInput>)textInput
{
    // Intentionally left unimplemented in conformance with <UITextInputDelegate>.
}

- (void)selectionDidChange:(id <UITextInput>)textInput
{
    // Intentionally left unimplemented in conformance with <UITextInputDelegate>.
}

- (void)textWillChange:(id <UITextInput>)textInput
{
    // Intentionally left unimplemented in conformance with <UITextInputDelegate>.
}

- (void)textDidChange:(id <UITextInput>)textInput
{
    [self _configureButtonsForKeyInputState];
}

#pragma mark - Key input lookup.

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    [self _configureButtonsForKeyInputState];
}

#pragma mark - Default special action.

- (void)_dismissKeyboard:(id)sender
{
    id <UIKeyInput> keyInput = self.keyInput;
    
    if ([keyInput isKindOfClass:[UIResponder class]]) {
        [(UIResponder *)keyInput resignFirstResponder];
    }
}

#pragma mark - Public.

- (void)configureSpecialKeyWithImage:(UIImage *)image actionHandler:(dispatch_block_t)handler
{
    if (image) {
        self.specialKeyHandler = handler;
    } else {
        self.specialKeyHandler = NULL;
    }
    
    UIButton *button = self.buttonDictionary[@(CCNumberKeyboardButtonSpecial)];
    [button setImage:image forState:UIControlStateNormal];
}

- (void)configureSpecialKeyWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    __weak typeof(self)weakTarget = target;
    __weak typeof(self)weakSelf = self;
    
    [self configureSpecialKeyWithImage:image actionHandler:^{
        __strong __typeof(&*weakTarget)strongTarget = weakTarget;
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        
        if (strongTarget) {
            NSMethodSignature *methodSignature = [strongTarget methodSignatureForSelector:action];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            [invocation setSelector:action];
            if (methodSignature.numberOfArguments > 2) {
                [invocation setArgument:&strongSelf atIndex:2];
            }
            [invocation invokeWithTarget:strongTarget];
        }
    }];
}

- (void)setAllowsDecimalPoint:(BOOL)allowsDecimalPoint
{
    if (allowsDecimalPoint != _allowsDecimalPoint) {
        _allowsDecimalPoint = allowsDecimalPoint;
        
        [self setNeedsLayout];
    }
}

- (void)setAllowsRandomNumber:(BOOL)allowsRandomNumber{
    if (allowsRandomNumber != _allowsRandomNumber) {
        _allowsRandomNumber = allowsRandomNumber;
        
        [self setNeedsLayout];
    }
}
- (void)setReturnKeyTitle:(NSString *)title
{
    if (!title) {
        title = [self defaultReturnKeyTitle];
    }
    
    if (![title isEqualToString:self.returnKeyTitle]) {
        UIButton *button = self.buttonDictionary[@(CCNumberKeyboardButtonDone)];
        if (button) {
            NSString *returnKeyTitle = (title != nil && title.length > 0) ? title : [self defaultReturnKeyTitle];
            [button setTitle:returnKeyTitle forState:UIControlStateNormal];
        }
    }
}

- (void)setDecimalPointKeyTitle:(NSString *)decimalPointKeyTitle
{
    if (!decimalPointKeyTitle) {
        decimalPointKeyTitle = @"X";
    }
    
    if (![decimalPointKeyTitle isEqualToString:self.decimalPointKeyTitle]) {
        UIButton *button = self.buttonDictionary[@(CCNumberKeyboardButtonDecimalPoint)];
        if (button) {
            NSString *decimalPointKeyTitle1 = (decimalPointKeyTitle != nil && decimalPointKeyTitle.length > 0) ? decimalPointKeyTitle : @"X";
            [button setTitle:decimalPointKeyTitle1 forState:UIControlStateNormal];
        }
    }
}

- (NSString *)decimalPointKeyTitle
{
    UIButton *button = self.buttonDictionary[@(CCNumberKeyboardButtonDone)];
    if (button) {
        NSString *title = [button titleForState:UIControlStateNormal];
        if (title != nil && title.length > 0) {
            return title;
        }
    }
    return @"X";
}

- (NSString *)returnKeyTitle
{
    UIButton *button = self.buttonDictionary[@(CCNumberKeyboardButtonDone)];
    if (button) {
        NSString *title = [button titleForState:UIControlStateNormal];
        if (title != nil && title.length > 0) {
            return title;
        }
    }
    return [self defaultReturnKeyTitle];
}

- (NSString *)defaultReturnKeyTitle
{
    return UIKitLocalizedString(@"Done");
}

- (void)setReturnKeyButtonStyle:(CCNumberKeyboardButtonStyle)style
{
    if (style != _returnKeyButtonStyle) {
        _returnKeyButtonStyle = style;
        
        CCKeyboardButton *button = self.buttonDictionary[@(CCNumberKeyboardButtonDone)];
        if (button) {
            button.style = style;
        }
    }
}

- (void)setEnablesReturnKeyAutomatically:(BOOL)enablesReturnKeyAutomatically
{
    if (enablesReturnKeyAutomatically != _enablesReturnKeyAutomatically) {
        _enablesReturnKeyAutomatically = enablesReturnKeyAutomatically;
        
        [self _configureButtonsForKeyInputState];
    }
}

- (void)setPreferredStyle:(CCNumberKeyboardStyle)style
{
    if (style != _preferredStyle) {
        _preferredStyle = style;
        
        [self setNeedsLayout];
    }
}

#pragma mark - Layout.

NS_INLINE CGRect CCButtonRectMake(CGRect rect, CGRect contentRect, BOOL usesRoundedCorners){
    rect = CGRectOffset(rect, contentRect.origin.x, contentRect.origin.y);
    
    if (usesRoundedCorners) {
        CGFloat inset = CCNumberKeyboardPadSpacing / 2.0f;
        rect = CGRectInset(rect, inset, inset);
    }
    
    return rect;
};

#if CGFLOAT_IS_DOUBLE
#define CCRound round
#else
#define CCRound roundf
#endif

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = (CGRect){
        .size = self.bounds.size
    };
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
    if (@available(iOS 11.0, *)) {
        insets = self.safeAreaInsets;
    }
#endif
    
    NSDictionary *buttonDictionary = self.buttonDictionary;
    NSMutableArray *separatorViews = self.separatorViews;
    
    // Settings.
    BOOL usesRoundedButtons = NO;
    
    if ([UITraitCollection class]) {
        const BOOL hasMargins = !UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsetsZero);
        const BOOL isIdiomPad = (self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad);
        const BOOL systemKeyboardUsesRoundedButtons = self._systemUsesRoundedRectButtonsOnAllInterfaceIdioms;
        
        if (hasMargins || isIdiomPad) {
            usesRoundedButtons = YES;
        } else {
            const BOOL prefersPlainButtons = (self.preferredStyle == CCNumberKeyboardStylePlainButtons);
            const BOOL prefersRoundedButtons = (self.preferredStyle == CCNumberKeyboardStyleRoundedButtons);
            
            if (!prefersPlainButtons) {
                usesRoundedButtons = systemKeyboardUsesRoundedButtons || prefersRoundedButtons;
            }
        }
    } else {
        usesRoundedButtons = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    }
    
    const CGFloat spacing = (usesRoundedButtons) ? CCNumberKeyboardPadBorder : 0.0f;
    const CGFloat maximumWidth = (usesRoundedButtons) ? 400.0f : CGRectGetWidth(bounds);
    const BOOL allowsDecimalPoint = self.allowsDecimalPoint;
    const BOOL allowsRandomNumber = self.allowsRandomNumber;
    const CGFloat width = MIN(maximumWidth, CGRectGetWidth(bounds) - (spacing * 2.0f));
    
    CGRect contentRect = (CGRect){
        .origin.x = CCRound((CGRectGetWidth(bounds) - width) / 2.0f),
        .origin.y = spacing,
        .size.width = width,
        .size.height = CGRectGetHeight(bounds) - (spacing * 2.0f)
    };
    
    contentRect = UIEdgeInsetsInsetRect(contentRect, insets);
    
    // Layout.
    const CGFloat columnWidth = CGRectGetWidth(contentRect) / 4.0f;
    const CGFloat rowHeight = CGRectGetHeight(contentRect) / CCNumberKeyboardRows;
    
    CGSize numberSize = CGSizeMake(columnWidth * 1.07, rowHeight);
    
    // Layout numbers.
    const NSInteger numberMin = CCNumberKeyboardButtonNumberMin;
    const NSInteger numberMax = CCNumberKeyboardButtonNumberMax;
    
    const NSInteger numbersPerLine = 3;
    if (allowsRandomNumber) {
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        while (titleArray.count<10) {
            NSInteger titlerNum = arc4random()%10;
            NSNumber *title = [NSNumber numberWithInteger:titlerNum];
            if (![titleArray containsObject:title]) {
                [titleArray addObject:title];
            }
        }
        for (int i = 0; i < 10; i++) {
            UIButton *button = buttonDictionary[titleArray[i]];
            
            
            CGRect rect = (CGRect){ .size = numberSize };
            
            if (i == 0) {
                rect.origin.y = numberSize.height * 3;
                rect.origin.x = numberSize.width;
                
                if (!allowsDecimalPoint) {
                    rect.origin.x = numberSize.width * 2.0;
                }
                
            } else {
                NSUInteger idx = (i - 1);
                
                NSInteger line = idx / numbersPerLine;
                NSInteger pos = idx % numbersPerLine;
                
                rect.origin.y = line * numberSize.height;
                rect.origin.x = pos * numberSize.width;
            }
            
            [button setFrame:CCButtonRectMake(rect, contentRect, usesRoundedButtons)];
        }
    }
    else{
        for (CCNumberKeyboardButton key = numberMin; key < numberMax; key++) {
            UIButton *button = buttonDictionary[@(key)];
            NSInteger digit = key - numberMin;
            
            CGRect rect = (CGRect){ .size = numberSize };
            
            if (digit == 0) {
                rect.origin.y = numberSize.height * 3;
                rect.origin.x = numberSize.width;
                
                if (!allowsDecimalPoint) {
                    rect.origin.x = numberSize.width * 2.0;
                }
                
            } else {
                NSUInteger idx = (digit - 1);
                
                NSInteger line = idx / numbersPerLine;
                NSInteger pos = idx % numbersPerLine;
                
                rect.origin.y = line * numberSize.height;
                rect.origin.x = pos * numberSize.width;
            }
            
            [button setFrame:CCButtonRectMake(rect, contentRect, usesRoundedButtons)];
        }
    }
    // Layout special key.
    UIButton *specialKey = buttonDictionary[@(CCNumberKeyboardButtonSpecial)];
    if (specialKey) {
        CGRect rect = (CGRect){ .size = numberSize };
        rect.origin.y = numberSize.height * 3;
        if (!allowsDecimalPoint) {
            rect.size.width = numberSize.width * 2;
        }
        [specialKey setFrame:CCButtonRectMake(rect, contentRect, usesRoundedButtons)];
    }
    
    // Layout decimal point.
    UIButton *decimalPointKey = buttonDictionary[@(CCNumberKeyboardButtonDecimalPoint)];
    if (decimalPointKey) {
        CGRect rect = (CGRect){ .size = numberSize };
        rect.origin.y = numberSize.height * 3;
        rect.origin.x = numberSize.width * 2;
        
        [decimalPointKey setFrame:CCButtonRectMake(rect, contentRect, usesRoundedButtons)];
        
        decimalPointKey.hidden = !allowsDecimalPoint;
    }
    
    // Layout utility column.
    const int utilityButtonKeys[2] = { CCNumberKeyboardButtonBackspace, CCNumberKeyboardButtonDone };
    const CGSize utilitySize = CGSizeMake(columnWidth * 0.79, rowHeight * 2.0f);
    
    for (NSInteger idx = 0; idx < sizeof(utilityButtonKeys) / sizeof(int); idx++) {
        CCNumberKeyboardButton key = utilityButtonKeys[idx];
        
        UIButton *button = buttonDictionary[@(key)];
        CGRect rect = (CGRect){ .size = utilitySize };
        
        rect.origin.x = columnWidth * 3.21f;
        rect.origin.y = idx * utilitySize.height;
        
        [button setFrame:CCButtonRectMake(rect, contentRect, usesRoundedButtons)];
    }
    
    // Layout separators:
    const BOOL usesSeparators = !usesRoundedButtons;
    
    if (usesSeparators) {
        const NSUInteger totalColumns = 4;
        const NSUInteger totalRows = numbersPerLine + 1;
        const NSUInteger numberOfSeparators = totalColumns + totalRows - 1;
        
        if (separatorViews.count != numberOfSeparators) {
            const NSUInteger delta = (numberOfSeparators - separatorViews.count);
            const BOOL removes = (separatorViews.count > numberOfSeparators);
            if (removes) {
                NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, delta)];
                [[separatorViews objectsAtIndexes:indexes] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [separatorViews removeObjectsAtIndexes:indexes];
            } else {
                NSUInteger separatorsToInsert = delta;
                while (separatorsToInsert--) {
                    UIView *separator = [[UIView alloc] initWithFrame:CGRectZero];
                    separator.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
                    
                    [self addSubview:separator];
                    [separatorViews addObject:separator];
                }
            }
        }
        
        const CGFloat separatorDimension = 1.0f / (self.window.screen.scale ?: 1.0f);
        
        [separatorViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *separator = obj;
            
            CGRect rect = CGRectZero;
            
            if (idx < totalRows) {
                rect.origin.y = idx * rowHeight;
                if (idx % 2) {
                    rect.size.width = CGRectGetWidth(contentRect) - columnWidth * 0.79;
                } else {
                    rect.size.width = CGRectGetWidth(contentRect);
                }
                rect.size.height = separatorDimension;
            } else {
                NSInteger col = (idx - totalRows);
                
                rect.origin.x = (col + 1) * columnWidth * 1.07;
                rect.size.width = separatorDimension;
                
                if (col == 1 && !allowsDecimalPoint) {
                    rect.size.height = CGRectGetHeight(contentRect) - rowHeight;
                } else {
                    rect.size.height = CGRectGetHeight(contentRect);
                }
            }
            
            [separator setFrame:CCButtonRectMake(rect, contentRect, usesRoundedButtons)];
        }];
    } else {
        [separatorViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [separatorViews removeAllObjects];
    }
    
    for (CCKeyboardButton *button in buttonDictionary.allValues) {
        button.usesRoundedCorners = usesRoundedButtons;
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    const UIUserInterfaceIdiom interfaceIdiom = UI_USER_INTERFACE_IDIOM();
    const CGFloat spacing = (interfaceIdiom == UIUserInterfaceIdiomPad) ? CCNumberKeyboardPadBorder : 0.0f;
    
    size.height = CCNumberKeyboardRowHeight * CCNumberKeyboardRows + (spacing * 2.0f);
    
    if (size.width == 0.0f) {
        size.width = [UIScreen mainScreen].bounds.size.width;
    }
    
    return size;
}

#pragma mark - Audio feedback.

- (BOOL)enableInputClicksWhenVisible
{
    return YES;
}

#pragma mark - Accessing keyboard images.

+ (UIImage *)_keyboardImageNamed:(NSString *)name
{
    NSString *resource = [name stringByDeletingPathExtension];
    NSString *extension = [name pathExtension];
    
    if (!resource.length) {
        return nil;
    }

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resourcePath = [bundle pathForResource:resource ofType:extension];

    if (resourcePath.length) {
        return [UIImage imageWithContentsOfFile:resourcePath];
    }

    return [UIImage imageNamed:resource];
}

#pragma mark - Matching the system's appearance.

- (BOOL)_systemUsesRoundedRectButtonsOnAllInterfaceIdioms
{
    static BOOL usesRoundedRectButtons;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        usesRoundedRectButtons = ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending);
    });
    return usesRoundedRectButtons;
}

@end
