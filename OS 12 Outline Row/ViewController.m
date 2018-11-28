//
//  ViewController.m
//  OS 12 Outline Row
//
//  Created by Roman Kopaliani on 11/28/18.
//  Copyright © 2018 Roman Kopaliani. All rights reserved.
//

#import "ViewController.h"
#import "MSPASystemInfoTableViewRow.h"


@interface OutlineItem: NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *items;

@end

@implementation OutlineItem
@end


@interface ViewController () <NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (nonatomic, weak) IBOutlet NSOutlineView *outlineView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    OutlineItem *item1 = [OutlineItem new];
    item1.title = @"Foo";
    item1.items = @[@"Foo_1", @"Foo_2", @"Foo_3", @"Foo_4"];
    
    OutlineItem *item2 = [OutlineItem new];
    item2.title = @"Bar";
    item2.items = @[@"Bar_1", @"Bar_2"];

    self.dataSource = @[item1, item2];
    self.outlineView.delegate = self;
    self.outlineView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    NSArray *categories = self.dataSource;
    
    if (item == nil) {
        return categories.count;
    }
    
    if ([item isMemberOfClass:[OutlineItem class]]) {
        OutlineItem *temp = ((OutlineItem*)item);
        return temp.items.count;
    }
    return 0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
    if (outlineView.tag != 0 || [item isMemberOfClass:[OutlineItem class]] == NO) {
        return NO;
    }
    
    OutlineItem *castedCategory = (OutlineItem *)item;
    return castedCategory.items.count > 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    if (index < 0) {
        return [NSView new];
    }
    
    if (item == nil) {
        NSArray *categories = self.dataSource;
        //item is nil when the outline view wants to inquire for root level items
        return categories[index];
    }
    
    if ([item isMemberOfClass:[OutlineItem class]]) {
        OutlineItem *castedItem = (OutlineItem *)item;
        if(castedItem.items.count > 0) {
            return [castedItem.items objectAtIndex:index];
        }
    }
    
    return [NSView new];
}

- (nullable NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(id)item {
    MSPASystemInfoTableViewRow *row = [outlineView makeViewWithIdentifier:@"systemInfoRow" owner:self];
    if (row == nil) {
        row = [MSPASystemInfoTableViewRow new];
        row.primarySelectionColor = [NSColor orangeColor];
        row.secondarySelectionColor = [NSColor greenColor];
        row.identifier = @"systemInfoRow";
    }
    return row;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
    return YES;
//    if (outlineView.tag != 0) {
//        return NO;
//    }
//
//    if ([item isMemberOfClass:[MSPASystemInfoCategory class]] == NO) {
//        return NO;
//    }
//
//    MSPASystemInfoCategory *castedCategory = (MSPASystemInfoCategory *)item;
//    BAINFO(@"Selected Category: %@", castedCategory.name);
//    if (castedCategory.dataType != MSPASystemInfoDataTypeUndefined) {
//        return YES;
//    }
//
//    if (self.expandedCategory == nil) {
//        [outlineView.animator expandItem:item];
//    } else {
//        [outlineView.animator collapseItem:item];
//    }
//
//    return NO;
}


- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
    NSTableCellView *cell = [outlineView makeViewWithIdentifier:@"categoryCell" owner:self];
    if ([item isKindOfClass:[OutlineItem class]]) {
        OutlineItem *castedCategory = (OutlineItem *)item;
        cell.textField.stringValue = castedCategory.title;
    } else if ([item isKindOfClass:[NSString class]]) {
        cell.textField.stringValue = (NSString *)item;
    }
    return cell;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
