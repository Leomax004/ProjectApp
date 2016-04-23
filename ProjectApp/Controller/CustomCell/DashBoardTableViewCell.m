

#import "DashBoardTableViewCell.h"

@implementation DashBoardTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.patientId setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
