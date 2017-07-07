//
//  WorkerFullModel.m
//  SimpleClientServerApp-ForReactive
//
//  Created by Uber on 23/06/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "WorkerFullModel.h"

@implementation WorkerFullModel


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject{
    
    self = [super init];
    if (self) {
        
        
        self.firstName    = [responseObject objectForKey:@"firstName"];
        self.lastName     = [responseObject objectForKey:@"lastName"];
        self.photoURL     = [responseObject objectForKey:@"photoURL"];

        self.thePost      = [responseObject objectForKey:@"thePost"];
        self.mainText     = [responseObject objectForKey:@"mainText"];

        self.idNumber = [[responseObject objectForKey:@"id"] integerValue];
    }
    
    return self;
}

#pragma mark - Mapping

+ (FEMMapping *) defaultMapping {
    FEMMapping* mapping = [[FEMMapping alloc] initWithObjectClass:[WorkerFullModel class]];
    
    // property from nsobject : keypath from json
    [mapping addAttributesFromDictionary:@{ @"firstName"    : @"firstName",
                                            @"lastName"     : @"lastName",
                                            @"photoURL"     : @"photoURL",
                                            @"thePost"      : @"thePost",
                                            @"mainText"     : @"mainText",
                                            @"idNumber"     : @"id"
                                            }];
    return mapping;
}


@end
