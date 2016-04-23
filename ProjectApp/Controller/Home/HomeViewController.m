

#import "HomeViewController.h"
#import "Information.h"
#import "PatientTableViewCell.h"
#import "DetailViewController.h"
#import "DashBoardViewController.h"

@interface HomeViewController () <UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) NSMutableArray *array;
@property(strong,nonatomic)NSMutableArray *array2;
@property(strong,nonatomic)NSMutableArray *dateArray;
@property (strong,nonatomic)NSDictionary *dictionary;
@property (strong,nonatomic) UIRefreshControl *refreshControl;

@end

@implementation HomeViewController 
@synthesize filteredPatient;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      
  
    NSLog(@"Elements in array %@",self.filteredPatient);
    
    self.array = [[NSMutableArray alloc]init];
    self.refreshControl = [[UIRefreshControl alloc]init];
    
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.PatientTable addSubview:self.refreshControl];
    [self.refreshControl addTarget:self
                            action:@selector(refreshTable)
                            forControlEvents:UIControlEventValueChanged];

    //Read Json File
    [self jsonRead:^(NSArray *array, NSError *error)
     {
         
         [self.array addObjectsFromArray:array];
         
         [self.PatientTable reloadData];
         
        
        
     }];
    
    NSMutableArray *array1 = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"Emergency" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonPressed)];
    
    [array1 addObject:rightButton];
    
    [self.navigationItem setRightBarButtonItems:array1 animated:YES];

    
    self.PatientTable.delegate = self;
    self.PatientTable.dataSource = self;
    
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.title = @"LOA";
    }
    
    return self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BarButton
-(void)rightButtonPressed
{
    
    
    
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
         [self.PatientTable reloadData];
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
    DetailViewController *dvc = [[DetailViewController alloc]initWithNibName:@"DetailViewController" bundle:nil];
    Information *pointingdata = self.array[indexPath.row];
    [dvc setCurrent:pointingdata];
    [self.navigationController pushViewController:dvc animated:YES];
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    PatientTableViewCell *cell = (PatientTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PatientTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Information *obj = [self.array objectAtIndex:indexPath.row];
    cell.patientName.text = obj.name;
    cell.patientId.text = obj.patientId;
    cell.patientAge.text = obj.age;
    cell.dateOfAppointment.text = obj.dateOfAppointment;
    cell.time.text = obj.time;
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:obj.image]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        cell.patientImage.image = [UIImage imageWithData:data];
    }];
    
    
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
    
}

#pragma mark - Json
-(void)jsonRead:(void (^)(NSArray *array, NSError *error))callback
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"patientList" ofType:@"json"];
    self.array = [[NSMutableArray alloc]init];
    if (fileName) {
        NSLog(@"File received");
        NSData *partyData = [[NSData alloc] initWithContentsOfFile:fileName];
        NSError *error;
        NSDictionary *party = [NSJSONSerialization JSONObjectWithData:partyData
                                                              options:0
                                                                error:&error];
        
        if (!error)
        {
            NSLog(@"Dictionary contains %@",party);
            NSMutableArray *patientEntries = [[NSMutableArray alloc]init];
            
            patientEntries = [party objectForKey:@"patients"];
            //NSMutableArray *clonePatientEntries = [[NSMutableArray alloc]init];
            
            for( int i = 0; i < [patientEntries count]; i++)
            {
                NSLog(@"patinet-->%@",[patientEntries objectAtIndex:i]);
                NSDictionary *dic1 = [patientEntries objectAtIndex:i];
                for(NSString *string in self.filteredPatient)
                {
                    if(![string isEqualToString:[dic1 objectForKey:@"id"]])
                    {
                        //[clonePatientEntries addObject:dic1];
                        //[patientEntries removeObjectAtIndex:i];
                    }
                }
            }
                     
            
            
            
            NSLog(@"Total no of patients %lu",(unsigned long)[patientEntries count]);
             self.array2 = [[NSMutableArray alloc]init];
            
            for( int i = 0; i < [patientEntries count]; i++)
            {
                Information *info = [[Information alloc] init];
                NSDictionary *dic = [patientEntries objectAtIndex:i];
             
                        info.name = [dic objectForKey:@"name"];
                        info.patientId = [dic objectForKey:@"id"];
                        info.age = [dic objectForKey:@"age"];
                        info.bloodgroup = [dic objectForKey:@"bloodGroup"];
                        info.dateOfAppointment = [[dic objectForKey:@"date"]substringWithRange:NSMakeRange(0, 10)];
                
                        NSString *Time = [dic objectForKey:@"date"];
                        NSString *subString = [Time substringWithRange:NSMakeRange(11,8)];
                        info.time = subString;      
                        [self.dateArray addObject:subString];
                
                        info.image = [dic objectForKey:@"profile"];
                
                
                        [self.array2 addObject:info];
               
            }
            
            NSLog(@"array in %@",self.array2);
            Information *objUser = nil;
            
            if([self.array2 count] > 0)
                
            {
                objUser = (Information *)self.array2[0];
               
                
            }
            callback(self.array2,nil);
        }
        else
        {
           
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
