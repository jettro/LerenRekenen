//
// Created by jcoenradie on 11/30/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SimpleTableViewController.h"
#import "Assignment.h"
#import "SelectTableViewController.h"

@interface SimpleTableViewController ()
// What does this do?
@end

@implementation SimpleTableViewController {
    NSMutableArray *assignments;
    UIButton *doneButton;
    UILabel *greeting;
}

- (id)init {
    self = [super init];
    if (self) {
        self.table = 7;

        [self.view setBackgroundColor:[UIColor whiteColor]];
        greeting = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 140, 20)];
        greeting.backgroundColor = [UIColor greenColor];

        greeting.text = [self greetingWithTable:self.table];
        [self.view addSubview:greeting];

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

/* END of methods related to the custom keyboard */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self addSelectTableButton]];
    [self.view addSubview:[self addCheckAnswersButton]];
}

- (UIView *)addCheckAnswersButton {
    UIButton *checkAnswersButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [checkAnswersButton setFrame:CGRectMake(220, 80, 90, 30)];
    [checkAnswersButton setTitle:@"Check" forState:UIControlStateNormal];
    [checkAnswersButton addTarget:self action:@selector(checkAnswers) forControlEvents:UIControlEventTouchUpInside];
    return checkAnswersButton;

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

        greeting.text = [self greetingWithTable:self.table];
    }

    UITextField *textField = assignments[0][@"textfield"];
    [textField becomeFirstResponder];
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

- (NSString *)greetingWithTable:(int)table {
    return [NSString stringWithFormat:@"%@%u", @"De tafel van: ", self.table];
}

- (NSDictionary *)show:(Assignment *)assignment atRow:(int)rowNr atColumn:(int)columnNr {
    int x = (columnNr - 1) * 110 + 5;
    int y = rowNr * 30;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(x + 50, y, 40, 25)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 50, 25)];

    NSString *assignmentLabel = [self createAssignmentLabel:assignment];

    label.text = assignmentLabel;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [textField setKeyboardType:UIKeyboardTypeNumberPad];

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