//
//  ISStegoError.m
//  ISSteganography
//
//  Created by Isaac Stevao Sena on 27/09/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import "ISStegoError.h"

NSString *const ISStegoErrorDomain = @"ISStegoErrorDomain";

void ISErrorForDomainCode(ISStegoErrorDomainCode code, NSError **error) {
  NSString *description = @"not defined";
  
  switch (code) {
    case ISStegoErrorDomainCodeImageTooSmall:
      description = [NSString stringWithFormat:@"Image is too small"];
      break;
      
    case ISStegoErrorDomainCodeNumberOfChannelsTooSmall:
      description = [NSString stringWithFormat:@"Number of channels (ARGB) chosen is too small"];
      break;
      
    case ISStegoErrorDomainCodeWrongParameterKind:
      description = [NSString stringWithFormat:@"Wrong kind of parameter."];
      break;
      
    case ISStegoErrorDomainCodeNullParameter:
      description = [NSString stringWithFormat:@"Parameter must not be null."];
      break;
      
    case ISStegoErrorDomainCodeNullMemoryNotAllocated:
      description = [NSString stringWithFormat:@"Memory not allocated."];
      break;
      
    case ISStegoErrorDomainCodeNoDataInImage:
      description = @"There is no data in image";
      break;
      
    default:
      break;
  }
  
  if (error) {
    *error = [NSError errorWithDomain:ISStegoErrorDomain
                                 code:code
                             userInfo:@{NSLocalizedDescriptionKey : description}];
  }
}
