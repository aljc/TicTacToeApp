//
//  ViewController.m
//  Tic Tac Snow
//
//  Created by ajchang on 2/4/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "ViewController.h"
#define MIN_INTERSECTION_AREA 3000

@interface ViewController ()

@property NSInteger currentPlayer;
@property CGFloat originalX;
@property CGFloat originalY;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageArray = [[NSMutableArray alloc] initWithCapacity:9];
    
    //**REMEMBER: TAGS MUST BE GREATER THAN 100!
    for (int i=101; i<=109; i++) {
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
    
    while (![self gameOver]) {
        [self makeMove];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkForIntersection {
    XO* player = [self getCurrentPlayer];
    
    
    //where the player's piece was dropped
    CGRect playerFrame = [player frame];
   
    Boolean touched = false;
    
    //after pan ended...
    for (UIImageView *u in self.imageArray) {
        //the space on the grid you are currently checking
        CGRect imageFrame = [u frame];
        
        //intersection between the piece's drop position and current grid space
        CGRect intersection = CGRectIntersection(playerFrame, imageFrame);
        NSInteger overlap = intersection.size.height * intersection.size.width;
        
        //if the rectangle that is the area of intersection is above a certain area size
        if (overlap > MIN_INTERSECTION_AREA) {
            //touching!
            //**YOU ACTUALLY HAVE TO USE THE RIGHT IDENTIFIER OR ELSE IT MESSES WITH THE NUMERICAL OUTPUT!!
            NSLog(@"TOUCHING! intersection area: %f, intersection height: %f, width: %f", intersection.size.height * intersection.size.width, intersection.size.height, intersection.size.width);
            touched = true;
            [UIView animateWithDuration:0.2
                             animations:^{
                                 //snap to center of space
                                 [player setFrame:CGRectMake (imageFrame.origin.x, imageFrame.origin.y, 100, 100)];
                             }
                             completion:^(BOOL finished) {
                                 [self togglePlayer];
                                 [self makeMove];
                             }];
            
            break;
        }
    }
    
    if (!touched) {
        //not touching
        NSLog(@"NOT touching!");
        [UIView animateWithDuration:1.0
                         animations:^{
                             //snap back to original position if not on a valid space
                             [player setFrame:CGRectMake (_originalX, _originalY, 100, 100)];
                         }
                         completion:nil];
    }
}

//Source: http://www.raywenderlich.com/6567/uigesturerecognizer-tutorial-in-ios-5-pinches-pans-and-more
//make sure you checked "user interaction enabled" under ATTRIBUTES!!!!!
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender {
    //NSLog(@"handlePan");
    
    CGPoint translation = [sender translationInView:self.view];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x,
                                         sender.view.center.y + translation.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self checkForIntersection];
    }
  }

- (XO*)getCurrentPlayer {
    if (_currentPlayer == 1) {
        return self.x;
    }
    else {
        return self.o;
    }
}

- (XO*)getOtherPlayer {
    if (_currentPlayer == 1) {
        return self.o;
    }
    else {
        return self.x;
    }
}


//Source: http://stackoverflow.com/questions/22395712/making-an-animation-to-expand-and-shrink-an-uiview
- (void)currentPlayerAnimation {
    XO* player = [self getCurrentPlayer];
    XO* other = [self getOtherPlayer];
    
    //save original coordinates of this piece in case you need to send it back to this point later upon a failed pan
    _originalX = player.frame.origin.x;
    _originalY = player.frame.origin.y;
    
    //neither player can move until the animation period is over
    self.x.userInteractionEnabled = NO;
    self.o.userInteractionEnabled = NO;

    [UIView animateWithDuration:0.5 delay:0.5 options: UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         player.alpha = 1.0; //fade in the active player's piece
                         other.alpha = 0.5; //fade out the inactive player's piece
                         
                         player.transform = CGAffineTransformMakeScale(1.5, 1.5); //make active player's piece grow
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:1
                                          animations:^{
                                              player.transform = CGAffineTransformIdentity; //make active player's piece shrink back to normal size
                                              
                                          }];
                     }];
    
    player.userInteractionEnabled = YES;
}

- (void)makeMove {
    [self currentPlayerAnimation];
}



- (void)togglePlayer {
    
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
