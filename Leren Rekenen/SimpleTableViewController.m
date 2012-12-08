//
// Created by jcoenradie on 11/30/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SimpleTableViewController.h"
#import "Assignment.h"


@implementation SimpleTableViewController {

}

- (id)init {
    self = [super init];
    if (self) {
        int table = 3;
        [self.view setBackgroundColor:[UIColor whiteColor]];
        UILabel *greeting = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 20)];
        greeting.text = [NSString stringWithFormat:@"%@%u",@"De tafel van: ",table];
        greeting.backgroundColor = [UIColor greenColor];
        [self.view addSubview:greeting];
        UIButton *chooseTableBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 0, 100, 20)];
        [chooseTableBtn setTitle:@"Kies" forState:UIControlStateNormal];
        [chooseTableBtn addTarget:self action:@selector(selectTable:) forControlEvents:UIControlEventTouchUpInside];
        chooseTableBtn.backgroundColor = [UIColor grayColor];
        [self.view addSubview:chooseTableBtn];

        NSMutableArray *inputFields = [NSMutableArray arrayWithCapacity:10];
        for (int j = 1; j <= 10; j++) {
            int row = j;
            int column = 1;
            if (j > 5) {
                row = j-5;
                column = 2;
            }
            NSDictionary *dictionary = [self show:[Assignment assignmentWithArgumentA:j argumentB:table type:Multiplication] atRow:row atColumn:column];
            [inputFields addObject:dictionary];
            [self.view addSubview:dictionary[@"textfield"]];
            [self.view addSubview:dictionary[@"label"]];
        }
    }

    return self;
}

- (NSDictionary *) show:(Assignment *)assignment atRow:(int)rowNr atColumn:(int) columnNr {
    int x = (columnNr-1)*130;
    int y = rowNr * 30;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x + 80,y,40,25)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 60, 25)];

    NSString *mathSign;

    switch (assignment.type) {
        case Addition:
            mathSign = @" + ";
            break;
        case Subtraction:
            mathSign = @" - ";
            break;
        case Multiplication:
            mathSign = @" * ";
            break;
        case Division:
            mathSign = @" / ";
            break;
        default:
            mathSign = @"err";
    }

    label.text = [NSString stringWithFormat:@"%u%@%u", assignment.argumentA, mathSign, assignment.argumentB];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    NSArray *myValues = [NSArray arrayWithObjects:label,textField,assignment, nil];
    NSArray *myKeys = [NSArray arrayWithObjects:@"label",@"textfield",@"assignment", nil];
    
    return [NSDictionary dictionaryWithObjects:myValues forKeys:myKeys];
}

- (IBAction)selectTable:(id)selectTable {
    NSLog(@"About to select a table");
}

@end