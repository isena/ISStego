//
//  InsertViewController.m
//  Example-ISStego
//
//  Created by Isaac Stevao Sena on 26/01/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import "InsertViewController.h"
#import "ISUtils.h"
#import "ISSteganographer.h"

@interface InsertViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation InsertViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self showImagePickerViewController];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction)insert {
  NSString *password = @"password";
  
  NSInteger channelsToEncode = [ISSteganographer channelsRed:YES
                                                       green:YES
                                                        blue:YES
                                                       alpha:NO];
  
  [self.textField resignFirstResponder];
  if (self.imageView.image && [self.textField.text length] > 0) {
    [ISSteganographer hideData:self.textField.text
                         image:self.imageView.image
                      password:password
                      channels:channelsToEncode
               completionBlock:^(UIImage *image, NSDictionary *info, NSError *error) {
                 if (error) {
                   [ISUtils showMessage:[NSString stringWithFormat:@"%@", error]];
                 } else {
                   [self saveImage:image];
                 }
               }];
  } else {
    [ISUtils showMessage:@"No image/text..."];
  }
}

- (void)saveImage:(UIImage *)image {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:STEGO_IMAGE_NAME];
  if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
    [ISUtils showMessage:@"your secret have been hidden with success!"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.navigationController popToRootViewControllerAnimated:YES];
    });
  } else {
    [ISUtils showMessage:@"Error on saving Stego-object"];
  }
}

#pragma mark - ImagePickerViewController

- (void)showImagePickerViewController {
  UIImagePickerController *viewController = [[UIImagePickerController alloc] init];
  viewController.delegate = self;
  [self presentViewController:viewController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  if(!image) image = [info objectForKey:UIImagePickerControllerOriginalImage];
  
  if (image) {
    self.imageView.image = image;
  }
  
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
