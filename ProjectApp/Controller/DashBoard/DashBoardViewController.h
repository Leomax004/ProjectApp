
#import <UIKit/UIKit.h>



@interface DashBoardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *TableAppointment;

@property (nonatomic,retain) NSMutableArray *filteredPatient;



-(void)jsonRead :(void (^)(NSArray *array, NSError *error))callback;
@end
