//
//  WKWebView+Extensions.h
//  CCToolKit
//
//  Created by Harry_L on 2018/6/30.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (Extensions)

/**
 whether hide InputAccessoryView
 */
@property (nonatomic, assign) BOOL hackishlyHidesInputAccessoryView;


/**
 updateWebViewCookie
 */
- (void)updateWebViewCookie;

@end
