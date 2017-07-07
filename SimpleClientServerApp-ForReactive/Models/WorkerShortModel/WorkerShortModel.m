//
//  WorkerShortModel.m
//  SimpleClientServerApp-ForReactive
//
//  Created by Uber on 23/06/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "WorkerShortModel.h"

@implementation WorkerShortModel




-(instancetype) initWithServerResponse:(NSDictionary*) responseObject{
    
    self = [super init];
    if (self) {
        
        
        self.firstName         = [responseObject objectForKey:@"firstName"];
        self.lastName          = [responseObject objectForKey:@"lastName"];
        self.photoURL          = [responseObject objectForKey:@"photoURL"];
        self.linkOnFullCV      = [responseObject objectForKey:@"linkOnFullCV"];
        
        self.idNumber = [[responseObject objectForKey:@"id"] integerValue];
    }
    
    return self;
}

#pragma mark - Mapping

+ (FEMMapping *) defaultMapping {
    FEMMapping* mapping = [[FEMMapping alloc] initWithObjectClass:[WorkerShortModel class]];
    
    // property from nsobject : keypath from json
    [mapping addAttributesFromDictionary:@{ @"firstName"    : @"firstName",
                                            @"lastName"     : @"lastName",
                                            @"photoURL"     : @"photoURL",
                                            @"linkOnFullCV" : @"linkOnFullCV",
                                            @"idNumber"     : @"id"
                                            }];
    return mapping;
}

@end
