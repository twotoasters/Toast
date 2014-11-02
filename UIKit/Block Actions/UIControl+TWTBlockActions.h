//
//  UIControl+TWTBlockActions.h
//  Toast
//
//  Created by Prachi Gauriar on 10/23/2014.
//  Copyright (c) 2014 Two Toasters, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>


/*!
 The TWTBlockActions category of UIControl adds methods for adding and removing actions to a control
 that use blocks instead of typical target objects with action selectors.
 */
@interface UIControl (TWTBlockActions)

/*!
 @abstract Adds the specified block as a block action that fires when the specified control events
     occur.
 @param controlEvents A bitmask specifying the control events associated with the block action.
 @param block The block to execute when the specified control events occur. May not be nil.
 @result An opaque object representing the block action. This may be used to remove a block action
     from the receiver using -twt_removeBlockAction.
 */
- (id)twt_addBlockActionForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender, UIEvent *event))block;

/*!
 @abstract Removes the specified block action from the receiver.
 @discussion Removing block actions by invoking -removeTarget:action:forControlEvents:, e.g., with a
     nil target and NULL action will also remove block actions. However, doing so will defer
     releasing the memory associated with the block action until the receiver is deallocated. Using
     this method will release the memory earlier, if possible. The memory footprint of a block action
     is small, so this should not be a huge concern.
 @param action The opaque block action object that was returned by -twt_addBlockActionForControlEvents:block:
 */
- (void)twt_removeBlockAction:(id)action;

@end
