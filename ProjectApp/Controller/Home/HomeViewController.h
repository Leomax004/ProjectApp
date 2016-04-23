

#import <UIKit/UIKit.h>
#import "Information.h"


@interface HomeViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *PatientTable;
@property (nonatomic,retain)NSMutableArray *filteredPatient;


#pragma mark - json
-(void)jsonRead:(void (^)(NSArray *array, NSError *error))callback;


@end
