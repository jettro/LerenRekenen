//
// Created by jcoenradie on 12/8/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

typedef enum {
    Addition,
    Subtraction,
    Multiplication,
    Division
} AssignmentType;

@interface Assignment : NSObject {

}

@property(nonatomic, readwrite) AssignmentType type;

@property(nonatomic, readwrite) int argumentA;

@property(nonatomic, readwrite) int argumentB;

- (id)initWithArgumentA:(int)anArgumentA argumentB:(int)anArgumentB type:(AssignmentType)type;

+ (id)assignmentWithArgumentA:(int)anArgumentA argumentB:(int)anArgumentB type:(AssignmentType)type;


- (BOOL)validate:(int)answer;

@end