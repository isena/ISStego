//
//  ViewController.m
//  Example-ISStego
//
//  Created by Isaac Stevao Sena on 1/18/15.
//  Copyright (c) 2015 iSena. All rights reserved.
//

#import "ViewController.h"
#import "ISUtils.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonExtract;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.buttonExtract setEnabled:[self hasStegoObject]];
}

- (BOOL)hasStegoObject {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:STEGO_IMAGE_NAME];
  
  UIImage *image = [UIImage imageWithContentsOfFile:filePath];
  
  return image ? YES : NO;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
