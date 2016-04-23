
#import "MessageViewController.h"
#import "ChatMessageCell.h"
#import "AppDelegate.h"



extern NSString *const LQSCurrentUserId;
extern NSString *const LQSParticipantUserId;
extern NSString *const LQSParticipant2UserID;
extern NSString *const LQSCategoryIdentifier;

static NSString *const ChatMessageCellReuseIdentifier = @"ChatMessageCell";


@interface MessageViewController () <UITextViewDelegate,LYRQueryControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic) LYRConversation *conversation;
@property (nonatomic) LYRQueryController *queryController;
@property (nonatomic)BOOL sendingImage;
@property (nonatomic)UIImage *image;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.layerClient = appDelegate.layerClient;
    [self fetchDataConversation];
    [self.tableView reloadData];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.mainView addGestureRecognizer:tap];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonPressed)];
    
    [array addObject:rightButton];
    
    [self.navigationItem setRightBarButtonItems:array animated:YES];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(refreshTableData) userInfo:nil repeats:YES];
    

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
     [self.tableView reloadData];
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = @"Chat";
    }
    
    return self;
    
}

#pragma mark - Fetching Layer Content

- (void)fetchDataConversation
{
    NSLog(@"fetchlayerConversation---------------->");
    //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // Fetches all conversations between the authenticated user and the supplied participant
    // For more information about Querying, check out https://developer.layer.com/docs/integration/ios#querying
    if (!self.conversation) {
        NSError *error;
        // Trying creating a new distinct conversation between all 3 participants
        self.conversation = [self.layerClient  newConversationWithParticipants:[NSSet setWithArray:@[LQSParticipantUserId,LQSParticipant2UserID]] options:nil error:&error];
        if (!self.conversation) {
            // If a conversation already exists, use that one
           
            if (error.code == LYRErrorDistinctConversationExists) {
                self.conversation = error.userInfo[LYRExistingDistinctConversationKey];
                NSLog(@"Conversation already exists between participants. Using existing");
            }
        }
    }
    NSLog(@"Conversation identifier: %@",self.conversation.identifier);
    
    // setup query controller with messages from last conversation
    if (!self.queryController) {
        [self setupQueryController];
    }
}
- (void)setupQueryController
{
    
    NSLog(@"setupQueryController-------------->");
    
    // For more information about the Query Controller, check out https://developer.layer.com/docs/integration/ios#querying
    
    // Query for all the messages in conversation sorted by position
    LYRQuery *query = [LYRQuery queryWithQueryableClass:[LYRMessage class]];
    query.predicate = [LYRPredicate predicateWithProperty:@"conversation" predicateOperator:LYRPredicateOperatorIsEqualTo value:self.conversation];
    query.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]];
    
    // Set up query controller
    NSError *error;
    self.queryController = [self.layerClient queryControllerWithQuery:query error:&error];
    if (self.queryController) {
        self.queryController.delegate = self;
        
        BOOL success = [self.queryController execute:&error];
        if (success) {
            NSLog(@"Query fetched %tu message objects", [self.queryController numberOfObjectsInSection:0]);
        } else {
            NSLog(@"Query failed with error: %@", error);
        }
        [self.tableView reloadData];
        [self.conversation markAllMessagesAsRead:nil];
    } else {
        NSLog(@"Query Controller initialization failed with error: %@", error);
    }
}

#pragma - mark Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return number of objects in queryController
    NSInteger rows = [self.queryController numberOfObjectsInSection:0];
    
    return rows;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set up custom ChatMessageCell for displaying message
    //LQSPictureMessageCell
    ChatMessageCell *cell = (ChatMessageCell *)[tableView dequeueReusableCellWithIdentifier:ChatMessageCellReuseIdentifier];
    if( cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ChatMessageCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    LYRMessage *message = [self.queryController objectAtIndexPath:indexPath];
    LYRMessagePart *messagePart = message.parts[0];
    if ([messagePart.MIMEType isEqualToString:@"image/png"]) {
        cell.messageLabel.text = @"sorry File not Supported ☹️";
        cell.deviceLabel.text = message.sender.userID;
           }
    else
    {
        [cell assignText:[[NSString alloc] initWithData:messagePart.data encoding:NSUTF8StringEncoding]];
        cell.deviceLabel.text = message.sender.userID;
        
    }
    
    return cell;
}
#pragma marks - Handling Keyboards


- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self.inputTextView resignFirstResponder];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)moveViewUpToShowKeyboard:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    if (movedUp) {
        if (rect.origin.y == 0) {
            rect.origin.y = self.view.frame.origin.y - 255.0f;
        }
    } else {
        if (rect.origin.y < 0) {
            rect.origin.y = self.view.frame.origin.y + 255.0f;
        }
    }
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.inputTextView resignFirstResponder];
    return YES;
}



-(void)rightButtonPressed
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete messages?"
                                                    message:@"Are you sure you want to delete the Message?"
                                                   delegate:self
                                          cancelButtonTitle:@"NO"
                                          otherButtonTitles:@"Yes",nil];
    [alert show];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
       // [self clearMessages];    for clearing the message
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)refreshTableData
{
    [self.tableView reloadData];
}


#pragma IB - Actions
- (IBAction)messageSend:(UIButton *)sender
{
    
    if([self.inputTextView.text isEqualToString:@""])
    {
        UIAlertView *blankTextAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Can't Enter Null" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [blankTextAlert show];
        [self moveViewUpToShowKeyboard:NO];
        [self.inputTextView resignFirstResponder];
    }
    else
    {
        [self sendMessage:self.inputTextView.text];
        //lower the keyboard
        [self moveViewUpToShowKeyboard:NO];
        [self.inputTextView resignFirstResponder];
    }
}
-(void)sendMessage:(NSString *)messageText
{
    
    if (!self.conversation) {
        [self fetchDataConversation];
    }
    
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithText:messageText];
    NSString *pushMessage = [NSString stringWithFormat:@"%@ says %@",self.layerClient.authenticatedUserID,messageText];
    
    
    LYRPushNotificationConfiguration *defaultConfiguration = [LYRPushNotificationConfiguration new];
    defaultConfiguration.alert = pushMessage;
    defaultConfiguration.category = LQSCategoryIdentifier;
    defaultConfiguration.data = @{ @"test_key": @"test_value"};
    NSDictionary *pushOptions = @{ LYRMessageOptionsPushNotificationConfigurationKey: defaultConfiguration };
    LYRMessage *message = [self.layerClient newMessageWithParts:@[messagePart] options:pushOptions error:nil];
    
    //LYRMessage *message = [self.layerClient newMessageWithParts:@[messagePart] options:@{LYRMessageOptionsPushNotificationConfigurationKey:messageText} error:nil];
    
    NSError *error;
    BOOL sucess = [self.conversation sendMessage:message error:&error];
    if(sucess)
    {
        NSLog(@"Message sent: %@",messageText);
        self.inputTextView.text = @"";
        [self.tableView reloadData];
    }
    else
    {
        NSLog(@"Message send failed: %@",error);
    }
    if(!self.queryController)
    {
        [self setupQueryController];
    }
    
}




@end
