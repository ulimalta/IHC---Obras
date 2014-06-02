//
//  DatabaseUtilities.h
//  Obras
//
//  Created by Luis Fernando Antonioli on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "Obra.h"
#import "Usuario.h"
#import "Comentario.h"

@interface DatabaseUtilities : NSObject

//+ (NSArray* ) getObras;

+ (void) getObrasForUserLatitude:(float)userLatitude userLongitude:(float)userLongitude withCompletionBlock:(void (^) (NSArray* )) completionBlock;

+ (Usuario *) getCurrentUser;

@end
