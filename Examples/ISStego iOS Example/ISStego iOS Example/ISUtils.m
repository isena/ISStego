//
//  ISUtils.m
//  Example-ISStego
//
//  Created by Isaac Stevao Sena on 26/01/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import "ISUtils.h"

NSString *const STEGO_IMAGE_NAME = @"STEGO_IMAGE.png";

@implementation ISUtils

+ (void)showMessage:(NSString*)message {
  if (![NSThread isMainThread]) {
    [self performSelectorOnMainThread:@selector(showMessage:)
                           withObject:message
                        waitUntilDone:NO];
    return;
  }
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                      message:message
                                                     delegate:nil
                                            cancelButtonTitle:@"ok"
                                            otherButtonTitles:nil];
  [alertView show];
  alertView = nil;
}

@end
