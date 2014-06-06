//
//  MapViewAnnotation.m
//  coreData
//
//  Created by Ulisses Malta Santos on 20/01/14.
//  Copyright (c) 2014 Ulisses Malta Santos e Luis Fernando Antonioli. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize title, subtitle, coordinate, img;

-(id)initWithCoordinate :(CLLocationCoordinate2D) c
                   title:(NSString *) t
                subTitle:(NSString *) st
                  setImg:(UIImage *) myImg
{
    self = [super init];
    if (self) {
        title = t;
        subtitle = st;
        coordinate = c;
        img = myImg;
    }   
    return self;
}

@end
