//
//  ViewController.m
//  Tic Tac Snow
//
//  Created by ajchang on 2/4/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "ViewController.h"
#define MIN_INTERSECTION_AREA 3000
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()

@property int currentPlayer; //1 for x, 2 for o
@property CGFloat originalX;
@property CGFloat originalY;
@property NSMutableArray* placements; //corresponds to piece placements; 0 = not occupied, 1 = occupied by x, 2 = occupied by o
@property UIView* lineView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageArray = [[NSMutableArray alloc] initWithCapacity:9];
    
    //initialize imageArray
    //**REMEMBER: TAGS MUST BE GREATER THAN 100!
    for (int i=101; i<=109; i++) {
        [self.imageArray addObject:[self.view viewWithTag:i]];
    }
    
    //initialize placements array
    _placements = [[NSMutableArray alloc] initWithCapacity:9];
    for (int i=0; i<9; i++) {
        [_placements addObject:[NSNumber numberWithInt:0]];
    }
    
    [self.x setWeight:1];
    [self.o setWeight:2];

    //programatically add pan gesture recognizer to x and o
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

-(void)playSound:(NSString*)name ofType:(NSString*)type {
    //create sound
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    NSURL *URL = [NSURL fileURLWithPath:path];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)
                                     URL, &soundID);
    //play the sound
    AudioServicesPlaySystemSound(soundID);
    NSLog(@"playing %@ sound", name);
    
    //dispose of the sound
    AudioServicesDisposeSystemSoundID(soundID);
    
    return;
}

- (void)checkForIntersection {
    XO* player = [self getCurrentPlayer];
    
    
    //where the player's piece was dropped
    CGRect playerFrame = [player frame];
   
    Boolean touched = false;
    
    //after pan ended...
    for (int i=0; i<9; i++) {
        UIImageView *u = [self.imageArray objectAtIndex:i];
        
        //the space on the grid you are currently checking
        CGRect imageFrame = [u frame];
        
        //intersection between the piece's drop position and current grid space
        CGRect intersection = CGRectIntersection(playerFrame, imageFrame);
        int overlap = intersection.size.height * intersection.size.width;
        
        //snap back to original position
        [UIView animateWithDuration:1.0
                         animations:^{
                             [player setFrame:CGRectMake (_originalX, _originalY, 100, 100)];
                         }
                         completion:nil];

        
        //if the area of intersection is above a certain size and space is not occupied
        if ((overlap > MIN_INTERSECTION_AREA)) {
            
            //if space is already occupied, play buzzer sound
            if ([[_placements objectAtIndex:i] intValue]!=0) {
                [self playSound:@"buzzer" ofType:@"caf"];
                break;
            }
            
            //**YOU ACTUALLY HAVE TO USE THE RIGHT IDENTIFIER OR ELSE IT MESSES WITH THE NUMERICAL OUTPUT!!
            NSLog(@"Valid! intersection area: %f, intersection height: %f, width: %f", intersection.size.height * intersection.size.width, intersection.size.height, intersection.size.width);
            touched = true;
            
            [self playSound:@"ping" ofType:@"aiff"];
            
            //record corresponding number in corresponding index in placements array
            [_placements replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:player.weight]];

            //draw x or o in that space
            [u setImage:player.image];
            
            int gameOver = [self gameOver];
            if (gameOver != 0) {
                NSString *msg = [[NSString alloc] init];
                if (gameOver==1) {
                    msg = @"X wins!";
                    [self playSound:@"cheering" ofType:@"caf"];
                }
                else if (gameOver==2) {
                    msg = @"O wins!";
                    [self playSound:@"cheering" ofType:@"caf"];
                }
                else {
                    msg = @"No one wins.  Stalemate.";
                }
                
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                                message:msg
                                                               delegate:self
                                                      cancelButtonTitle:@"New game"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
            else {
                [self togglePlayer];
                [self makeMove];
            }
            
            break;
        }
    }
    
    if (!touched) {
        //not touching
        NSLog(@"NOT valid!");
    }
}

//Implemented UIAlertViewDelegate in order to be able to BLOCK until UIAlertView is dismissed!
//NOTE: Without this protocol, UIAlertView will NOT block or wait for button tap!
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    [self reset];
}

//Source: http://www.raywenderlich.com/6567/uigesturerecognizer-tutorial-in-ios-5-pinches-pans-and-more
//make sure you checked "user interaction enabled" under ATTRIBUTES!!!!!
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender {
    //NSLog(@"handlePan");
    
    CGPoint translation = [sender translationInView:self.view];
    sender.view.center = CGPointMake(sender.view.center.x + translation.x,
                                         sender.view.center.y + translation.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self playSound:@"flagscore" ofType:@"wav"];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self checkForIntersection];
    }
  }

- (IBAction)presentInfo:(UIButton *)sender {
    int x = self.view.bounds.size.width/2-110;
    
    UIView *info = [self.view viewWithTag:110];

    //move info offscreen before making it visible
    [info setFrame:CGRectMake(x, -500, 230, 400)];
    info.hidden = NO;
    
    //fall-down animation
    [UIView animateWithDuration:1.0
                     animations:^{
                         [info setFrame:CGRectMake(x, 100, 230, 400)];
                     }
                     completion:nil];
}

- (IBAction)dismissInfo:(UIButton *)sender {
    int x = self.view.bounds.size.width/2-110;
    
    UIView *info = [self.view viewWithTag:110];
    
    //fall-out animation
    [UIView animateWithDuration:1.0
                     animations:^{
                         [info setFrame:CGRectMake(x, 1000, 230, 400)];
                     }
                     completion:^(BOOL completed) {
                         info.hidden=YES;
                     }];
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
                         
                         player.transform = CGAffineTransformMakeScale(2, 2); //make active player's piece grow
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
        _currentPlayer = 2;
    }
    else {
        _currentPlayer = 1;
    }
}

- (void)drawLine:(UIImageView*)begin withType:(NSString*)type {
    CGFloat x1 = begin.frame.origin.x;
    CGFloat y1 = begin.frame.origin.y;
    CGFloat radians;
    
    if ([type isEqualToString:@"row"]) {
        radians = 0;
        y1+=50;
    }
    else if ([type isEqualToString:@"col"]) {
        radians = -1.571;
        x1-=110;
        y1+=155;
    }
    else if ([type isEqualToString:@"diag1"]) {
        radians = 0.785;
        y1+=155;
    }
    else {
        radians = -0.785;
        y1-=65;
    }
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(x1, y1, 330, 4)];
    _lineView.backgroundColor = [UIColor purpleColor];
    _lineView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, radians);
    [self.view addSubview:_lineView];
    
    return;
}

//return 0 if no winner yet, 1 if X has won, 2 if O has won, and -1 if stalemate.
- (int)gameOver {
    
    int a;
    int b;
    int c;
    
    //check for row victory
    for (int i=0; i<9; i+=3) {
        
        a = [[_placements objectAtIndex:i] intValue];
        b = [[_placements objectAtIndex:i+1] intValue];
        c = [[_placements objectAtIndex:i+2] intValue];
        if (a==b && a==c && a!=0) {
            [self drawLine:[self.imageArray objectAtIndex:i] withType:@"row"];
            return a;
        }
    }
    
    //check for column victory
    for (int i=0; i<3; i++) {
        a = [[_placements objectAtIndex:i] intValue];
        b = [[_placements objectAtIndex:i+3] intValue];
        c = [[_placements objectAtIndex:i+6] intValue];
        if (a==b && a==c && a!=0) {
            [self drawLine:[self.imageArray objectAtIndex:i] withType:@"col"];
            return a;
        }
    }
    
    //check for diagonal victory
    a = [[_placements objectAtIndex:0] intValue];
    b = [[_placements objectAtIndex:4] intValue];
    c = [[_placements objectAtIndex:8] intValue];
    if (a==b && a==c && a!=0) {
        [self drawLine:[self.imageArray objectAtIndex:0] withType:@"diag1"];
        return a;
    }
    
    a = [[_placements objectAtIndex:2] intValue];
    b = [[_placements objectAtIndex:4] intValue];
    c = [[_placements objectAtIndex:6] intValue];
    if (a==b && a==c && a!=0){
        [self drawLine:[self.imageArray objectAtIndex:6] withType:@"diag2"];
        return a;
    }
    
    for (int i=0; i<9; i++) {
        if ([[_placements objectAtIndex:i] intValue] == 0) //game is still going
            return 0;
    }
    
    return -1;
}

-(void) reset {
    for (int i=0; i<9; i++) {
        UIImageView *u = [self.imageArray objectAtIndex:i];
        
        int val = [[_placements objectAtIndex:i]intValue];
        
        if (val == 1 || val == 2) {
            /* We will make a DEEP COPY of the UIImageView containing the X or O in this space.  We will animate this COPY back to the initial piece position,
            instead of the image view itself, and then remove the copy from the superview.  As for the actual UIImageView contained in the storyboard and imageArray itself,
            it stays EXACTLY where it is - we will simply clear its image.  The reason being, if you animated the original image view away, then you would no longer
             have access to that image view and its position for future games. */
            
            //make deep copy of image view
            UIImageView *copy = [[UIImageView alloc] initWithFrame:CGRectMake(u.frame.origin.x, u.frame.origin.y, 100, 100)];
            [copy setImage:u.image];
            [self.view addSubview:copy];
            
            //Animate: snap copy back to original position
            [UIView animateWithDuration:1.0
                             animations:^{
                             if (val==1)
                                 [copy setFrame:CGRectMake (16, 547, 100, 100)];
                             else
                                 [copy setFrame:CGRectMake(259, 547, 100, 100)];
                                 
                         }
                         completion:^(BOOL finished) {
                             [copy removeFromSuperview];
                         }];
        }
        
        //clear u's image on the grid
        u.image = nil;
        
        //reset corresponding value in placements array
        [_placements replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
    }
    /* remove line from view */
    [_lineView removeFromSuperview];
    
    /* New game setup */
    _currentPlayer = 1; //new game starts with X's turn
    
    [self makeMove]; //start new game
}

@end

