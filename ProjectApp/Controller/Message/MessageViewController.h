

#import <UIKit/UIKit.h>
#import <LayerKit/LayerKit.h>
#import "Information.h"
@interface MessageViewController : UIViewController

@property (nonatomic) LYRClient *layerClient;


@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextView;
- (IBAction)messageSend:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;

@end
