//
//  ViewController.h
//  Tic Tac Snow
//
//  Created by ajchang on 2/4/15.
//  Copyright (c) 2015 ajchang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XO.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *gridView;
@property NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet XO *x;
@property (weak, nonatomic) IBOutlet XO *o;
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender;

@end

