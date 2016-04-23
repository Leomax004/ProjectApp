

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "RegistrationViewController.h"
#import "AFNetworking.h"
#import "Constant.h"
#import "Information.h"

@interface LoginViewController ()


@property (strong,nonatomic)NSMutableDictionary *userInfoDic;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //mbProgressIndicator = [[MBProgressHUD alloc]initWithView:self.view];
   // mbProgressIndicator.labelText = @"Loading...";
   // [self.view addSubview:mbProgressIndicator];
    [self.imageview setImage:[UIImage imageNamed:@"cover"]];
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.frame=CGRectMake(0.0, 0.0, 50.0, 50.0);
    self.indicator.center = self.view.center;
    [self.view addSubview:self.indicator];
    [self.indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    self.indicator.center = self.view.center;
    
}

/*
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
    {
        self.title = @"Smure";
    }
    
    return self;
}
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




+(void)getDataFromServer:(NSString *)userName withPassword:(NSString *)Password
{
    
    NSString *urlstring = [NSString stringWithFormat:@"%@",ParseUrl];
    
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    [request addValue:@"uz8IIai5lKZaXWSlFcwvXq25cuwP1zrSnw3NUj5i" forHTTPHeaderField:@"X-Parse-Application-Id"];
    
    [request addValue:@"7It7MauoR3iGXVj9FMXIVqslonpTWKC8XeQUnn1h" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"GET"];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *data = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response , id responseObject , NSError *error)
    {
        BOOL checked;
        
        if(!error)
        {
            NSArray *results = [responseObject objectForKey:@"results"];
            
            NSLog(@"%lu",(unsigned long)results.count);
            
            
            for( int i = 0; i < [results count]; i++ )
           {
                NSDictionary *dic = [results objectAtIndex:i];
                NSString *Name = [dic objectForKey:@"Name"];
                NSString *password = [dic objectForKey:@"Password"];
               if([Name isEqualToString:userName] && [password isEqualToString:Password])
               {
                   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                   [defaults setBool:YES forKey:@"isLoggedin"];
                   [defaults synchronize];
                    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                   [appDelegate dashBarController];
                   
                   checked = TRUE;
                   break;
               }
               
           }
            NSLog(@"user name :%@",userName);
            if(!checked)
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please be Genuine incorrect username and password" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
               // LoginViewController *stopSpinner = [[LoginViewController alloc]init];
                [alert show];
            
               // [stopSpinner.indicator stopAnimating];
               
            }

        }
                                      
            }];
    
    [data resume];

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
    return YES;
}

- (IBAction)onLoginPressed:(id)sender
{
   
    [self.indicator startAnimating];
    if([self.username.text isEqualToString:@""])
    {
        [self.indicator stopAnimating];
        return;
    }
    else if ([self.password.text isEqualToString:@""])
    {
        [self.indicator stopAnimating];
        return;
    }
    else
    {
        [self.username resignFirstResponder ];
        [self.password resignFirstResponder];
        [LoginViewController getDataFromServer:self.username.text withPassword:self.password.text];
        
    }
    
}

- (IBAction)newRegistration:(id)sender
{
    RegistrationViewController *registerView = [[RegistrationViewController alloc]initWithNibName:@"RegistrationViewController" bundle:nil];
    
    [self.navigationController pushViewController:registerView animated:YES];
    
}
@end
