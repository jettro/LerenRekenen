#import "SimpleTableViewController.h"
#import "Assignment.h"
#import "SelectTableViewController.h"

@implementation SimpleTableViewController {
    NSMutableArray *assignments;
}

- (id)init {
    self = [super init];
    if (self) {
        self.table = [[NSNumber numberWithInt:arc4random_uniform(10) + 1] intValue];
        self.title = [self greetingWithTable];
        [self.view setBackgroundColor:[UIColor whiteColor]];

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

- (UIView *)createToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    [toolbar setBarStyle:UIBarStyleBlackOpaque];

    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                               target:nil action:nil];
    UIBarButtonItem *chooseTableItem = [[UIBarButtonItem alloc] initWithTitle:@"Kies tafel"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(selectTable)];
    UIBarButtonItem *checkItem = [[UIBarButtonItem alloc] initWithTitle:@"Check"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(checkAnswers)];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"Volgende"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(nextAssignment)];
    NSArray *toolbarItems = [NSArray arrayWithObjects:chooseTableItem, checkItem, spaceItem, nextItem, nil];
    [toolbar setItems:toolbarItems];
    return toolbar;
}

- (void)nextAssignment {
    for (int i = 0; i < 10; i++) {
        UITextField *textField = assignments[(NSUInteger) i][@"textfield"];
        if (textField.isFirstResponder) {
            if (i < 9) {
                UITextField *next = assignments[(NSUInteger) (i + 1)][@"textfield"];
                [next becomeFirstResponder];
                return;
            } else {
                [textField resignFirstResponder];
            }
        }
    }
}


- (void)checkAnswers {
    for (int i = 0; i < 10; i++) {
        UITextField *textField = assignments[(NSUInteger) i][@"textfield"];
        Assignment *assignment = assignments[(NSUInteger) i][@"assignment"];
        if ([assignment validate:textField.text.intValue]) {
            textField.backgroundColor = [UIColor greenColor];
        }
    }
}

- (void)refreshAssignments {
    for (int i = 0; i < 10; i++) {
        UITextField *textField = assignments[(NSUInteger) i][@"textfield"];
        Assignment *assignment = assignments[(NSUInteger) i][@"assignment"];
        UILabel *label = assignments[(NSUInteger) i][@"label"];

        assignment.argumentB = self.table;
        label.text = [self createAssignmentLabel:assignment];
        textField.text = @"";
        textField.backgroundColor = [UIColor clearColor];

        self.title = [self greetingWithTable];
    }

    UITextField *textField = assignments[0][@"textfield"];
    [textField becomeFirstResponder];
}

- (void)selectTable {
    SelectTableViewController *selectTableViewController = [SelectTableViewController new];
    [self presentViewController:selectTableViewController animated:TRUE completion:^{
        selectTableViewController.selectedTable = [NSString stringWithFormat:@"%u", self.table];
        selectTableViewController.tableSelected = ^(NSString *string) {
            self.table = string.integerValue;
            [self refreshAssignments];
        };

    }];
}

- (NSString *)greetingWithTable {
    return [NSString stringWithFormat:@"%@%u", @"De tafel van: ", self.table];
}

- (NSDictionary *)show:(Assignment *)assignment atRow:(int)rowNr atColumn:(int)columnNr {
    int x = (columnNr - 1) * 110 + 5;
    int y = (rowNr - 1) * 30 + 5;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x + 50, y, 40, 25)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 50, 25)];

    NSString *assignmentLabel = [self createAssignmentLabel:assignment];

    label.text = assignmentLabel;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    [textField setInputAccessoryView:[self createToolbar]];

    return @{@"label" : label, @"textfield" : textField, @"assignment" : assignment};
}

- (NSString *)createAssignmentLabel:(Assignment *)assignment {
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

    NSString *assignmentLabel = [NSString stringWithFormat:@"%u%@%u", assignment.argumentA, mathSign, assignment.argumentB];
    return assignmentLabel;
}

@end