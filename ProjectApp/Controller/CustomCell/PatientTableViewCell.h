

#import <UIKit/UIKit.h>

@interface PatientTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *patientImage;
@property (weak, nonatomic) IBOutlet UILabel *patientName;
@property (weak, nonatomic) IBOutlet UILabel *patientAge;
@property (weak, nonatomic) IBOutlet UILabel *patientId;
@property (weak, nonatomic) IBOutlet UILabel *dateOfAppointment;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end
