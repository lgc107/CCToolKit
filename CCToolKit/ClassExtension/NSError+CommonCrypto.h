//
//  NSError+CommonCrypto.h
//  CCToolKit
//
//  Created by Harry_L on 2018/5/26.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
@interface NSError (CommonCrypto)

+ (NSError *) errorWithCCCryptorStatus: (CCCryptorStatus) status;

@end
