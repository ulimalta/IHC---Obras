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
@property (nonatomic) double  lat;
@property (nonatomic) double  longi;
@property (nonatomic, strong) NSMutableArray *comentarios;
@property (nonatomic, strong) Usuario *usuario;
@property (nonatomic, strong) NSMutableArray *pictures;
@property (nonatomic, strong) NSString *descricao;
@property (nonatomic) NSInteger numeroLikes;
@property (nonatomic) NSInteger numeroDislikes;

@end
