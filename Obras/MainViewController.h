//
//  MainViewController.h
//  Obras
//
//  Created by Ulisses Malta Santos on 28/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "Obra.h"
#import "DatabaseUtilities.h"
#import "DetailViewController.h"

@interface MainViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end
