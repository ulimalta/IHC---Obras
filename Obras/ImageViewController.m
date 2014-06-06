//
//  ImageViewController.m
//  Obras
//
//  Created by Ulisses Malta Santos on 06/06/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScroll;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleNavigationItem;

@property (nonatomic, strong) UIImage *img;
@property (nonatomic) NSInteger currentPicture;

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentPicture = self.index;
    UIFont *textFont = [UIFont fontWithName: @"Noteworthy-Bold" size: 18];
    UIColor *textColor = [UIColor colorWithRed: 139.0/255.0 green: 191.0/255.0 blue: 249.0/255.0 alpha: 1.0];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 30)];
    titleLabel.font = textFont;
    titleLabel.textColor = textColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [NSString stringWithFormat: @"%d de %d", self.currentPicture+1, [self.ob.pictures count]];
    [self.titleNavigationItem setTitleView: titleLabel];
    self.img = [self resizeImage: [self.ob.pictures objectAtIndex: self.index] withMaxDimension: MIN(self.view.frame.size.height, self.view.frame.size.width)];
    [self.myImage setFrame: CGRectMake(CGRectGetMidX(self.view.bounds) - CGRectGetMidX(self.myImage.bounds)-65, CGRectGetMidY(self.view.bounds) - CGRectGetMidY(self.myImage.bounds), self.img.size.width, self.img.size.height)];
    self.myImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.myImage.image = self.img;
    self.view.backgroundColor = [UIColor colorWithRed: 215.0/255.0 green: 215.0/255.0 blue: 215.0/255.0 alpha: 0.5];
    [self.backButton setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName: @"Noteworthy-Bold" size: 13], NSFontAttributeName, nil] forState: UIControlStateNormal];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget: self
                                                                                    action: @selector(swipeHandlerLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.numberOfTouchesRequired = 1;
    [self.myImage addGestureRecognizer: swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget: self
                                                                                     action: @selector(swipeHandlerRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.numberOfTouchesRequired = 1;
    [self.myImage addGestureRecognizer: swipeRight];
    self.myImage.userInteractionEnabled = YES;
    self.myImage.contentMode = UIViewContentModeScaleAspectFit;
    self.myImage.clipsToBounds = YES;
    [self.myImage sizeToFit];
    self.imageScroll.frame = CGRectMake(0, 65, 320, 415);
    self.imageScroll.minimumZoomScale = 1.0;
    self.imageScroll.maximumZoomScale = 3.0;
    self.imageScroll.contentSize = self.img.size;
    self.imageScroll.delegate = self;
}

- (void)swipeHandlerLeft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (self.currentPicture >= 0) {
        if (self.currentPicture >= 0) {
            if (self.currentPicture + 1 < [[self.ob pictures] count]) {
                self.currentPicture++;
                self.img = [self resizeImage: [self.ob.pictures objectAtIndex: self.currentPicture] withMaxDimension: MIN(self.view.frame.size.height, self.view.frame.size.width)];
                self.myImage.image = self.img;
                [self.myImage setBounds: CGRectMake(CGRectGetMidX(self.view.bounds) - CGRectGetMidX(self.myImage.bounds)-65, CGRectGetMidY(self.view.bounds) - CGRectGetMidY(self.myImage.bounds), self.img.size.width, self.img.size.height)];
                self.myImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
                [self.myImage sizeToFit];
                [self.myImage setNeedsDisplay];
                UIFont *textFont = [UIFont fontWithName: @"Noteworthy-Bold" size: 18];
                UIColor *textColor = [UIColor colorWithRed: 139.0/255.0 green: 191.0/255.0 blue: 249.0/255.0 alpha: 1.0];
                UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 30)];
                titleLabel.font = textFont;
                titleLabel.textColor = textColor;
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.text = [NSString stringWithFormat: @"%d de %d", self.currentPicture+1, [self.ob.pictures count]];
                [self.titleNavigationItem setTitleView: titleLabel];
            }
        }
    }
}

- (void)swipeHandlerRight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (self.currentPicture >= 0) {
        if (self.currentPicture - 1 >= 0) {
            self.currentPicture--;
            self.img = [self resizeImage: [self.ob.pictures objectAtIndex: self.currentPicture] withMaxDimension: MIN(self.view.frame.size.height, self.view.frame.size.width)];
            self.myImage.image = self.img;
            [self.myImage setBounds: CGRectMake(CGRectGetMidX(self.view.bounds) - CGRectGetMidX(self.myImage.bounds)-65, CGRectGetMidY(self.view.bounds) - CGRectGetMidY(self.myImage.bounds), self.img.size.width, self.img.size.height)];
            self.myImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [self.myImage sizeToFit];
            [self.myImage setNeedsDisplay];
            UIFont *textFont = [UIFont fontWithName: @"Noteworthy-Bold" size: 18];
            UIColor *textColor = [UIColor colorWithRed: 139.0/255.0 green: 191.0/255.0 blue: 249.0/255.0 alpha: 1.0];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 30)];
            titleLabel.font = textFont;
            titleLabel.textColor = textColor;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.text = [NSString stringWithFormat: @"%d de %d", self.currentPicture+1, [self.ob.pictures count]];
            [self.titleNavigationItem setTitleView: titleLabel];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) setOb:(Obra *)ob
{
    _ob = ob;
}

- (void)setIndex:(int)index
{
    _index = index;
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (UIImage *)resizeImage:(UIImage *)image
        withMaxDimension:(CGFloat)maxDimension
{
    if (fmax(image.size.width, image.size.height) <= maxDimension) {
        return image;
    }
    CGFloat aspect = image.size.width / image.size.height;
    CGSize newSize;
    if (image.size.width > image.size.height) {
        newSize = CGSizeMake(maxDimension, maxDimension / aspect);
    }
    else {
        newSize = CGSizeMake(maxDimension * aspect, maxDimension);
    }
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    CGRect newImageRect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
    [image drawInRect: newImageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.myImage;
}

@end
