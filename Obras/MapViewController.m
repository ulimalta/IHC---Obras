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

@property (strong, nonatomic) MKUserLocation* userLocation;

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
    [self performSegueWithIdentifier: @"newConstructionSegue" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pegar objeto certo
    Obra *o = [[DatabaseUtilities getObras] objectAtIndex: 0];
    if ([[segue identifier] isEqualToString: @"detailSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        DetailViewController *nextController = (id)[[navigationController viewControllers] objectAtIndex: 0];
        [nextController setConstruction: o];
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
    
    // Teste
    
    MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithCoordinate: location title: @"Teste" subTitle: @"Meu teste"];
    [self.MyMap addAnnotation: annotation];
    MKCircle *circle = [MKCircle circleWithCenterCoordinate: location radius: 40];
    [self.MyMap addOverlay: circle];

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
    [self performSegueWithIdentifier: @"detailSegue" sender: self];
}

@end
