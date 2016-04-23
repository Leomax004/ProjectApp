
#import <UIKit/UIKit.h>
#import "DashBoardViewController.h"
#import <LayerKit/LayerKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *dashBoard;

-(void)addTabbarController;
-(void)addLoginviewController;
-(void)setupLayer;
-(void)dashBarController;
@property (nonatomic)LYRClient *layerClient;


@end

