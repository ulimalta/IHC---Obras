//
//  NewConstructionViewController.h
//  Obras
//
//  Created by Ulisses Malta Santos on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Obra.h"
#import "Usuario.h"
#import "DatabaseUtilities.h"

@interface NewConstructionViewController : UIViewController

@property (nonatomic, strong) MKUserLocation *userLocation;

- (void) setUserLocation:(MKUserLocation *)userLocation;

@end
