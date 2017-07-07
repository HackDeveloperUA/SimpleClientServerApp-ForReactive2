//
//  WorkerCell.h
//  SimpleClientServerApp-ForReactive
//
//  Created by Uber on 24/06/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainPhoto;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;

@end
