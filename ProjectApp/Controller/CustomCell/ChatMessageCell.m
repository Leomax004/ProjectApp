
#import "ChatMessageCell.h"

@implementation ChatMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)assignText:(NSString *)text
{
    self.messageLabel.text = text;
}




@end
