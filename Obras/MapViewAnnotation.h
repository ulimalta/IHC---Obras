//
//  MapViewAnnotation.h
//  coreData
//
//  Created by Ulisses Malta Santos on 20/01/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewAnnotation: NSObject <MKAnnotation> {
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
    UIImage *img;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly, copy) UIImage *img;

-(id) initWithCoordinate:(CLLocationCoordinate2D) c
                   title:(NSString *) t
                subTitle:(NSString *) st
                  setImg:(UIImage *) myImg;

@end