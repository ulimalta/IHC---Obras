//
//  MapViewAnnotation.m
//  coreData
//
//  Created by Ulisses Malta Santos on 20/01/14.
//  Copyright (c) 2014 Ulisses Malta Santos e Luis Fernando Antonioli. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize title, subtitle, coordinate;

-(id)initWithCoordinate :(CLLocationCoordinate2D) c
                   title:(NSString *) t
                subTitle:(NSString *) st
{
    self = [super init];
    if (self) {
        title = t;
        subtitle = st;
        coordinate = c;
    }   
    return self;
}

@end
