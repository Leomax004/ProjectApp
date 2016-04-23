//
//  DetailViewController.h


#import <UIKit/UIKit.h>
#import "Information.h"
#import "PatientInformation.h"

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *patirntImage;

@property (weak, nonatomic) IBOutlet UILabel *patirntName;
@property (weak, nonatomic) IBOutlet UILabel *petientId;
@property (weak, nonatomic) IBOutlet UILabel *doctorName;
@property (weak, nonatomic) IBOutlet UILabel *diagnosis;
@property (weak, nonatomic) IBOutlet UILabel *symptoms;
@property (weak, nonatomic) IBOutlet UILabel *medication;
@property (weak, nonatomic) IBOutlet UILabel *knownDisease;
@property (weak, nonatomic) IBOutlet UILabel *comments;

@property(nonatomic)Information *current;
@property(nonatomic)PatientInformation *pcurrent;

-(NSString *)stringByRemovingControlCharacters: (NSString *)inputString;

#pragma mark - jsonRead
-(void)jsonRead :(void (^)(NSArray *array, NSError *error))callback;


@end
