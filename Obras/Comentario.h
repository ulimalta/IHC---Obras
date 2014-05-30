//
//  Comentario.h
//  Obras
//
//  Created by Luis Fernando Antonioli on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Usuario.h"

@interface Comentario : NSObject

@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) Usuario *user;
@property (nonatomic, strong) NSString *postDate;

@end
