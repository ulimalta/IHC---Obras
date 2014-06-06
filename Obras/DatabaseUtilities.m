//
//  DatabaseUtilities.m
//  Obras
//
//  Created by Luis Fernando Antonioli on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import "DatabaseUtilities.h"

@implementation DatabaseUtilities

+ (void) uploadObra:(Obra *)obra
{
    PFObject *newObra = [PFObject objectWithClassName:@"Obra"];
    newObra[@"usuario"] =  [PFObject objectWithoutDataWithClassName:@"_User" objectId:obra.usuario.userID];
    newObra[@"descricao"] = obra.descricao;
    newObra[@"titulo"] = obra.titulo;
    PFGeoPoint *pfgeoPoint = [PFGeoPoint geoPointWithLatitude:obra.lat longitude:obra.longi];
    newObra[@"location"] = pfgeoPoint;
    newObra[@"numeroDislikes"] = [NSNumber numberWithInt:obra.numeroDislikes];
    newObra[@"numeroLikes"] = [NSNumber numberWithInt:obra.numeroLikes];
    [newObra saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        for(UIImage* myimg in obra.pictures)
        {
            obra.obraId = newObra.objectId;
            [DatabaseUtilities uploadPhoto:myimg toObra:obra];
        }
    }];
}

+ (void) uploadComment:(Comentario* )comentario InObra:(Obra*)obra
{
    PFObject *myComment = [PFObject objectWithClassName:@"Comentario"];
    myComment[@"comment"] = comentario.comment;
    myComment[@"usuario"] = [PFObject objectWithoutDataWithClassName:@"_User" objectId:comentario.user.userID];
    myComment[@"obra"] = [PFObject objectWithoutDataWithClassName:@"Obra" objectId:obra.obraId];
    myComment[@"PostDate"] = comentario.postDate;
    [myComment  saveInBackground];
}

+ (void) getAllCommentsFromObra:(Obra*)obra withCompletionBlock:(void (^) (NSArray* )) completionBlock
{

    NSMutableArray* commentsArray  = [[NSMutableArray alloc]init];
    PFQuery* commentsQuery = [PFQuery queryWithClassName:@"Comentario"];
    [commentsQuery addDescendingOrder:@"createdAt"];
    [commentsQuery whereKey:@"obra"
                    equalTo:[PFObject objectWithoutDataWithClassName:@"Obra" objectId:obra.obraId]];
    commentsQuery.cachePolicy = kPFCachePolicyNetworkElseCache;
    [commentsQuery includeKey:@"usuario"];
    [commentsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for(PFObject* parseObj in objects)
        {
            Comentario* commentObj = [[Comentario alloc]init];
            
            commentObj.postDate = parseObj[@"PostDate"];
            commentObj.comment = parseObj[@"comment"];
            
            //user info
            
            PFObject *parseUser = parseObj[@"usuario"];
            Usuario* user = [[Usuario alloc]init];
            user.userName = parseUser[@"username"];
            user.userID = parseUser.objectId;
          
            
            commentObj.user = user;
            
            
            [commentsArray addObject:commentObj];
            
        }
        NSBlockOperation *operation  = [[NSBlockOperation alloc]init];
        [operation addExecutionBlock:^{
            completionBlock(commentsArray);
            
        }];
        [[NSOperationQueue mainQueue] addOperation:operation];
    }];
}

+ (void) uploadPhoto:(UIImage*)photo toObra:(Obra*)obra
{
    NSData* data = UIImageJPEGRepresentation(photo, 0.5f);
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
    PFObject* pfobra = [PFObject objectWithoutDataWithClassName:@"Obra" objectId:obra.obraId];
    PFObject* photoObj = [PFObject objectWithClassName:@"Photo"];
    photoObj[@"photo"] = imageFile;
    photoObj[@"obra"] = pfobra;
    [photoObj saveInBackground];
}

+ (void) updateObraLikesAndDislikes:(Obra *)obra
{
    PFQuery* postQuery = [PFQuery queryWithClassName:@"Obra"];
    [postQuery getObjectInBackgroundWithId:obra.obraId block:^(PFObject *object, NSError *error) {
        object[@"numeroLikes"] = [NSNumber numberWithInteger:obra.numeroLikes];
        object[@"numeroDislikes"] = [NSNumber numberWithInteger:obra.numeroDislikes];
        [object saveInBackground];
    }];
}

+ (void) getAllPicturesFromObra:(Obra *)obra withCompletionBlock:(void (^) (NSArray * )) completionBlock
{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    PFObject* pfobra = [PFObject objectWithoutDataWithClassName:@"Obra" objectId:obra.obraId];
    [query whereKey:@"obra" equalTo:pfobra];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if([objects count])
        {
            
            NSMutableArray *myPhotos = [[NSMutableArray alloc]init];
            for(int i = 0; i < [objects count] ; i++)
            {
                PFFile *myFile  = objects[i][@"photo"];
                [myFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    [myPhotos addObject:[UIImage imageWithData:data]];
                }];
                NSBlockOperation *operation  = [[NSBlockOperation alloc]init];
                [operation addExecutionBlock:^{
                    completionBlock(myPhotos);
                    
                }];
                [[NSOperationQueue mainQueue] addOperation:operation];
            }
        }
        else
        {
            NSBlockOperation *operation  = [[NSBlockOperation alloc]init];
            [operation addExecutionBlock:^{
                completionBlock(nil);
                
            }];
            [[NSOperationQueue mainQueue] addOperation:operation];
        }
    }];
}

+ (void) getOneAndOnlyOnePictureFromObra:(Obra *)obra withCompletionBlock:(void (^) (UIImage* )) completionBlock
{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    PFObject* pfobra = [PFObject objectWithoutDataWithClassName:@"Obra" objectId:obra.obraId];
    [query whereKey:@"obra" equalTo:pfobra];
    [query setLimit:1];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if([objects count])
        {
            PFFile *myFile  = objects[0][@"photo"];
            [myFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                NSBlockOperation *operation  = [[NSBlockOperation alloc]init];
                [operation addExecutionBlock:^{
                    UIImage *tmpImage = [UIImage imageWithData:data];
                    completionBlock(tmpImage);
                    
                }];
                [[NSOperationQueue mainQueue] addOperation:operation];
            }];
            
        }
    }];
}

+ (void) getObrasForUserLatitude:(double)userLatitude
                   userLongitude:(double)userLongitude
             withCompletionBlock:(void (^) (NSArray* )) completionBlock
{
    CGFloat kilometers = 1000;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Obra"];
    [query setLimit:1000];
    [query whereKey:@"location"
       nearGeoPoint:[PFGeoPoint geoPointWithLatitude: userLatitude
                                           longitude: userLongitude]
    withinKilometers:kilometers];
    [query includeKey:@"usuario"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *obrasArray = [[NSMutableArray alloc]init];
            for (PFObject *object in objects) {
                Obra * minhaObra = [[Obra alloc]init];
                minhaObra.obraId = object.objectId;
                PFUser *pfObraUsuario = object[@"usuario"];
                Usuario* obraUsuario = [[Usuario alloc]init];
                obraUsuario.userID = pfObraUsuario.objectId;
                obraUsuario.userName = pfObraUsuario.username;
                minhaObra.usuario = obraUsuario;
                
                minhaObra.titulo = object[@"titulo"];
                minhaObra.numeroDislikes = [object[@"numeroDislikes"] intValue];
                minhaObra.numeroLikes = [object[@"numeroLikes"] intValue];
                minhaObra.descricao = object[@"descricao"];
                minhaObra.lat = ((PFGeoPoint*)object[@"location"]).latitude;
                minhaObra.longi = ((PFGeoPoint*)object[@"location"]).longitude;
                [obrasArray addObject:minhaObra];
                NSBlockOperation *operation  = [[NSBlockOperation alloc]init];
                [operation addExecutionBlock:^{
                    completionBlock(obrasArray);
                    
                }];
                [[NSOperationQueue mainQueue] addOperation:operation];                
            }
        }
    }];
}

+ (void) getObrasMostRecentWithCompletionBlock:(void (^) (NSArray* )) completionBlock
{
    PFQuery *query = [PFQuery queryWithClassName:@"Obra"];
    [query setLimit:1000];
    [query addDescendingOrder:@"updatedAt"];
    [query includeKey:@"usuario"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *obrasArray = [[NSMutableArray alloc]init];
            for (PFObject *object in objects) {
                Obra * minhaObra = [[Obra alloc]init];
                minhaObra.obraId = object.objectId;
                PFUser *pfObraUsuario = object[@"usuario"];
                Usuario* obraUsuario = [[Usuario alloc]init];
                obraUsuario.userID = pfObraUsuario.objectId;
                obraUsuario.userName = pfObraUsuario.username;
                minhaObra.usuario = obraUsuario;
                
                minhaObra.titulo = object[@"titulo"];
                minhaObra.numeroDislikes = [object[@"numeroDislikes"] intValue];
                minhaObra.numeroLikes = [object[@"numeroLikes"] intValue];
                minhaObra.descricao = object[@"descricao"];
                minhaObra.lat = ((PFGeoPoint*)object[@"location"]).latitude;
                minhaObra.longi = ((PFGeoPoint*)object[@"location"]).longitude;
                [obrasArray addObject:minhaObra];
                NSBlockOperation *operation  = [[NSBlockOperation alloc]init];
                [operation addExecutionBlock:^{
                    completionBlock(obrasArray);
                }];
                [[NSOperationQueue mainQueue] addOperation:operation];
            }
        }
    }];
}

+ (Usuario *) getCurrentUser
{
    PFUser *pfuser = [PFUser currentUser];
    Usuario* currentUser = [[Usuario alloc]init];
    currentUser.userName = pfuser[@"username"];
    currentUser.userID = pfuser.objectId;
    return currentUser;
}

@end
