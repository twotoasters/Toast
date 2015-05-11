//
//  TWTNibBackedView.h
//  Toast
//
//  Created by Prachi Gauriar on 10/22/2014.
//  Copyright (c) 2015 Ticketmaster.
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
 The TWTNibBacking protocol simply declares the +nib message. This allows users of a class to easily
 get the nib that backs it. This is useful when doing things like, e.g., registering a nib for a
 UITableViewCell reuse identifier, which can be done like so:
 
     [tableView registerNib:[NibBackedCell nib] forCellReuseIdentifier:kReuseIdentifier];
 */
@protocol TWTNibBacking

/*!
 @abstract Returns the nib that backs instances of the receiver.
 @result A nib that backs instances of the receiver.
 */
+ (UINib *)nib;

@end


/*!
 TWTNibBackedView is an abstract class that makes it easy to create a view that is primarily laid
 out and configured using a nib. It is built to work correctly whether the view is instantiated in
 code or in a nib. 
 
 Using a nib-backed view requires that you do some basic setup.
 
     1. Set TWTNibBackedView as your nib-backed view’s superclass.
     2. In your view’s xib, set the File’s Owner’s class to your TWTNibBackedView subclass.
     3. Connect the File’s Owner contentView outlet to the top-level view in your xib.

 TWTNibBackedView attempts to choose reasonable defaults for nib-loading behavior, but allows you to
 customize it as needed. For example, by default, the nib that is used has the same name as your
 class, but if you want to change that, you can override +nibName. If you need to do something more
 complex to load a nib, you can override +nib. See the class documentation for more information.
 */
@interface TWTNibBackedView : UIView <TWTNibBacking>

/*! 
 @abstract The content view that your nib views are contained in.
 @discussion This outlet must be set in your xib. If it is not, an assertion will be raised when
     your backing nib’s objects are instantiated, which occurs during object initialization. You
     should not set this property outside of your xib.
 */
@property (nonatomic, strong) IBOutlet UIView *contentView;

/*!
 @abstract Returns a UINib instance for the nib that backs this view.
 @discussion The base implementation of this method returns the nib whose name is the the return
     value of +[self nibName] in the main bundle. Override this method if you need to look in a
     nib in a different bundle. Override +nibName to specify the name of the nib to load.
 @result A UINib instance for the nib that backs this view.
 */
+ (UINib *)nib;

/*!
 @abstract Returns the name of the nib that backs this view.
 @discussion This method is used to get the appropriate nib in +nib. The base implementation
     returns the receiver’s class name. You should override this method if you want to use a
     different class name or if you want to subclass a nib-backed view without using a different
     nib.
 @result The name of the nib that backs this view.
 */
+ (NSString *)nibName;

/*!
 @abstract Indicates that objects in the backing nib have been instantiated and the content view
     has been added to the receiver as a subview.
 @discussion The base implementation of this method does nothing. Subclasses should override this
     if they wish to perform some initialization after the nib has been loaded.
 */
- (void)didInstantiateObjectsInBackingNib __attribute__((objc_requires_super));

@end
