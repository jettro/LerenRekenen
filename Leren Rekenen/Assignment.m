//
// Created by jcoenradie on 12/8/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Assignment.h"

@implementation Assignment

- (id)initWithArgumentA:(int)anArgumentA argumentB:(int)anArgumentB type:(AssignmentType)type {
    self = [super init];
    if (self) {
        self.argumentA = anArgumentA;
        self.argumentB = anArgumentB;
        self.type = type;
    }

    return self;
}

+ (id)assignmentWithArgumentA:(int)anArgumentA argumentB:(int)anArgumentB type:(AssignmentType)type {
    return [[Assignment alloc] initWithArgumentA:anArgumentA argumentB:anArgumentB type:type];
}

- (BOOL) validate:(int) answer {
    switch (self.type) {
        case Addition:
            return answer == self.argumentA + self.argumentB;
        case Subtraction:
            return answer == self.argumentA - self.argumentB;
        case Multiplication:
            return answer == self.argumentA * self.argumentB;
        case Division:
            return answer * self.argumentB == self.argumentA;
    }
    return FALSE;
}

@end