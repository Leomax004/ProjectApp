
#import "DashBoardViewController.h"
#import "DashBoardTableViewCell.h"
#import "Information.h"
#import "AppDelegate.h"
#import "HomeViewController.h"

@interface DashBoardViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray *array;
@property (strong,nonatomic) UIRefreshControl *refreshControl;

@end

@implementation DashBoardViewController
@synthesize filteredPatient;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *message = @"Swipe left to Add/Delete";
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 1; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
    self.filteredPatient = [[NSMutableArray alloc] init];
    self.array = [[NSMutableArray alloc]init];
    self.refreshControl = [[UIRefreshControl alloc]init];
    
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.TableAppointment addSubview:self.refreshControl];
    [self.refreshControl addTarget:self
                            action:@selector(refreshTable)
                  forControlEvents:UIControlEventValueChanged];

    
    
    [self jsonRead:^(NSArray *array, NSError *error)
     {
         
         [self.array addObjectsFromArray:array];
         
         [self.TableAppointment reloadData];
         
         
         
     }];
    
    NSMutableArray *array1 = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonPressed)];
    
    [array1 addObject:rightButton];
    
    [self.navigationItem setRightBarButtonItems:array1 animated:YES];

    self.TableAppointment.delegate = self;
    self.TableAppointment.dataSource = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.title = @"New Appointments";
    }
    
    return self;
}

#pragma mark - BarButton
-(void)rightButtonPressed
{
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appdelegate addTabbarController];
    HomeViewController *newweb = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    [newweb setFilteredPatient:self.filteredPatient];
    [self.navigationController presentViewController:newweb animated:YES completion:nil];
   
}



#pragma mark - Refresh Control
-(void)refreshTable
{
    
    [self jsonRead:^(NSArray *array, NSError *error)
     {
         [self.array removeAllObjects];
         
         NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
         [formatter setDateFormat:@"MMM d, h:mm a"];
         NSString *title = [NSString stringWithFormat:@"Last update:%@",[formatter stringFromDate:[NSDate date ]]];
         NSDictionary *attrDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
         NSAttributedString *attributedTitle = [[NSAttributedString alloc]initWithString:title attributes:attrDictionary];
         self.refreshControl.attributedTitle = attributedTitle;
         [self.array addObjectsFromArray:array];
         [self.TableAppointment reloadData];
         [self.refreshControl endRefreshing];
     }];
    
    
}

#pragma mark - Table delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    DetailViewController *dvc = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
//    Information *pointingdata = self.array[indexPath.row];
//    [dvc setCurrent:pointingdata];
//    [self.navigationController pushViewController:dvc animated:YES];
//    
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Button 1" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        NSLog(@"Action to perform with Button 1");
                                        Information *obj = [self.array objectAtIndex:indexPath.row];
                                        NSString *patientId = obj.patientId;
                                        [self.filteredPatient addObject:patientId];
                                        [self.array removeObjectAtIndex:indexPath.row];
                                        [tableView reloadData];
                                        
                                      
                                        
                                    }];
    button.backgroundColor = [UIColor greenColor];
    button.title = @"Accept";
    
    UITableViewRowAction *button2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Button 2" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                     {
                                         NSLog(@"Action to perform with Button2!");
                                         [self.array removeObjectAtIndex:indexPath.row];
                                         [tableView reloadData];

                                     }];
    button2.backgroundColor = [UIColor redColor];
    button2.title = @"Cancel";
    
    return @[button2,button];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    DashBoardTableViewCell *cell = (DashBoardTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DashBoardTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Information *obj = [self.array objectAtIndex:indexPath.row];
    cell.patientName.text = obj.name;
    cell.dateofAppointment.text = obj.dateOfAppointment;
    cell.patientId.text = obj.patientId;
    
    
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}

#pragma mark - Json
-(void)jsonRead :(void (^)(NSArray *array, NSError *error))callback
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"patientList" ofType:@"json"];
    
    if (fileName) {
        NSLog(@"File received");
        NSData *partyData = [[NSData alloc] initWithContentsOfFile:fileName];
        NSError *error;
        NSDictionary *party = [NSJSONSerialization JSONObjectWithData:partyData
                                                              options:0
                                                                error:&error];
//        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
//        NSDictionary *party2 = [[party objectForKey:@"patients"] sortedArrayUsingDescriptors:@[sorter]];
//        
        if (!error)
        {
            NSLog(@"Dictionary contains %@",party);
            NSArray *patientEntries = [party objectForKey:@"patients"];
            NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
            NSArray *patientEntries2 = [[party objectForKey:@"patients"] sortedArrayUsingDescriptors:@[sorter]];
            NSLog(@"Total no of patients %lu",(unsigned long)[patientEntries count]);
            NSMutableArray *array2 = [[NSMutableArray alloc]init];
                       
            for( int  i = [patientEntries2 count]-1; i >= 0; i--)
            {
                Information *info = [[Information alloc] init];
                NSDictionary *dic = [patientEntries2 objectAtIndex:i];
                info.name = [dic objectForKey:@"name"];
                info.dateOfAppointment = [dic objectForKey:@"date"];
                info.patientId = [dic objectForKey:@"id"];
                info.image = [dic objectForKey:@"profile"];
                
                [array2 addObject:info];
                
            }
            Information *objUser = nil;
            
            if([array2 count] > 0)
                
            {
                objUser = (Information *)array2[0];
                
            }
            
            callback(array2, nil);
            
        }
        else
        {
            callback(nil, error);
            NSLog(@"Something went wrong! %@", error.localizedDescription);
        }
        
    }
    else {
        NSLog(@"Couldn't find file!");
    }
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
