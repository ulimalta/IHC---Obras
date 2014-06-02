//
//  MapViewController.m
//  Obras
//
//  Created by Ulisses Malta Santos on 28/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *BackButton;
@property (weak, nonatomic) IBOutlet MKMapView *MyMap;
@property (weak, nonatomic) IBOutlet UINavigationItem *TitleNavigationItem;

@property (strong, nonatomic) MKUserLocation *userLocation;
@property (nonatomic, strong) NSMutableArray *constructions;
@property (nonatomic) int constNumber;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.MyMap.showsUserLocation = YES;
    self.MyMap.delegate = self;
    self.MyMap.mapType = MKMapTypeStandard;
    UIFont *textFont = [UIFont fontWithName: @"Chalkduster" size: 17];
    UIColor *textColor = [UIColor colorWithRed: 139.0/255.0 green: 191.0/255.0 blue: 249.0/255.0 alpha: 1.0];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 30)];
    titleLabel.font = textFont;
    titleLabel.textColor = textColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Mapa Obras";
    [self.TitleNavigationItem setTitleView: titleLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)BackButtonAction:(id)sender {
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)newConstructionAction:(id)sender {
    if (![PFUser currentUser]) {
        [[[UIAlertView alloc] initWithTitle: @"Log In."
                                    message: @"Você precisa estar logado para adicionar uma nova obra!"
                                   delegate: nil
                          cancelButtonTitle: @"ok"
                          otherButtonTitles: nil] show];
        return;
    }
    [self performSegueWithIdentifier: @"newConstructionSegue" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"detailSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        DetailViewController *nextController = (id)[[navigationController viewControllers] objectAtIndex: 0];
        [nextController setConstruction: [self.constructions objectAtIndex: self.constNumber]];
    }
    else if ([[segue identifier] isEqualToString: @"newConstructionSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        NewConstructionViewController *nextController = (id)[[navigationController viewControllers] objectAtIndex: 0];
        [nextController setUserLocation: self.userLocation];
    }
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    self.userLocation = aUserLocation;
    [aMapView setRegion: region animated: YES];
    
    NSArray *existingpoints = self.MyMap.annotations;
    if ([existingpoints count]) {
        [self.MyMap removeAnnotations: existingpoints];
    }
    [DatabaseUtilities getObrasForUserLatitude: self.userLocation.location.coordinate.latitude
                                 userLongitude: self.userLocation.location.coordinate.longitude
                           withCompletionBlock: ^void(NSArray *constructionsArray) {
                               self.constructions = [constructionsArray mutableCopy];
                               for (Obra *ob in self.constructions) {
                                   CLLocationCoordinate2D myLocation;
                                   myLocation.latitude = ob.lat;
                                   myLocation.longitude = ob.longi;
                                   MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithCoordinate: myLocation
                                                                                                           title: ob.titulo
                                                                                                        subTitle: ob.descricao];
                                   [self.MyMap addAnnotation: annotation];
                                   MKCircle *circle = [MKCircle circleWithCenterCoordinate: self.userLocation.location.coordinate radius: 30];
                                   [self.MyMap addOverlay: circle];
                               }
                           }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mv viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass: [MKUserLocation class]]) {
        return nil;
    }
    if ([annotation isKindOfClass:[MapViewAnnotation class]]){
        MKPinAnnotationView* pinView = (MKPinAnnotationView*)[self.MyMap dequeueReusableAnnotationViewWithIdentifier: @"custom"];
        if (!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"custom"];
            pinView.pinColor = MKPinAnnotationColorRed;
            [pinView setDraggable: NO];
            [pinView setAnimatesDrop: YES];
            [pinView setCanShowCallout: YES];
        }
        else {
            pinView.annotation = annotation;
        }
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType: UIButtonTypeContactAdd];
        UIImageView *img = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"Obras.jpg"]];
        img.frame = CGRectMake(0, 0, 40, 40);
        pinView.leftCalloutAccessoryView = img;
        return pinView;
    }
    return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay: overlay];
    [circleView setFillColor: [UIColor blueColor]];
    [circleView setStrokeColor: [UIColor whiteColor]];
    [circleView setAlpha: 0.5f];
    return circleView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MapViewAnnotation *annotation = (MapViewAnnotation*)view;
    for (int i = 0; i < [self.constructions count]; i++) {
        if ([[self.constructions objectAtIndex: i] lat] == annotation.coordinate.latitude) {
            if ([[self.constructions objectAtIndex: i] longi] == annotation.coordinate.longitude) {
                self.constNumber = i;
                break;
            }
        }
    }
    if (self.constNumber >= 0) {
        [self performSegueWithIdentifier: @"detailSegue" sender: self];
    }
}

@end
