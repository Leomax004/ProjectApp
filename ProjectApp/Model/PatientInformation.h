

#import <Foundation/Foundation.h>
#import "Information.h"

@interface PatientInformation : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *patientId;
@property (nonatomic) NSString *diagnosis;
@property (nonatomic) NSString *symptoms;
@property (nonatomic) NSString *medication;
@property (nonatomic) NSString *comments;
@property (nonatomic) NSString *doctor;
@property (nonatomic) NSString *knownDeseases;

@property(nonatomic)Information *current;
@end
