//
//  DetailViewController.m
//  Obras
//
//  Created by Ulisses Malta Santos on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *TitleNavigationItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *BackButton;
@property (weak, nonatomic) IBOutlet UIImageView *Picture;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIFont *textFont = [UIFont fontWithName: @"Chalkduster" size: 17];
    UIColor *textColor = [UIColor colorWithRed: 139.0/255.0 green: 191.0/255.0 blue: 249.0/255.0 alpha: 1.0];
	
    UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320, 30)];
    titleLabel.font = textFont;
    titleLabel.textColor = textColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    if (self.construction.titulo && ![self.construction.titulo isEqualToString: @""]) {
        titleLabel.text = self.construction.titulo;
    }
    else {
        titleLabel.text = @"Obras - Info";
    }
    
    
    NSLog(@"%@", self.construction.titulo);
    
    [self.TitleNavigationItem setTitleView: titleLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setConstruction:(Obra *)obra
{
    if (obra) {
        _construction = obra;
    }
     NSLog(@"qqqqq %@", obra.titulo);    
}

- (IBAction)BackButtonAction:(id)sender {
     [self dismissViewControllerAnimated: YES completion: nil];
}

@end
