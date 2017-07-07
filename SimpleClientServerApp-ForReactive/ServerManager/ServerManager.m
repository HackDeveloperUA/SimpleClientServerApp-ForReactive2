//
//  ServerManager.m
//  SimpleClientServerApp-ForReactive
//
//  Created by Uber on 23/06/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "ServerManager.h"
#import "FEMDeserializer.h"


@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) dispatch_queue_t requestQueue;

@end


@implementation ServerManager

+ (ServerManager*) sharedManager {
    
    static ServerManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.requestQueue = dispatch_queue_create("SimpleClientServerApp-ForReactive.request", DISPATCH_QUEUE_PRIORITY_DEFAULT);
        
        self.manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/json",@"text/html", nil];
    }
    return self;
}


//----- Get Accounts login & password -----//
- (void) getAccountsData:(void(^)(NSDictionary* dictWithLoginAndPassword)) success
               onFailure:(void(^)(NSError* errorBlock,  NSInteger statusCode)) failure {
    
    
    [self.manager GET:@"https://raw.githubusercontent.com/HackDeveloperUA/SimpleClientServerApp/master/SimpleClientServerApp-ForReactive/JSON/accountsData.json"
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask* task, NSDictionary* responseObject) {
                  
                  NSDictionary *json = (NSDictionary *)responseObject[@"accounts"];
                  success(json);
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                  failure(error, error.code);
              }];
}


- (void) getListAllWorkers:(void(^)(NSArray* arrayWorkers)) success
                 onFailure:(void(^)(NSError* errorBlock, NSInteger statusCode)) failure {
    
    
    [self.manager GET:@"https://raw.githubusercontent.com/HackDeveloperUA/SimpleClientServerApp/master/SimpleClientServerApp-ForReactive/JSON/workersData.json"
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask *  task, NSDictionary*   responseObject) {
                  
                  NSDictionary *json = (NSDictionary *)responseObject;
                  if (json) {
                      success([self parseWithMapping:json andClassModel:[WorkerShortModel class]]);
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                      failure(error, error.code);
              }];
}



//----- Worker -----//
- (void) getFullInfoByWorkers:(NSString *)link
                    onSuccess:(void(^)(WorkerFullModel* worker)) success
                    onFailure:(void(^)(NSError* errorBlock,  NSInteger statusCode)) failure {
    
    [self.manager GET:link
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  NSDictionary *json = (NSDictionary *)responseObject;
                  if (json) {
                      success([self parseWithMapping:json andClassModel:[WorkerFullModel class]]);
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
                      failure(error, error.code);
              }];
 }




//////////// ReactiveCocoa ///////////////

- (RACSignal*) getAccountsData
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        //@weakify(self)
        
        [self.manager GET:@"https://raw.githubusercontent.com/HackDeveloperUA/SimpleClientServerApp/master/SimpleClientServerApp-ForReactive/JSON/accountsData.json"
               parameters:nil
                 progress:nil
                  success:^(NSURLSessionDataTask* task, NSDictionary* responseObject) {

                      NSDictionary *json = (NSDictionary *)responseObject[@"accounts"];
                      
                      [subscriber sendNext:json];
                      [subscriber sendCompleted];
                  }
                  failure:^(NSURLSessionDataTask* task, NSError*  error) {
                      
                      [subscriber sendError:error];
                  }];
        return nil;
    }] deliverOn:[RACScheduler scheduler]];
}



- (RACSignal*) getListAllWorkers
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
       
        [self.manager GET:@"https://raw.githubusercontent.com/HackDeveloperUA/SimpleClientServerApp/master/SimpleClientServerApp-ForReactive/JSON/workersData.json"
               parameters:nil
                 progress:nil
                  success:^(NSURLSessionDataTask *  task, NSDictionary*   responseObject) {
                      
                      NSDictionary *json = (NSDictionary *)responseObject;
                      if (json) {
                          NSArray* list = [self parseWithMapping:json andClassModel:[WorkerShortModel class]];
                          [subscriber sendNext:list];
                          [subscriber sendCompleted];
                      }
                  }
                  failure:^(NSURLSessionDataTask* task, NSError* error) {
                      
                     // failure(error, error.code);
                      [subscriber sendError:error];
                  }];
        
        return nil;
    }] deliverOn:[RACScheduler scheduler]];
}



- (RACSignal*) getFullInfoByWorkers:(NSString *)link
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
    [self.manager GET:link
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask* task, id responseObject) {
                  
                  NSDictionary *json = (NSDictionary *)responseObject;
                  if (json) {
                      WorkerFullModel* worker = [self parseWithMapping:json andClassModel:[WorkerFullModel class]];
                      [subscriber sendNext:worker];
                      [subscriber sendCompleted];
                  }
              }
              failure:^(NSURLSessionDataTask* task, NSError* error) {
                        [subscriber sendError:error];
              }];
        return nil;
    }] deliverOn:[RACScheduler scheduler]];
}







#pragma mark - Helpers Method

- (id) parseWithMapping:(NSDictionary*) responDict andClassModel:(Class) modelClass {
    
    if ([modelClass isSubclassOfClass:[WorkerShortModel class]]) {
        FEMMapping* objectMapping = [WorkerShortModel defaultMapping];
        NSArray*    modelsArray   = [FEMDeserializer collectionFromRepresentation:responDict[@"workers"] mapping:objectMapping];
        return modelsArray;
    }
    
    if ([modelClass isSubclassOfClass:[WorkerFullModel class]]) {
        FEMMapping *mapping     = [WorkerFullModel defaultMapping];
        WorkerFullModel *worker = [FEMDeserializer objectFromRepresentation:responDict mapping: mapping];
        return worker;
    }
 return @"Not found Classes Model";
}
                                    
                                    
@end
