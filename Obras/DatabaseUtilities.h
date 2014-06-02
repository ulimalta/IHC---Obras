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

+ (void) getObrasForUserLatitude:(double)userLatitude
                   userLongitude:(double)userLongitude
             withCompletionBlock:(void (^) (NSArray* )) completionBlock;
+ (void) uploadObra:(Obra *)obra;
+ (void) uploadComment:(Comentario* )comentario InObra:(Obra*)obra;
+ (void) updateObraLikesAndDislikes:(Obra *)obra;
+ (void) getAllCommentsFromObra:(Obra*)obra withCompletionBlock:(void (^) (NSArray* )) completionBlock;
+ (Usuario *) getCurrentUser;
+ (void) uploadPhoto:(UIImage*)photo toObra:(Obra*)obra;

@end
