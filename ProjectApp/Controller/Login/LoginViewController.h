

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (retain,nonatomic)__block UIActivityIndicatorView *indicator;


- (IBAction)onLoginPressed:(id)sender;
- (IBAction)newRegistration:(id)sender;


@end
