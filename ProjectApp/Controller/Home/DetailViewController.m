
#import "DetailViewController.h"



@interface DetailViewController ()
@property (strong,nonatomic) NSMutableArray *array;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.patirntName.text = self.current.name;
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.current.image]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        self.patirntImage.image = [UIImage imageWithData:data];
    }];
   
    [self jsonRead:^(NSArray *array, NSError *error) {
        [self.array addObjectsFromArray:array];
    }];
    
    self.petientId.text = self.pcurrent.patientId;
    self.diagnosis.text = self.pcurrent.diagnosis;
    self.symptoms.text = self.pcurrent.symptoms;
    self.medication.text = self.pcurrent.medication;
    self.doctorName.text = self.pcurrent.doctor;
    self.comments.text = self.pcurrent.comments;
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Json
-(void)jsonRead :(void (^)(NSArray *array, NSError *error))callback
{
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"patientDetail" ofType:@"json"];
       if (fileName) {
        NSLog(@"File received");
        NSData *partyData = [[NSData alloc] initWithContentsOfFile:fileName];
        NSError *error;
           
          
           NSString *newStr = [[NSString alloc] initWithData:partyData encoding:NSUTF8StringEncoding];
           NSData* data = [[self stringByRemovingControlCharacters:newStr] dataUsingEncoding:NSUTF8StringEncoding];
           NSDictionary *party = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&error];

        if (!error)
        {
            NSLog(@"Dictionary contains %@",party);
            NSArray *patientEntries = [party objectForKey:@"patientDetails"];
            NSLog(@"Total no of patients %lu",(unsigned long)[patientEntries count]);
            NSMutableArray *array2 = [[NSMutableArray alloc]init];
            
            for( int i = 0; i < [patientEntries count]; i++)
            {
                PatientInformation *pInfo = [[PatientInformation alloc] init];
                NSDictionary *dic = [patientEntries objectAtIndex:i];
               
                if([self.current.patientId isEqualToString:[dic objectForKey:@"id"]])
                {
                pInfo.diagnosis = [dic objectForKey:@"diagnosis"];
                pInfo.symptoms = [dic objectForKey:@"symptoms"];
                pInfo.medication = [dic objectForKey:@"medication"];
                pInfo.doctor = [dic objectForKey:@"doctor"];
                pInfo.comments = [dic objectForKey:@"comments"];
                
                [array2 addObject:pInfo];
                }
                
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
-(NSString *)stringByRemovingControlCharacters: (NSString *)inputString
{
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    NSRange range = [inputString rangeOfCharacterFromSet:controlChars];
    if (range.location != NSNotFound) {
        NSMutableString *mutable = [NSMutableString stringWithString:inputString];
        while (range.location != NSNotFound) {
            [mutable deleteCharactersInRange:range];
            range = [mutable rangeOfCharacterFromSet:controlChars];
        }
        return mutable;
    }
    return inputString;
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
