//
//  Obra.m
//  Obras
//
//  Created by Luis Fernando Antonioli on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import "Obra.h"

@implementation Obra

- (id)init
{
    self = [super init];
    if (self) {
        self.pictures = [[NSMutableArray alloc] init];
        self.usuario = [[Usuario alloc] init];
        self.numeroDislikes = 0;
        self.numeroLikes = 0;
    }
    return self;
}

@end
