//
//  RegistrationViewController.h
//  Tab_bar_using_xib
//
//  Created by Ceino on 13/02/16.
//  Copyright © 2016 CEINO TECHNOLOGY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailId;

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *userName;

- (IBAction)Submit:(id)sender;
-(void)postDataToServer;
@end
