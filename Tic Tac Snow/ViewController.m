//
//  ViewController.m
//  Tic Tac Snow
//
//  Created by ajchang on 2/4/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.gridView.contentMode = UIViewContentModeScaleAspectFit;
    [self.gridView setImage:[UIImage imageNamed:@"grid"]];
    
    self.imageArray = [[NSMutableArray alloc] initWithCapacity:9];
    
    //build array of imageviews for the grid spaces
    int i;
    for (i=0; i < 9; i++) {
        UIView *space = [[UIView alloc] init];
        [self.imageArray addObject:space];
    }
    
    UIImageView imageView = [[UIImageView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
