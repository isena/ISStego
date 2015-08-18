//
//  ExtractViewController.m
//  Example-ISStego
//
//  Created by Isaac Stevao Sena on 26/01/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import "ExtractViewController.h"
#import "ISUtils.h"
#import "ISSteganographer.h"

@interface ExtractViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ExtractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureStegoObject];
}

- (void)configureStegoObject {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:STEGO_IMAGE_NAME];
    
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    if (image) {
        self.imageView.image = image;
    } else {
        [ISUtils showMessage:@"No Stego-object!"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)extract {
    [ISSteganographer dataFromImage:self.imageView.image
                    completionBlock:^(NSData *data, NSError *error) {
                        if (error) {
                            [ISUtils showMessage:[NSString stringWithFormat:@"%@", error]];
                        } else {
                            [self showData:data];
                        }
                    }];
}

- (void)showData:(NSData *)data {
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    
    [ISUtils showMessage:string];
}

@end
