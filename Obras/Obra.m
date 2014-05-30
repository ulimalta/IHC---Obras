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
        self.comentarios = [[NSMutableArray alloc] init];
        self.usuario = [[Usuario alloc] init];
    }
    return self;
}


@end
