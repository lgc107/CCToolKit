//
//  CCXMLDictionaryParser.h
//  CCToolKit
//
//  Created by Harry_L on 2018/6/17.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCXMLDictionaryParser : NSObject

@property (nonatomic,strong) NSMutableDictionary *root;



- (instancetype)initWithData:(NSData *)data;

- (instancetype)initWithString:(NSString *)xml;
@end
