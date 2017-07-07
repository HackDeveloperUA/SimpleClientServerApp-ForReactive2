//
//  DetailWorkerVC.h
//  SimpleClientServerApp-ForReactive
//
//  Created by Uber on 23/06/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import <UIKit/UIKit.h>

// Fraemworks
#import "ANHelperFunctions.h"
#import "MBProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import <NYTPhotoViewer/NYTPhotosViewController.h>


// ServerManager
#import "ServerManager.h"

//Model
#import "WorkerFullModel.h"
#import "PhotoModel.h"


@interface DetailWorkerVC : UIViewController

@property (nonatomic, strong) NSString* linkOnFullCV;

@end
