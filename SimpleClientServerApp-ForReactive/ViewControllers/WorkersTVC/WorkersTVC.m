//
//  WorkersTVC.m
//  SimpleClientServerApp-ForReactive
//
//  Created by Uber on 23/06/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "WorkersTVC.h"

@interface WorkersTVC ()

@property (strong, nonatomic) NSMutableArray* arrayWorkers;
@property (assign, nonatomic) BOOL loadingData;
@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation WorkersTVC




#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getListWorkersFromServer];
}


#pragma mark - Server

-(void) getListWorkersFromServer
{
    __weak UITableView   *weakTable = self.tableView;
    __weak typeof(self)   weakSelf  = self;
    __weak MBProgressHUD *weakHUD = self.HUD;
    
    ANDispatchBlockToMainQueue(^{
        weakTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [weakHUD show:YES];
        weakSelf.view.userInteractionEnabled = NO;
    });
    
    /*
    [[ServerManager sharedManager] getListAllWorkers:^(NSArray *arrayWorkers) {
        
        self.arrayWorkers = [NSMutableArray arrayWithArray:arrayWorkers];
        [self setupTableView];
    } onFailure:^(NSError *errorBlock, NSInteger statusCode) {
        NSLog(@"Error data- getListAllWorkers");
    }];
     */
    
    [[[ServerManager sharedManager] getListAllWorkers]
     subscribeNext:^(NSArray *arrayWorkers) {
         self.arrayWorkers = [NSMutableArray arrayWithArray:arrayWorkers];
         [self setupTableView];
    } error:^(NSError *error) {
        NSLog(@"getListAllWorkers error = %@",error);
    }];
}


- (void) setupTableView
{
    @weakify(self)
    ANDispatchBlockToMainQueue(^{
        @strongify(self)
        [self.tableView reloadData];
        [self.HUD hide:YES];
        __weak typeof(self)   weakSelf  = self;
        ANDispatchBlockAfter(0.35f, ^{
            weakSelf.view.userInteractionEnabled = YES;
        });
    });
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayWorkers count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DetailWorkerVC* detailVC = (DetailWorkerVC*)[storyboard instantiateViewControllerWithIdentifier:@"DetailWorkerVC"];
    WorkerShortModel* worker = self.arrayWorkers[indexPath.row];
    
    detailVC.linkOnFullCV = worker.linkOnFullCV;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"WorkerCell";
    
    WorkerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = (WorkerCell*)[[WorkerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableView helper methods

- (void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath
{
    __weak UITableViewCell  *weakCell = cell;
    
    ANDispatchBlockToBackgroundQueue(^{
        
        WorkerShortModel* worker = nil;
        if (self.arrayWorkers[indexPath.row])
        {
            worker = [self.arrayWorkers objectAtIndex:indexPath.row];
        }
        if (worker)
        {
            WorkerCell* workerCell = (WorkerCell*)weakCell;
            ANDispatchBlockToMainQueue(^{
                workerCell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",worker.firstName, worker.lastName];
                
                [workerCell.mainPhoto setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:worker.photoURL]]
                                            placeholderImage:nil
                                                     success:^(NSURLRequest* request, NSHTTPURLResponse*  response, UIImage* image) {
                                                         workerCell.mainPhoto.image = image;
                                                         workerCell.mainPhoto.layer.masksToBounds = YES;
                                                         workerCell.mainPhoto.layer.cornerRadius  = CGRectGetWidth(workerCell.mainPhoto.frame)/2;
                                                     } failure:^(NSURLRequest* request, NSHTTPURLResponse* response, NSError* error) {
                                                         
                                                     }];
            });
        }
    });
}

@end





