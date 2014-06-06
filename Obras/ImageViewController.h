//
//  ImageViewController.h
//  Obras
//
//  Created by Ulisses Malta Santos on 06/06/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Obra.h"

@interface ImageViewController : UIViewController

@property (nonatomic, strong) Obra *ob;
@property (nonatomic) int index;

- (void) setOb:(Obra *)ob;
- (void)setIndex:(int)index;

@end
