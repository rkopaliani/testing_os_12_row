//
//  MSPASystemInfoTableViewRow.m
//  MSP Anywhere Viewer
//
//  Created by Roman Kopaliani on 9/19/18.
//  Copyright © 2018 BeAnywhere. All rights reserved.
//

#import "MSPASystemInfoTableViewRow.h"

#import "PureLayout.h"

@interface MSPASystemInfoTableViewRow()

@property (nonatomic, assign) BOOL didUpdateConstraints;
@property (nonatomic, weak) NSButton *disclosureIndicatorButton;

@end

@implementation MSPASystemInfoTableViewRow

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if(self.numberOfColumns <= 0) {
        return;
    }
    
//    NSTableCellView *cell = [self viewAtColumn:0];
//    if (cell == nil) {
//        return;
//    }
//    cell.selected = selected;
}


- (void)didAddSubview:(NSView *)subview {
    [super didAddSubview:subview];
    if ([subview isKindOfClass:[NSButton class]] == NO) {
        return;
    }
    
    self.disclosureIndicatorButton = (NSButton *)subview;
    self.disclosureIndicatorButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self setNeedsUpdateConstraints:YES];
}

- (void)updateConstraints {
    if (self.didUpdateConstraints == NO && self.disclosureIndicatorButton) {
        NSButton *button = self.disclosureIndicatorButton;
        [button autoPinEdgeToSuperviewEdge:ALEdgeLeading];
        [button autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        self.didUpdateConstraints = YES;
    }
    [super updateConstraints];
}

- (void)drawSelectionInRect:(NSRect)dirtyRect {
    NSColor *primaryColor = self.primarySelectionColor;
    NSColor *secondarySelectedControlColor = self.secondarySelectionColor;
    
    switch (self.selectionHighlightStyle) {
        case NSTableViewSelectionHighlightStyleRegular: {
            if (self.selected) {
                if (self.emphasized) {
                    [primaryColor set];
                } else {
                    [secondarySelectedControlColor set];
                }
                NSRect bounds = self.bounds;
                const NSRect *rects = NULL;
                NSInteger count = 0;
                [self getRectsBeingDrawn:&rects count:&count];
                for (NSInteger i = 0; i < count; i++) {
                    NSRect rect = NSIntersectionRect(bounds, rects[i]);
                    NSRectFillUsingOperation(rect, NSCompositingOperationSourceOver);
                }
            }
            break;
        }
        default: {
            // Do super's drawing.
            [super drawSelectionInRect:dirtyRect];
            break;
        }
    }
}

@end
