//
//  ViewController.m
//  TestStego
//
//  Created by Isaac Stevao Sena on 08/08/15.
//  Copyright (c) 2015 Black Bean. All rights reserved.
//

#import "ViewController.h"
#import "ISSteganographer.h"

@interface ViewController () <NSTextViewDelegate>

@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSButton *buttonEncode;
@property (weak) IBOutlet NSButton *buttonDecode;
@property (weak) IBOutlet NSButton *buttonImage;
@property (unsafe_unretained) IBOutlet NSTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];
}

#pragma mark - TextView delegate

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRanges:(NSArray *)affectedRanges replacementStrings:(NSArray *)replacementStrings {
  self.buttonEncode.enabled = (self.buttonImage.transparent) ? YES : NO;
  return YES;
}

#pragma mark - IBActions

- (IBAction)loadImage:(id)sender {
  NSOpenPanel *panel = [NSOpenPanel openPanel];
  [panel setAllowedFileTypes:@[@"jpg", @"png", @"bmp"]];
  
  [panel beginWithCompletionHandler:^(NSInteger result){
    if (result == NSFileHandlingPanelOKButton) {
      self.imageView.image = [[NSImage alloc] initWithContentsOfURL:panel.URL];
      self.buttonImage.transparent = YES;
      
      if (self.textView.string.length > 0) {
        self.buttonEncode.enabled = YES;
      }
      
      self.buttonDecode.enabled = YES;
    }
  }];
}

- (IBAction)encode:(id)sender {
  NSString *password = @"password";
  
  NSInteger channelsToEncode = [ISSteganographer channelsRed:YES
                                                       green:YES
                                                        blue:YES
                                                       alpha:NO];
  
  NSImage *image = self.imageView.image;
  
  [ISSteganographer hideData:self.textView.string
                       image:image
                    password:password
                    channels:channelsToEncode
             completionBlock:^(id image, NSDictionary *info, NSError *error) {
               if (error) {
                 NSLog(@"error: %@", error);
               } else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                   [self saveImage:image];
                 });
               }
             }];
}

- (IBAction)decode:(id)sender {
  NSString *password = @"password";
  
  NSImage *image = self.imageView.image;
  
  [ISSteganographer dataFromImage:image
                         password:password
                  completionBlock:^(NSData *data, NSError *error) {
                    if (error) {
                      NSLog(@"error: %@", error);
                    } else {
                      NSString *string = [[NSString alloc] initWithData:data
                                                               encoding:NSUTF8StringEncoding];
                      dispatch_async(dispatch_get_main_queue(), ^{
                        self.textView.string = string;
                      });
                    }
                  }];
}

#pragma mark - Saving image

- (void)saveImage:(NSImage *)image {
  NSSavePanel *panel = [NSSavePanel savePanel];
  
  [panel setNameFieldStringValue:@"STEGO_IMAGE.png"];
  
  [panel beginWithCompletionHandler:^(NSInteger result) {
    if (result == NSFileHandlingPanelOKButton) {
      [self saveImage:image
                 file:panel.URL.path];
      self.imageView.image = nil;
      self.buttonImage.transparent = NO;
      self.buttonEncode.enabled = NO;
      self.buttonDecode.enabled = NO;
      [self.textView setString:@""];
    }
  }];
}

- (BOOL)saveImage:(id)image
             file:(NSString *)path {
  CGImageRef cgRef = [image CGImageForProposedRect:NULL
                                           context:nil
                                             hints:nil];
  
  NSBitmapImageRep *newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
  
  [newRep setSize:[image size]];
  
  NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey:NSImageCompressionFactor];
  
  NSData *pngData = [newRep representationUsingType:NSPNGFileType
                                         properties:imageProps];
  
  return [pngData writeToFile:path atomically:YES];
}

@end
