//
//  LoginTVC.m
//  SimpleClientServerApp-ForReactive
//
//  Created by Uber on 23/06/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "LoginTVC.h"

@interface LoginTVC ()

@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSDictionary* accountData;

// UI
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;

@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *fogotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *createAppleIdButton;

@property (weak, nonatomic) IBOutlet UIView *grayView;
@end

@implementation LoginTVC


#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetupController];
 
     // "admin"    : "12345",


    /*
      Комбинируем два сигнала из loginTextField & passwordTextField
      Получаем тюпл, разархивируем его.
     
      Если больше трех символов и там и там
      тогда делаем кнопку активной и меняем фон.
    */
    
    @weakify(self);
    [[RACSignal combineLatest:@[self.loginTextField.rac_textSignal,
                                self.passwordTextField.rac_textSignal]]
     subscribeNext:^(RACTuple *tuple) {
        RACTupleUnpack(NSString* login, NSString* password) = tuple;
        //NSLog(@"login =%@ password =%@ ",login,password);
     
         @strongify(self);
         if(login.length > 3 && password.length > 3){
             self.signInButton.enabled = YES;
             self.signInButton.backgroundColor = [UIColor blueColor];
         }else {
             self.signInButton.enabled = NO;
             self.signInButton.backgroundColor = [UIColor redColor];
         }
    }];

    
    self.signInButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"rac_command");
        
        @strongify(self);
        ANDispatchBlockToMainQueue(^{
            [self.HUD show:YES];
            self.view.userInteractionEnabled = NO;
        });
        
        if (!self.accountData) {
            [self getAccountsData];
        } else {
            [self checkAccountsData];
        }
        
        return [RACSignal empty];
    }];
}


#pragma mark - Server

- (void) getAccountsData
{
    [[[ServerManager sharedManager] getAccountsData]
     subscribeNext:^(NSDictionary* response) {
         self.accountData = [NSDictionary dictionaryWithDictionary:response];
         [self checkAccountsData];
     }error:^(NSError *error) {
         NSLog(@"getAccountsData error = %@",error);
     }];
}


#pragma mark - Action


- (void) checkAccountsData {
    
    @weakify(self);
    ANDispatchBlockToMainQueue(^{
        @strongify(self);
        [self.HUD show:NO];
        self.view.userInteractionEnabled = YES;
        
        if ([[self.accountData valueForKey:self.loginTextField.text] isEqualToString:self.passwordTextField.text])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController* navContr = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"NavWorkersTVC"];
            [self presentViewController:navContr animated:YES completion:nil];
            
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка"
                                                                           message:@"Логин или пароль не верны"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"OK"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:nil];
            [alert addAction:otherAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    });

}

#pragma mark - Untils

-(void) initialSetupController
{
    self.mainImage.layer.masksToBounds = YES;
    self.mainImage.layer.cornerRadius  = 5;
    
    self.grayView.layer.masksToBounds = YES;
    self.grayView.layer.cornerRadius  = 5;
    
    self.signInButton.layer.masksToBounds = YES;
    self.signInButton.layer.cornerRadius  = 5;
    
    self.createAppleIdButton.layer.masksToBounds = YES;
    self.createAppleIdButton.layer.cornerRadius  = 5;
    
    
    self.signInButton.backgroundColor = [UIColor redColor];
    self.signInButton.enabled = NO;
    self.tableView.allowsSelection = NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end






















