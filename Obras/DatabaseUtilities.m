//
//  DatabaseUtilities.m
//  Obras
//
//  Created by Luis Fernando Antonioli on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import "DatabaseUtilities.h"


@implementation DatabaseUtilities

//+ (NSArray* ) getObras
//{
//    
//    Obra * o1 = [[Obra   alloc ] init];
//    o1.titulo = @"ic";
//    o1.latitude = -22.814558;
//    o1.longitude = -47.063456;
//    o1.descricao = @"a,ansfj,sandfsa,jnafdjjesbkjashjgfjdsfjkdsajdfgasjgdfjhasdgfhjgsfjhsgjdhfgjsadhgfhjdsgfjhgasdjhfghjasd o1";
//    UIImage *img = [UIImage imageNamed: @"default-image.png"];
//    [[o1 pictures] addObject: img];
//    img = [UIImage imageNamed: @"Obras.jpg"];
//    [[o1 pictures] addObject: img];
//    Usuario *u = [[Usuario alloc] init];
//    u.userName = @"ssssuuuuu";
//    o1.usuario = u;
//    
//    Comentario *c1 = [[Comentario alloc] init];
//    c1.comment = @"qwqwqwqwqwqwqwq";
//    Comentario *c2 = [[Comentario alloc] init];
//    c2.comment = @"qwqwqwqwqwqwqwqmsdfbjskdhfkjsanvdmnfgndjfgdjkhfjgdkfgkdhfkgdkjfhgdfkjgkjdfhgjfhdfjgfkjdfhgkjdfhgdkfjhgkjdfhkgdkjfgjkdhkfhgdkjfhgjfdhkgfdjkgfhjdfhgdkj464655555555555555553dhkjfhasdfhasdjfhadsjfhksahfjk";
//    Comentario *c3 = [[Comentario alloc] init];
//    c3.comment = @"qwqwqwqwqwqwqwqkhjsdgfhksadhkfgasdjfghjasdgfhj0000";
//    [[c1 user] setUserName:@"asdfsdfsdasdfsfs222s"];
//    [[c2 user ] setUserName:@"asdfsdfsd221111 eas"];
//    [[c3 user] setUserName:@"asdfsdfsdas"];
//    [[o1 comentarios] addObject: c1];
//    [[o1 comentarios] addObject: c2];
//    [[o1 comentarios] addObject: c3];
//    
//    
//    Obra * o2 = [[Obra   alloc ] init];
//    o2.titulo = @"bara";
//    o2.latitude = -22.813578;
//    o2.longitude = -47.063486;
//    o2.descricao = @"asfsafsasfsadadsasdfasdasdasdhkbdSahbdjhsfbdjhbdshjdfbjhdsbfdhjbdsajhfbajsdhbfjkhsbnxzmnbcjznbchj o2";
//    NSArray * array = @[o1,o2];
//    
//    return array ;
//    
//    
//}


+ (void) getObrasForUserLatitude:(float)userLatitude userLongitude:(float)userLongitude withCompletionBlock:(void (^) (NSArray* )) completionBlock
{
    
    
    CGFloat kilometers = 10;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Obra"];
    [query setLimit:1000];
    [query whereKey:@"location"
       nearGeoPoint:[PFGeoPoint geoPointWithLatitude:userLatitude
                                           longitude:userLongitude]
   withinKilometers:kilometers];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *obrasArray = [[NSMutableArray alloc]init];
            for (PFObject *object in objects) {
                Obra * minhaObra = [[Obra alloc]init];
                minhaObra.titulo = object[@"titulo"];
                minhaObra.descricao = object[@"descricao"];
                minhaObra.latitude = ((PFGeoPoint*)object[@"location"]).latitude;
                minhaObra.longitude = ((PFGeoPoint*)object[@"location"]).longitude;
                
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


//
//+ (void) uploadPost:(Obra *)obra
//{
//    PFObject* minhaObra = [PFObject objectWithClassName:@"Obra"];
//    minhaObra[@"author"]= [PFObject objectWithoutDataWithClassName:@"_User" objectId:obra.usuario.userID];
//    if(obra.titulo)
//    {
//                [minhaObra setValue:minhaObra.titulo forKey:@"titulo"];
//    }
//    else
//    {
//        [myPost setValue:@"" forKey:@"title"];
//    }
//    if(post.body)
//    {
//        myPost[@"body"] = post.body;
//    }
//    else
//    {
//        myPost[@"body"] = @"";
//    }
//    // if(post.positiveRatings)
//    // {
//    myPost[@"positiveRatings"] = [NSNumber numberWithInt:post.positiveRatings];
//    // }
//    // else
//    // {
//    //     myPost[@"positiveRatings"] = 0;
//    // }
//    // if(post.negativeRatings)
//    // {
//    myPost[@"negativeRatings"] = [NSNumber numberWithInt:post.negativeRatings];
//    // }
//    // else
//    // {
//    //     myPost[@"negativeRatings"] = 0;
//    // }
//    // if(post.numberOfViews)
//    // {
//    myPost[@"numberOfViews"] = [NSNumber numberWithInt:post.numberOfViews];
//    // }
//    // else
//    // {
//    //     myPost[@"numberOfViews"] = 0;
//    // }
//    if(post.address)
//    {
//        myPost[@"address"] = post.address;
//    }
//    else
//    {
//        myPost[@"address"] = @"";
//    }
//    if(post.website)
//    {
//        myPost[@"website"] = post.website;
//    }
//    else
//    {
//        myPost[@"website"] = @"";
//    }
//    if(post.pictureURL)
//    {
//        myPost[@"pictureURL"] = post.pictureURL;
//    }
//    else
//    {
//        myPost[@"pictureURL"] = @"";
//    }
//    myPost[@"category"] = [NSNumber numberWithInt:post.category] ;
//    myPost[@"price"]    = [NSNumber numberWithFloat:post.price];
//    
//    
//    
//    
//    
//    [myPost saveInBackground];
//}
//

@end
