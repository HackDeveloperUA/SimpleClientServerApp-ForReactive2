//
//  WorkerShortModel.h
//  SimpleClientServerApp-ForReactive
//
//  Created by Uber on 23/06/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEMMapping.h"

@interface WorkerShortModel : NSObject

@property (nonatomic, assign) NSInteger idNumber;

@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, strong) NSString* photoURL;
@property (nonatomic, strong) NSString* linkOnFullCV;


- (instancetype) initWithServerResponse:(NSDictionary*) responseObject;

+ (FEMMapping *)defaultMapping;

@end
