//
//  DetailWorkerVC.m
//  SimpleClientServerApp-ForReactive
//
//  Created by Uber on 23/06/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "DetailWorkerVC.h"

@interface DetailWorkerVC () 

// UI
@property (weak, nonatomic) IBOutlet UIImageView *mainPhoto;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *thePostLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;

@property (strong, nonatomic) WorkerFullModel* detailWorker;
@end

@implementation DetailWorkerVC

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDetailInfoWorkerFromServer];
    
}

#pragma mark - Server

-(void) getDetailInfoWorkerFromServer
{
    [[[ServerManager sharedManager] getFullInfoByWorkers:self.linkOnFullCV]
     subscribeNext:^(WorkerFullModel *worker) {
         self.detailWorker = worker;
         [self setupController];
    }error:^(NSError *error) {
        NSLog(@"getFullInfoByWorkers error= %@",error);
    }];
}


#pragma mark - Helpers Methods

- (void) setupController {
    
    [self.mainPhoto setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailWorker.photoURL]]
                          placeholderImage:nil
                                   success:^(NSURLRequest* request, NSHTTPURLResponse*  response, UIImage* image) {
                                       self.mainPhoto.image = image;
                                       self.mainPhoto.layer.masksToBounds = YES;
                                       self.mainPhoto.layer.cornerRadius  = CGRectGetWidth(self.mainPhoto.frame)/2;
                                       
                                       UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                                       tapRecognizer.numberOfTapsRequired = 1;
                                       [self.mainPhoto addGestureRecognizer:tapRecognizer];
                                       
                                   } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                       NSLog(@"self.mainPhoto setImageWithURLRequest error=%@",error);
                                   }];
    
    self.firstNameLabel.text = [NSString stringWithFormat:@"%@ %@",self.detailWorker.firstName, self.detailWorker.lastName];
    self.thePostLabel.text = self.detailWorker.thePost;
    self.mainTextLabel.text = self.detailWorker.mainText;
}

@end
