//
//  NewConstructionViewController.m
//  Obras
//
//  Created by Ulisses Malta Santos on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import "NewConstructionViewController.h"

@interface NewConstructionViewController () <MKMapViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate> {
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *TitleNavigationItem;
@property (weak, nonatomic) IBOutlet MKMapView *MyMap;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) Obra *novaObra;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *MyScrollView;

@property(nonatomic) NSInteger currentPicture;

@end

@implementation NewConstructionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentPicture = -1;
    self.MyMap.showsUserLocation = YES;
    self.MyMap.delegate = self;
    self.MyMap.mapType = MKMapTypeStandard;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = self.userLocation.coordinate.latitude;
    location.longitude = self.userLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [self.MyMap setRegion: region animated: YES];
    self.latitudeTextField.text = [NSString stringWithFormat: @"%.8f", self.userLocation.coordinate.latitude];
    self.longitudeTextField.text = [NSString stringWithFormat: @"%.8f", self.userLocation.coordinate.longitude];
    geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: self.userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            [self.cityTextField setText:[NSString stringWithFormat: @"%@", placemark.locality]];
        } else {
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle: @"Erro"
                                             message: @"Não foi possível obter sua localização atual!"
                                            delegate: nil
                                   cancelButtonTitle: @"OK"
                                   otherButtonTitles: nil];
            [errorAlert show];
        }
    } ];
    self.novaObra = [[Obra alloc] init];
    self.novaObra.usuario = [DatabaseUtilities getCurrentUser];
    self.novaObra.numeroLikes = 0;
    self.novaObra.numeroDislikes = 0;
    self.novaObra.pictures = [[NSMutableArray alloc] init];
    self.novaObra.lat = self.userLocation.coordinate.latitude;
    self.novaObra.longi = self.userLocation.coordinate.longitude;
    UIFont *textFont = [UIFont fontWithName: @"Chalkduster" size: 17];
    self.authorLabel.text = [NSString stringWithFormat: @"Autor: %@", self.novaObra.usuario.userName];
    self.authorLabel.font = textFont;
    UIColor *textColor = [UIColor colorWithRed: 139.0/255.0 green: 191.0/255.0 blue: 249.0/255.0 alpha: 1.0];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 30)];
    titleLabel.font = textFont;
    titleLabel.textColor = textColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"Nova Obra";
    [self.TitleNavigationItem setTitleView: titleLabel];
    self.cityLabel.adjustsFontSizeToFitWidth = YES;
    self.cityLabel.font = textFont;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.font = textFont;
    self.longitudeLabel.adjustsFontSizeToFitWidth = YES;
    self.longitudeLabel.font = textFont;
    self.latitudeLabel.adjustsFontSizeToFitWidth = YES;
    self.latitudeLabel.font = textFont;
    self.latitudeTextField.font = textFont;
    self.longitudeTextField.font = textFont;
    self.cityTextField.font = textFont;
    self.titleTextField.font = textFont;
    self.titleTextField.delegate = self;
    self.latitudeTextField.userInteractionEnabled = NO;
    self.longitudeTextField.userInteractionEnabled = NO;
    self.cityTextField.userInteractionEnabled = NO;
    CGFloat borderWidth = 1.0;
    self.descriptionTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.descriptionTextView.layer.borderWidth = borderWidth;
    self.descriptionTextView.layer.cornerRadius = 5.0;
    self.descriptionTextView.clipsToBounds = YES;
    self.descriptionTextView.editable = YES;
    self.descriptionTextView.font = textFont;
    self.descriptionTextView.backgroundColor = [UIColor whiteColor];
    self.descriptionTextView.delegate = self;
    UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(dismissKeyboard)];
    [self.view addGestureRecognizer: gestureRecognizer];
    self.pictureImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* pictureGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(getPicture)];
    [self.pictureImageView addGestureRecognizer: pictureGestureRecognizer];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget: self
                                                                                    action: @selector(swipeHandlerLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.numberOfTouchesRequired = 1;
    [self.pictureImageView addGestureRecognizer: swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget: self
                                                                                     action: @selector(swipeHandlerRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [self.pictureImageView addGestureRecognizer: swipeRight];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWasShown:)
                                                 name: UIKeyboardWillShowNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWillBeHidden:)
                                                 name: UIKeyboardDidHideNotification
                                               object: nil];
    self.MyScrollView.contentOffset = CGPointZero;
    self.MyScrollView.contentInset = UIEdgeInsetsZero;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    CGPoint scrollPoint = CGPointMake( 0.0, screenSize.size.height/80);
    [self.MyScrollView setContentOffset: scrollPoint animated: YES];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (self.descriptionTextView.isFirstResponder) {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        [self.MyScrollView setContentOffset: CGPointMake(0, self.descriptionTextView.center.y-kbSize.height) animated: YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.MyScrollView setContentOffset: CGPointMake(0, 0) animated: YES];
}

- (void)swipeHandlerLeft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (self.currentPicture >= 0) {
        if (self.currentPicture >= 0) {
            if (self.currentPicture + 1 < [[self.novaObra pictures] count]) {
                self.currentPicture++;
                self.pictureImageView.image = [self.novaObra.pictures objectAtIndex: self.currentPicture];
            }
        }
    }
}

- (void)swipeHandlerRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (self.currentPicture >= 0) {
        if (self.currentPicture - 1 >= 0) {
            self.currentPicture--;
            self.pictureImageView.image = [self.novaObra.pictures objectAtIndex: self.currentPicture];
        }
    }
}

- (void)dismissKeyboard {
    [self.titleTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
}

- (void) getPicture
{
    [[[UIAlertView alloc] initWithTitle: @"Nova foto."
                                message: @"Escolha uma foto da sua biblioteca ou tire uma nova foto."
                               delegate: self
                      cancelButtonTitle: @"Cancelar"
                      otherButtonTitles: @"Biblioteca", @"Tirar foto", nil] show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)okButtonAction:(id)sender {
    if (self.novaObra.descricao && ![self.novaObra.descricao isEqualToString: @""] && self.novaObra.titulo && ![self.novaObra.titulo isEqualToString: @""]) {
        [DatabaseUtilities uploadObra: self.novaObra];
        [self dismissViewControllerAnimated: YES completion: nil];
    }
    else {
        [[[UIAlertView alloc] initWithTitle: @"Preencha todos os campos."
                                    message: @"Os campos de título e descrição são obrigatórios."
                                   delegate: self
                          cancelButtonTitle: @"OK"
                          otherButtonTitles: nil] show];
    }
}

- (void) setUserLocation:(MKUserLocation *)userLocation
{
    _userLocation = userLocation;
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
    [aMapView setRegion: region animated: YES];
    self.latitudeTextField.text = [NSString stringWithFormat: @"%.8f", aUserLocation.coordinate.latitude];
    self.longitudeTextField.text = [NSString stringWithFormat: @"%.8f", aUserLocation.coordinate.longitude];
    self.userLocation = aUserLocation;
    self.novaObra.lat = self.userLocation.coordinate.latitude;
    self.novaObra.longi = self.userLocation.coordinate.longitude;
    [geocoder reverseGeocodeLocation: aUserLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            [self.cityTextField setText:[NSString stringWithFormat: @"%@", placemark.locality]];
        } else {
            UIAlertView *errorAlert = [[UIAlertView alloc]
                                       initWithTitle: @"Erro"
                                             message: @"Não foi possível obter sua localização atual!"
                                            delegate: nil
                                   cancelButtonTitle: @"OK"
                                   otherButtonTitles: nil];
            [errorAlert show];
        }
    } ];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.novaObra.titulo = textField.text;
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        return;
    }
    else if (buttonIndex == 1) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated: YES completion: NULL];
    }
    else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated: YES completion: NULL];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [[self.novaObra pictures] insertObject: chosenImage atIndex: 0];
    if ([[self.novaObra pictures] count]) {
        self.currentPicture = 0;
        self.pictureImageView.image = [self.novaObra.pictures objectAtIndex: 0];
    }
    else {
        self.currentPicture = -1;
    }
    [picker dismissViewControllerAnimated: YES completion: NULL];
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString: @"Descrição"]) {
        textView.text = @"";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text rangeOfCharacterFromSet: [NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
    self.novaObra.descricao = textView.text;
    [textView resignFirstResponder];
    return NO;
}

@end
