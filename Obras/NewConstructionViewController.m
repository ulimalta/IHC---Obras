//
//  NewConstructionViewController.m
//  Obras
//
//  Created by Ulisses Malta Santos on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import "NewConstructionViewController.h"

@interface NewConstructionViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *TitleNavigationItem;

@end

@implementation NewConstructionViewController

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
    titleLabel.text = @"Nova Obra";
    [self.TitleNavigationItem setTitleView: titleLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)okButtonAction:(id)sender {
    
}

@end
