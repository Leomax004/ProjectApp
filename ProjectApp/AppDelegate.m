

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "AccountViewController.h"
#import "DashBoardViewController.h"


static NSString *AppId = @"layer:///apps/staging/159554c2-e6b1-11e5-a8da-b2063f182813";

#if TARGET_IPHONE_SIMULATOR

NSString *const LQSCurrentUserId = @"Simulator";
NSString *const LQSParticipantUserId = @"Device";

#else

NSString *const LQSCurrentUserId = @"Device";
NSString *const LQSParticipantUserId = @"Simulator";

#endif

NSString *const LQSParticipant2UserID = @"Dashboard";
NSString *const LQSCategoryIdentifier = @"category_lqs";
NSString *const LQSAcceptIdentifier = @"ACCEPT_IDENTIFIER";
NSString *const LQSIgnoreIdentifier = @"IGNORE_IDENTIFIER";



@interface AppDelegate ()<LYRClientDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.dashBoard = [[DashBoardViewController alloc]initWithNibName:@"DashBoardViewController" bundle:nil];
    UINavigationController *dashNav = [[UINavigationController alloc]initWithRootViewController:self.dashBoard];
    
    dashNav.navigationBar.translucent = NO;
  
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL isLoggedin = [defaults boolForKey:@"isLoggedin"];
    
    if(isLoggedin)
    {
        //[self addTabbarController];
        
        [self.window setRootViewController:dashNav];
        
    }
    else
    {
        [self addLoginviewController];
    }
    [self.window makeKeyAndVisible];

    [self setupLayer];
    return YES;
}

-(void)addLoginviewController
{
    LoginViewController *loginview = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    
    UINavigationController *loginnav = [[UINavigationController alloc]initWithRootViewController:loginview];
    
    [self.window setRootViewController:loginnav];
}
-(void)dashBarController
{
    self.dashBoard = [[DashBoardViewController alloc]initWithNibName:@"DashBoardViewController" bundle:nil];
    UINavigationController *dashNav = [[UINavigationController alloc]initWithRootViewController:self.dashBoard];
    
    dashNav.navigationBar.translucent = NO;
    [self.window setRootViewController:dashNav];

}
-(void)addTabbarController{
    
    
    HomeViewController *homeView = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    
    MessageViewController *messView = [[MessageViewController alloc]initWithNibName:@"MessageViewController" bundle:nil];
    
    AccountViewController *accView = [[AccountViewController alloc]initWithNibName:@"AccountViewController" bundle:nil];
    
    UINavigationController *accountsnav = [[UINavigationController alloc]initWithRootViewController:accView];
    
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:homeView];
    
    UINavigationController *messagenav = [[UINavigationController alloc ]initWithRootViewController:messView];
    
    
    homeNav.navigationBar.translucent = NO;
    
    messagenav.navigationBar.translucent = NO;
    
    homeNav.tabBarItem.image = [UIImage imageNamed:@"loa"];
    
    accountsnav.tabBarItem.image = [UIImage imageNamed:@"logout"];
    
    messagenav.tabBarItem.image = [UIImage imageNamed:@"chat"];
    
    UITabBarController *tabbar = [[UITabBarController alloc]init];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter" size:14.0f]
                                                        } forState:UIControlStateNormal];
    
    tabbar.tabBar.barStyle = UIBarStyleBlack;
    
    tabbar.viewControllers = [NSArray arrayWithObjects:homeNav,messagenav,accountsnav,nil];
    
    
    [self.window setRootViewController:tabbar];
    
    
}

#pragma mark - setupLayer


-(void)setupLayer
{
    
    NSURL *appId = [NSURL URLWithString:AppId];
    self.layerClient = [LYRClient clientWithAppID:appId];
    [self.layerClient connectWithCompletion:^(BOOL success, NSError * _Nullable error) {
        
        if(!success)
        {
            NSLog(@"Failed to connect the layer:%@",error);
        }
        else
        {
            NSLog(@"sucessfully connected with layer");
            //NSString *userIdString = @"Device";
            [self authenticateLayerWithUserID:LQSCurrentUserId completion:^(BOOL success, NSError *error) {
                
                if (!success) {
                    NSLog(@"Failed Authenticating Layer Client with error:%@", error);
                }
                else
                {
                    NSLog(@"Sucessfully Authenticating client");
                }
            }];
        }
        
    }];

}


-(void)authenticateLayerWithUserID:(NSString *)userID completion:(void (^)(BOOL success, NSError * error))completion
{
    
    if(self.layerClient.authenticatedUserID)
    {
        if ([self.layerClient.authenticatedUserID isEqualToString:userID]) {
            NSLog(@"Layer Authenticate as User:%@",self.layerClient.authenticatedUserID);
            if(completion) completion(YES,nil);
            return;
            
        }
        else
        {
            [self.layerClient deauthenticateWithCompletion:^(BOOL success, NSError * _Nullable error) {
                if(!error)
                {
                    
                    [self authenticationTokenWithUserId:userID completion:^(BOOL success, NSError *error) {
                        if (completion){
                            completion(success, error);
                        }
                    }];
                }
                else
                {
                    if (completion){
                        completion(NO, error);
                    }
                }
                
            }];
        }
        
    }
    else
    {
        [self authenticationTokenWithUserId:userID completion:^(BOOL success, NSError *error) {
            if(completion)
            {
                completion(success,error);
            }
        }];
    }
    
    
    
}

- (void)requestIdentityTokenForUserID:(NSString *)userID appID:(NSString *)appID nonce:(NSString *)nonce completion:(void(^)(NSString *identityToken, NSError *error))completion
{
    
    
    NSParameterAssert(userID);
    NSParameterAssert(appID);
    NSParameterAssert(nonce);
    NSParameterAssert(completion);
    
    NSURL *identityTokenURL = [NSURL URLWithString:@"https://layer-identity-provider.herokuapp.com/identity_tokens"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:identityTokenURL];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSDictionary *parameters = @{ @"app_id": appID, @"user_id": userID, @"nonce": nonce };
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    request.HTTPBody = requestBody;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        // Deserialize the response
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if(![responseObject valueForKey:@"error"])
        {
            NSString *identityToken = responseObject[@"identity_token"];
            completion(identityToken, nil);
        }
        else
        {
            NSString *domain = @"layer-identity-provider.herokuapp.com";
            NSInteger code = [responseObject[@"status"] integerValue];
            NSDictionary *userInfo =
            @{
              NSLocalizedDescriptionKey: @"Layer Identity Provider Returned an Error.",
              NSLocalizedRecoverySuggestionErrorKey: @"There may be a problem with your APPID."
              };
            
            NSError *error = [[NSError alloc] initWithDomain:domain code:code userInfo:userInfo];
            completion(nil, error);
        }
        
    }]
     resume];
}




- (void)authenticationTokenWithUserId:(NSString *)userID completion:(void (^)(BOOL success, NSError* error))completion{
    {
        /*
         * 1. Request an authentication Nonce from Layer
         */
        [self.layerClient requestAuthenticationNonceWithCompletion:^(NSString *nonce, NSError *error) {
            if (!nonce) {
                if (completion) {
                    completion(NO, error);
                }
                return;
            }
            
            /*
             * 2. Acquire identity Token from Layer Identity Service
             */
            [self requestIdentityTokenForUserID:userID appID:[self.layerClient.appID absoluteString] nonce:nonce completion:^(NSString *identityToken, NSError *error) {
                if (!identityToken) {
                    if (completion) {
                        completion(NO, error);
                    }
                    return;
                }
                
                /*
                 * 3. Submit identity token to Layer for validation
                 */
                [self.layerClient authenticateWithIdentityToken:identityToken completion:^(NSString *authenticatedUserID, NSError *error) {
                    if (authenticatedUserID) {
                        if (completion) {
                            completion(YES, nil);
                        }
                        NSLog(@"Layer Authenticated as User: %@", authenticatedUserID);
                    } else {
                        completion(NO, error);
                    }
                }];
            }];
        }];
    }
}
#pragma - mark LYRClientDelegate Delegate Methods

- (void)layerClient:(LYRClient *)client didReceiveAuthenticationChallengeWithNonce:(NSString *)nonce
{
    NSLog(@"Layer Client did recieve authentication challenge with nonce: %@", nonce);
}

- (void)layerClient:(LYRClient *)client didAuthenticateAsUserID:(NSString *)userID
{
    NSLog(@"Layer Client did recieve authentication nonce");
}

- (void)layerClientDidDeauthenticate:(LYRClient *)client
{
    NSLog(@"Layer Client did deauthenticate");
}

- (void)layerClient:(LYRClient *)client didFinishSynchronizationWithChanges:(NSArray *)changes
{
    NSLog(@"Layer Client did finish synchronization");
}

- (void)layerClient:(LYRClient *)client didFailSynchronizationWithError:(NSError *)error
{
    NSLog(@"Layer Client did fail synchronization with error: %@", error);
}

- (void)layerClient:(LYRClient *)client willAttemptToConnect:(NSUInteger)attemptNumber afterDelay:(NSTimeInterval)delayInterval maximumNumberOfAttempts:(NSUInteger)attemptLimit
{
    NSLog(@"Layer Client will attempt to connect");
}

- (void)layerClientDidConnect:(LYRClient *)client
{
    NSLog(@"Layer Client did connect");
}

- (void)layerClient:(LYRClient *)client didLoseConnectionWithError:(NSError *)error
{
    NSLog(@"Layer Client did lose connection with error: %@", error);
}

- (void)layerClientDidDisconnect:(LYRClient *)client
{
    NSLog(@"Layer Client did disconnect");
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
