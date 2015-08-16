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

- (IBAction)loadImage:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
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

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRanges:(NSArray *)affectedRanges replacementStrings:(NSArray *)replacementStrings {
    self.buttonEncode.enabled = (self.buttonImage.transparent) ? YES : NO;
    return YES;
}

- (IBAction)encode:(id)sender {
    NSImage *image = self.imageView.image;
    
    [ISSteganographer hideData:self.textView.string
                     withImage:image
               completionBlock:^(id image, NSError *error) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [self saveImage:image];
                   });
               }];
}

- (void)saveImage:(NSImage *)image {
    NSSavePanel *panel = [NSSavePanel savePanel];
    
    [panel setNameFieldStringValue:@"image.png"];
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            [self saveImage:image
                       file:panel.URL.path];
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
    
    NSData *pngData = [newRep representationUsingType:NSPNGFileType
                                           properties:nil];
    
    return [pngData writeToFile:path atomically:YES];
}

- (IBAction)decode:(id)sender {
    NSImage *image = self.imageView.image;
    
    [ISSteganographer dataFromImage:image
                    completionBlock:^(NSData *data, NSError *error) {
                        NSString *string = [[NSString alloc] initWithData:data
                                                                 encoding:NSUTF8StringEncoding];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.textView.string = string;
                        });
                    }];
}

@end
