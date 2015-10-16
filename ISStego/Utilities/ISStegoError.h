//
//  ISStegoError.h
//  ISSteganography
//
//  Created by Isaac Stevao Sena on 27/09/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ISStegoErrorDomainCode) {
  ISStegoErrorDomainCodeNotDefined,
  ISStegoErrorDomainCodeNullParameter,
  ISStegoErrorDomainCodeNullMemoryNotAllocated,
  ISStegoErrorDomainCodeWrongParameterKind,
  ISStegoErrorDomainCodeImageTooSmall,
  ISStegoErrorDomainCodeNumberOfChannelsTooSmall,
  ISStegoErrorDomainCodeNoDataInImage
};

extern NSString *const ISStegoErrorDomain;

void ISErrorForDomainCode(ISStegoErrorDomainCode code, NSError **error);
