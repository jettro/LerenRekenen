//
// Created by jcoenradie on 12/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MixedTableViewController.h"
#import "Assignment.h"
#import "SelectTableViewController.h"
#import "NSMutableArrayShuffle.h"


@implementation MixedTableViewController {
    NSMutableArray *assignments;
    UILabel *greeting;
    UIButton *doneButton;
}

- (id)init {
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.table = [[NSNumber numberWithInt:arc4random_uniform(10) + 1] intValue];
        self.currentAssignment = 1;

        greeting = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 140, 20)];
        greeting.backgroundColor = [UIColor greenColor];

        greeting.text = [self greetingWithTable:self.table];
        [self.view addSubview:greeting];
        [self refreshAssignments];
    }

    return self;
}

- (NSString *)greetingWithTable:(int)table {
    return [NSString stringWithFormat:@"%@%u", @"De tafel van: ", self.table];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.assignmentAnswer = [[UITextField alloc] initWithFrame:CGRectMake(60, 80, 40, 25)];
    self.assignmentAnswer.borderStyle = UITextBorderStyleRoundedRect;
    [self.assignmentAnswer setKeyboardType:UIKeyboardTypeNumberPad];
    [self.assignmentAnswer becomeFirstResponder];

    self.assignmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 50, 25)];

    [self.view addSubview:[self addSelectTableButton]];
    [self.view addSubview:[self addNextAssignmentButton]];
    [self.view addSubview:self.assignmentLabel];
    [self.view addSubview:self.assignmentAnswer];
}

- (UIView *)addSelectTableButton {
    UIButton *chooseTableBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [chooseTableBtn setFrame:CGRectMake(220, 10, 90, 30)];
    [chooseTableBtn setTitle:@"Kies tafel" forState:UIControlStateNormal];
    [chooseTableBtn addTarget:self action:@selector(selectTable) forControlEvents:UIControlEventTouchUpInside];
    return chooseTableBtn;
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
    greeting.text = [self greetingWithTable:self.table];
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

- (UIView *)addNextAssignmentButton {
    UIButton *nextAssignmentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nextAssignmentButton setFrame:CGRectMake(220, 80, 90, 30)];
    [nextAssignmentButton setTitle:@"Next" forState:UIControlStateNormal];
    [nextAssignmentButton addTarget:self action:@selector(nextAssignment) forControlEvents:UIControlEventTouchUpInside];
    return nextAssignmentButton;

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
    [self.view addSubview:errorsView];
}

/* Methods that are related to the keyboard with the custom done button */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super viewWillDisappear:animated];
}

- (void)keyboardDidShow:(id)keyboardDidShow {
    // create custom button
    if (doneButton == nil) {
        doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 163, 106, 53)];
        [doneButton setTitle:@"Klaar" forState:UIControlStateNormal];
        [doneButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    else {
        [doneButton setHidden:NO];
    }

    [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // locate keyboard view
    UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView *keyboard = nil;
    for (int i = 0; i < [tempWindow.subviews count]; i++) {
        keyboard = [tempWindow.subviews objectAtIndex:(NSUInteger) i];
        // keyboard found, add the button
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
            if ([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
                [keyboard addSubview:doneButton];
        } else {
            if ([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
                [keyboard addSubview:doneButton];
        }
    }
}

- (void)doneButtonClicked:(id)doneButtonClicked {
    [self nextAssignment];
}

/* END of methods related to the custom keyboard */


@end