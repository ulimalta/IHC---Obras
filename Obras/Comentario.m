//
//  Comentario.m
//  Obras
//
//  Created by Luis Fernando Antonioli on 30/05/14.
//  Copyright (c) 2014 Ulisses Malta Santos. All rights reserved.
//

#import "Comentario.h"

@implementation Comentario

- (id)init
{
    self = [super init];
    if (self) {
        self.user = [[Usuario alloc] init];
        NSLocale* currentLocale = [NSLocale currentLocale];
        [[NSDate date] descriptionWithLocale:currentLocale];
        NSDateFormatter *DateFormatter = [[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"dd/MM/yyyy hh:mm:ss"];
        self.postDate = [DateFormatter stringFromDate:[NSDate date]];
    }
    return self;
}

@end
