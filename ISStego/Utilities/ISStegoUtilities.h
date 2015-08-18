//
//  ISStegoUtilities.h
//  ISStego
//
//  Created by Isaac Stevao Sena on 26/01/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef NS_ENUM(NSInteger, ISStegoErrorDomainCode) {
    ISStegoErrorDomainCodeNotDefined,
    ISStegoErrorDomainCodeDataTooBig,
    ISStegoErrorDomainCodeImageTooSmall,
    ISStegoErrorDomainCodeNoDataInImage
};

extern NSString *const ISStegoErrorDomain;

NSError *ErrorForDomainCode(ISStegoErrorDomainCode code);

BOOL Contains(NSString *string, NSString *substring);

NSString *Substring(NSString *string, NSString *prefix, NSString *suffix);

CGImageRef CGImageCreateWithImage(id image);

id Image(CGImageRef imageRef);
