

#import <UIKit/UIKit.h>

@interface ChatMessageCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *deviceLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIImageView *messageStatus;

- (void)assignText:(NSString *)text;

@end
