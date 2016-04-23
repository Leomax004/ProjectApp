

#import "RegistrationViewController.h"
#import "AFNetworking.h"
#import "LoginViewController.h"
#import "Constant.h"



@interface RegistrationViewController ()



@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    
    //[self.navigationController setNavigationBarHidden:NO];
    
    [super viewDidLoad];
    
   
   

   
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];

}
/*
NSString *urlstring = [NSString stringWithFormat:@"%@",Url];

NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

 NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];

 [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
[request setHTTPMethod:@"Get"];

AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

NSURLSessionDataTask *data = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response , id responseObject , NSError *error)
*/


-(void)postDataToServer
{
    NSString *urlstring = [NSString stringWithFormat:@"%@",ParseUrl];
    
    NSURL *url = [NSURL URLWithString:[urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    [request addValue:@"uz8IIai5lKZaXWSlFcwvXq25cuwP1zrSnw3NUj5i" forHTTPHeaderField:@"X-Parse-Application-Id"];

    [request addValue:@"7It7MauoR3iGXVj9FMXIVqslonpTWKC8XeQUnn1h" forHTTPHeaderField:@"X-Parse-REST-API-Key"];

    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];

    NSMutableDictionary *postRequestDictinary = [[NSMutableDictionary alloc]init];
    
    postRequestDictinary[@"Name"] = self.emailId.text;
    
    postRequestDictinary[@"Password"] = self.password.text;
    
    postRequestDictinary[@"Username"] = self.userName.text;
    
    NSError *jsonError;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postRequestDictinary options:0 error:&jsonError];
    
    NSLog(@"json data--->%@",jsonData);
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSData *jsonDataEncoded = [jsonString dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    
    [request setHTTPBody:jsonDataEncoded];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *data = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response  , id responseObject , NSError *error)
    {
        NSLog(@"response--->%@",responseObject);
        
        NSLog(@"denbf");
        if(!error)
        {
            NSArray *results = [responseObject objectForKey:@"results"];
            
            NSLog(@"%@",results);
            
        }
        else
        {
            NSLog(@"Error:%@",error);
        }
        
        
    }];
    
    [data resume];
     
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Submit:(id)sender
{
     LoginViewController *loginView = [[LoginViewController alloc]init];
    // self.str = @"hello";
    
    //self.userName = self.emailId;
    
    //self.passKey = self.password;
    
    if([self.emailId.text isEqualToString:@"" ]|| [self.password.text isEqualToString:@""] || [self.userName.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please Filled all Details" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];

    }
    else
    {
       [self postDataToServer];
    
       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Thank You" message:@"Account created sucessfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
       [alert show];
    
       [self presentViewController:loginView animated:YES completion:nil];
    
       self.emailId.text = @"";
     
       self.password.text = @"";
        
       self.userName.text = @"";
    }
}
@end
