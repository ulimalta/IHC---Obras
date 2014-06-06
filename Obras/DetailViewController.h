//
//  DetailViewController.h
//  Obras
//
//  Created by Ulisses Malta Santos on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "Obra.h"
#import "Usuario.h"
#import "Comentario.h"
#import "DatabaseUtilities.h"
#import "CommentCell.h"
#import "ImageViewController.h"

@interface DetailViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) Obra *construction;

- (void)setConstruction:(Obra *)obra;

@end
