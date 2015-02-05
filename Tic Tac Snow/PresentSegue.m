//
//  PresentSegue.m
//  Tic Tac Snow
//
//  Created by ajchang on 2/5/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import "PresentSegue.h"
#import "QuartzCore/QuartzCore.h"

@implementation PresentSegue

//override perform
//Source: http://blog.jambura.com/2012/07/05/custom-segue-animation-left-to-right-using-catransition/#sthash.Mqx0Is1p.dpuf
- (void)perform
{
    NSLog(@"Perform");
    // Add your own animation code here.
    
    UIViewController *sourceViewController = (UIViewController*)[self sourceViewController];
    UIViewController *destinationController = (UIViewController*)[self destinationViewController];
    
    CATransition* transition = [CATransition animation];
    transition.duration = .25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromLeft; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    
    
    
    [sourceViewController.navigationController.view.layer addAnimation:transition
                                                                forKey:kCATransition];
    
    [[self sourceViewController] presentModalViewController:[self destinationViewController] animated:NO];
}

@end
