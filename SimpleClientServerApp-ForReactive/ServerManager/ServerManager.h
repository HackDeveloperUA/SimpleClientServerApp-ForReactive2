//
//  ServerManager.h
//  SimpleClientServerApp-ForReactive
//
//  Created by Uber on 23/06/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

// Model
#import "WorkerFullModel.h"
#import "WorkerShortModel.h"

@interface ServerManager : NSObject

+ (ServerManager*) sharedManager;


//----- Get Accounts login & password -----//
- (void) getAccountsData:(void(^)(NSDictionary* dictWithLoginAndPassword)) success
               onFailure:(void(^)(NSError* errorBlock,  NSInteger statusCode)) failure;

//----- Array Workers -----//
- (void) getListAllWorkers:(void(^)(NSArray* arrayWorkers)) success
                 onFailure:(void(^)(NSError* errorBlock, NSInteger statusCode)) failure;

//----- Worker -----//
- (void) getFullInfoByWorkers:(NSString *)link
                    onSuccess:(void(^)(WorkerFullModel* worker)) success
                    onFailure:(void(^)(NSError* errorBlock,  NSInteger statusCode)) failure;


//////////// ReactiveCocoa ///////////////

- (RACSignal*) getAccountsData;
- (RACSignal*) getListAllWorkers;
- (RACSignal*) getFullInfoByWorkers:(NSString *)link;

@end
