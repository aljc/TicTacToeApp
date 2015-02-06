//
//  ViewController.m
//  Tic Tac Snow
//
//  Created by ajchang on 2/4/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property NSInteger currentPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageArray = [[NSMutableArray alloc] initWithCapacity:9];

    for (int i=0; i<9; i++) {
        [self.imageArray addObject:[self.view viewWithTag:i]];
    }
    
    //note: MUST do this programmatically!!! for some reason doesn't work when i add the pangesture in storyboard...
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];
    [self.x addGestureRecognizer:panGesture];
    [self.o addGestureRecognizer:panGesture];
    panGesture = nil;
    
    //X gets the first move.
    _currentPlayer = 1;
    
    [self makeMove];
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

- (XO*)getCurrentPlayer {
    
    
    if (_currentPlayer == 1) {
        return self.x;
    }
    else {
        return self.o;
    }
}

//Source: http://stackoverflow.com/questions/22395712/making-an-animation-to-expand-and-shrink-an-uiview
- (void)currentPlayerAnimation {
    XO* player = [self getCurrentPlayer];
    
    [UIView animateWithDuration:1.5
                     animations:^{
                         player.transform = CGAffineTransformMakeScale(1.5, 1.5);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1
                                          animations:^{
                                              player.transform = CGAffineTransformIdentity;
                                              
                                          }];
                     }];
}

- (void)makeMove {
    [self currentPlayerAnimation];
    XO* player = [self getCurrentPlayer];
    //after pan ended...
    for (int i=0; i<9; i++) {
        //where the player's piece was dropped
        CGRect playerFrame = [player frame];
        //the space on the grid you are currently checking
        CGRect imageFrame = [self.imageArray[i] frame];
        
        //intersection between the piece's drop position and current grid space
        CGRect intersection = CGRectIntersection(playerFrame, imageFrame);
        
        if (CGRectIsNull(intersection)) {
            //not touching
        }
        else {
            //touching!
        }
    }
}



- (void)switchPlayer {
    
    if (_currentPlayer == 1) {
        _currentPlayer = 0;
    }
    else {
        _currentPlayer = 1;
    }
}

- (bool)gameOver {
    //if 3 in a row, then game over
    return true;
}

@end
