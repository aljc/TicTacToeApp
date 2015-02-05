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
    
    [self.x setImage:[UIImage imageNamed:@"x"]];
    [self.o setImage:[UIImage imageNamed:@"o"]];
    
    //note: MUST do this programmatically!!! for some reason doesn't work when i add the pangesture in storyboard...
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];
    [self.x addGestureRecognizer:panGesture];
    [self.o addGestureRecognizer:panGesture];
    panGesture = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Source: http://www.raywenderlich.com/6567/uigesturerecognizer-tutorial-in-ios-5-pinches-pans-and-more
//make sure you checked "user interaction enabled" under ATTRIBUTES!!!!!
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender {
    NSLog(@"handlePan");
    
    CGPoint translation = [sender translationInView:self.view];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x,
                                         sender.view.center.y + translation.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
  }

- (bool)gameOver {
    //if 3 in a row, then game over
    return true;
}

@end
