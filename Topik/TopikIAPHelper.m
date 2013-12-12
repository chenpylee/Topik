//
//  TopikIAPHelper.m
//  Topik
//
//  Created by Lee Haining on 13-12-12.
//  Copyright (c) 2013年 RotateMediaLabs. All rights reserved.
//

#import "TopikIAPHelper.h"
#import "AppConfig.h"
@implementation TopikIAPHelper
+ (TopikIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static TopikIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      kStoreProductIdentifier,
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
