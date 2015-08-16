//
//  ISStegoUtilities.m
//  ISStego
//
//  Created by Isaac Stevao Sena on 26/01/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import "ISStegoUtilities.h"
#import "ISStegoDefaults.h"
#import <TargetConditionals.h>

#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>
#else
    #import <AppKit/AppKit.h>
#endif

NSString *const ISStegoErrorDomain = @"ISStegoErrorDomain";

BOOL Contains(NSString *string, NSString *substring) {
    if(string
       && substring
       && !([string rangeOfString:substring
                          options:NSCaseInsensitiveSearch].length == 0)) {
        return YES;
    }
    
    return NO;
}

NSString *Substring(NSString *string, NSString *prefix, NSString *suffix) {
    NSString *substring = nil;
    
    if (string) {
        NSRange prefixRange = [string rangeOfString:prefix];
        
        if (prefixRange.location != NSNotFound) {
            NSRange suffixRange = [string rangeOfString:suffix];
            
            if (suffixRange.location != NSNotFound) {
                NSRange range = NSMakeRange(prefixRange.location + prefixRange.length, suffixRange.location - prefixRange.location - prefixRange.length);
                if (range.location != NSNotFound) {
                    substring = [string substringWithRange:range];
                }
            }
        }
    }
    
    return substring;
}

NSError *ErrorForDomainCode(ISStegoErrorDomainCode code) {
    NSString *description = @"not defined";
    
    switch (code) {
        case ISStegoErrorDomainCodeDataTooBig:
            description = [NSString stringWithFormat:@"The data is too big"];
            break;
            
        case ISStegoErrorDomainCodeImageTooSmall:
            description = [NSString stringWithFormat:@"Image is too small: must have at least %d pixels", MinPixels()];
            break;
            
        case ISStegoErrorDomainCodeNoDataInImage:
            description = @"There is no data in image";
        
        default:
            break;
    }
    
    NSError *error = [NSError errorWithDomain:ISStegoErrorDomain
                                         code:code
                                     userInfo:@{NSLocalizedDescriptionKey : description}];
    
    return error;
}

CGImageRef CGImageCreateWithImage(id image) {
    CGImageRef imageRef = nil;
    
#if TARGET_OS_IPHONE
    NSCAssert([image isKindOfClass:UIImage.class], @"image must be kind of UIImage");
    imageRef = (CGImageRef)CFRetain([image CGImage]);
#else
    NSCAssert([image isKindOfClass:NSImage.class], @"image must be kind of NSImage");
    NSData *data = [image TIFFRepresentation];
    CFDataRef dataRef = (CFDataRef)CFBridgingRetain(data);
    CGImageSourceRef source = CGImageSourceCreateWithData(dataRef, NULL);
    imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
    CFRelease(dataRef);
    CFRelease(source);
#endif
    
    return imageRef;
}

id Image(CGImageRef imageRef) {
    id image = nil;
#if TARGET_OS_IPHONE
    image = [UIImage imageWithCGImage:imageRef];
#else
    image = [[NSImage alloc] initWithCGImage:imageRef
                                        size:NSZeroSize];
#endif
    return image;
}

