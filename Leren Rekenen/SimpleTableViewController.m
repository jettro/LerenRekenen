//
// Created by jcoenradie on 11/30/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SimpleTableViewController.h"
#import "Assignment.h"

@interface SimpleTableViewController ()
// What does this do?
@end

@implementation SimpleTableViewController {
    NSMutableArray *assignments;
}

- (id)init {
    self = [super init];
    if (self) {
        self.table = 4;

        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:[self greetingWithTable:self.table]];

        assignments = [NSMutableArray arrayWithCapacity:10];
        for (int j = 1; j <= 10; j++) {
            int row = j;
            int column = 1;
            if (j > 5) {
                row = j - 5;
                column = 2;
            }
            NSDictionary *dictionary = [self show:[Assignment assignmentWithArgumentA:j argumentB:self.table type:Multiplication] atRow:row atColumn:column];
            [assignments addObject:dictionary];
            [self.view addSubview:dictionary[@"textfield"]];
            [self.view addSubview:dictionary[@"label"]];
        }
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self addSelectTableButton]];
}


- (UIView *)addSelectTableButton {
    UIButton *chooseTableBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [chooseTableBtn setFrame:CGRectMake(200, 0, 100, 20)];
    [chooseTableBtn setTitle:@"Kies" forState:UIControlStateNormal];
    [chooseTableBtn addTarget:self action:@selector(selectTableDummy) forControlEvents:UIControlEventTouchUpInside];
    return chooseTableBtn;
}

- (void)selectTableDummy {
    NSLog(@"About to select a table");
}

- (UIView *)greetingWithTable:(int)table {
    UILabel *greeting = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 20)];
    greeting.text = [NSString stringWithFormat:@"%@%u", @"De tafel van: ", table];
    greeting.backgroundColor = [UIColor greenColor];
    return greeting;
}

- (NSDictionary *)show:(Assignment *)assignment atRow:(int)rowNr atColumn:(int)columnNr {
    int x = (columnNr - 1) * 130;
    int y = rowNr * 30;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x + 80, y, 40, 25)];
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

    return @{@"label" : label, @"textfield" : textField, @"assignment" : assignment};
}

@end