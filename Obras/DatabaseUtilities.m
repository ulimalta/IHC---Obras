//
//  DatabaseUtilities.m
//  Obras
//
//  Created by Luis Fernando Antonioli on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import "DatabaseUtilities.h"
#import <Parse/Parse.h>
#import "Obra.h"

@implementation DatabaseUtilities


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
