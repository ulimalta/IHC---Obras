//
//  Obra.h
//  Obras
//
//  Created by Luis Fernando Antonioli on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Comentario.h"
#import "Usuario.h"

@interface Obra : NSObject

@property (nonatomic, strong) NSString *titulo;
@property (nonatomic) float  latitude;
@property (nonatomic) float  longitude;
@property (nonatomic, strong) NSMutableArray *comentarios;
@property (nonatomic, strong) Usuario *usuario;
@property (nonatomic, strong) NSMutableArray *pictures;

@end
