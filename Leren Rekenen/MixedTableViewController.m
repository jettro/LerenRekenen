#import "MixedTableViewController.h"
#import "Assignment.h"
#import "SelectTableViewController.h"
#import "NSMutableArrayShuffle.h"


@implementation MixedTableViewController {
    NSMutableArray *assignments;
}

- (id)init {
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.table = [[NSNumber numberWithInt:arc4random_uniform(10) + 1] intValue];
        self.currentAssignment = 1;
        self.title = [self greetingWithTable];
        [self refreshAssignments];
    }

    return self;
}

- (NSString *)greetingWithTable {
    return [NSString stringWithFormat:@"%@%u", @"De tafel van: ", self.table];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.assignmentAnswer = [[UITextField alloc] initWithFrame:CGRectMake(80, 80, 40, 25)];
    self.assignmentAnswer.borderStyle = UITextBorderStyleRoundedRect;
    [self.assignmentAnswer setKeyboardType:UIKeyboardTypeNumberPad];
    self.assignmentAnswer.inputAccessoryView = [self createToolbar];
    [self.assignmentAnswer becomeFirstResponder];

    self.assignmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 70, 25)];

    [self.view addSubview:self.assignmentLabel];
    [self.view addSubview:self.assignmentAnswer];
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
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"Volgende"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(nextAssignment)];
    NSArray *toolbarItems = [NSArray arrayWithObjects:chooseTableItem, spaceItem, nextItem, nil];
    [toolbar setItems:toolbarItems];
    return toolbar;
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

- (void)refreshAssignments {
    assignments = [NSMutableArray arrayWithCapacity:20];
    for (int j = 1; j <= 20; j++) {
        Assignment *assignment;
        if (j <= 10) {
            assignment = [Assignment assignmentWithArgumentA:j argumentB:self.table type:Multiplication];
        } else {
            assignment = [Assignment assignmentWithArgumentA:(j - 10) * self.table argumentB:self.table type:Division];
        }
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:@{@"assignment" : assignment, @"answer" : @""}];
        [assignments addObject:dictionary];
    }
    [assignments shuffle];
    self.currentAssignment = 1;
    self.assignmentAnswer.text = nil;
    self.title = [self greetingWithTable];
    [self nextAssignment];
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

    return [NSString stringWithFormat:@"%u%@%u", assignment.argumentA, mathSign, assignment.argumentB];
}

- (void)nextAssignment {
    if (self.assignmentAnswer.text != nil) {
        assignments[(NSUInteger) (self.currentAssignment - 2)][@"answer"] = self.assignmentAnswer.text;
    }
    if (self.currentAssignment == 21) {
        [self.assignmentAnswer resignFirstResponder];
        [self validateAnswers];
    }

    self.assignmentAnswer.text = @"";
    if (self.currentAssignment == 21) {
        self.currentAssignment = 1;
        self.assignmentLabel.text = @"";
    } else {
        self.assignmentLabel.text = [self createAssignmentLabel:assignments[(NSUInteger) self.currentAssignment - 1][@"assignment"]];
        self.currentAssignment++;
    }
}

- (void)validateAnswers {
    int numErrors = 0;
    NSMutableString *errors = [NSMutableString stringWithCapacity:200];
    for (NSDictionary *dictionary in assignments) {
        Assignment *assignment = dictionary[@"assignment"];
        NSString *answer = dictionary[@"answer"];
        if (![assignment validate:answer.integerValue]) {
            numErrors++;
            [errors appendString:[self createAssignmentLabel:assignment]];
            [errors appendString:@" = "];
            [errors appendString:answer];
            [errors appendString:@"\n"];
        }
    }
    if (numErrors == 0) {
        [errors appendString:@"Hoera, alles goed."];
    }
    UITextView *errorsView = [[UITextView alloc] initWithFrame:CGRectMake(10, 130, 300, 300)];
    [errorsView setText:errors];
    [errorsView setEditable:FALSE];
    [self.view addSubview:errorsView];
}
@end