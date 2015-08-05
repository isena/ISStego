//
//  ISStegoUtilities.h
//  ISStego
//
//  Created by Isaac Stevao Sena on 26/01/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ISStegoErrorDomainCode) {
    ISStegoErrorDomainCodeNotDefined,
    ISStegoErrorDomainCodeDataTooBig,
    ISStegoErrorDomainCodeImageTooSmall,
    ISStegoErrorDomainCodeNoDataInImage
};

extern NSString *const ISStegoErrorDomain;

@interface ISStegoUtilities : NSObject

NSError *errorForDomainCode(ISStegoErrorDomainCode code);

BOOL contains(NSString *string, NSString *substring);

NSString *substring(NSString *string, NSString *prefix, NSString *suffix);

@end
