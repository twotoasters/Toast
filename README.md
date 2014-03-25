## TWTToast

[![Build Status](https://travis-ci.org/twotoasters/Toast.png?branch=travis-ci)](https://travis-ci.org/twotoasters/Toast)

A repo for small utilities we use in Cocoa Development. Conveniently broken up into small subspecs for à la carte use.

### Subspecs

#### Core

`pod 'TWTToast/Core'`

A subspec chock full of low-level extensions.

##### TWTHighOrderFunctions

* **`TWTSimpleMap(id<NSObject, NSFastEnumeration> enumeration, TWTMapBlock block)`** provides a simple implementation of Map. Map recieves an enumeration of objects and applies the block to each item, returning the resulting array.

#### Foundation

`pod TWTToast/Foundation`

A subspec for Foundation-level classes and categories.

`pod TWTToast/Foundation/Categories`

A subspec for loading just categories on Foundation-level classes.

`pod TWTToast/Foundation/KVO`

* **`TWTKeyValueObserver`** exposes a method for encapsulating a KVO-based observation such that it can be more easily released.

##### ErrorUtilities

`pod TWTToast/Foundation/ErrorUtilities`

* **`TWTErrorUtilities`** defines utility functions for creating assertions and exception messages.

##### SubclassResponsibility

`pod TWTToast/Foundation/SubclassResponsibility`

* **`NSException+TWTSubclassResponsibility`** provides a convenience factory method for creating exceptions when implementing a given method is a subclass's responsibility.


#### UIKit

`pod 'TWTToast/UIKit'`

A subspec containing our humble extensions to UIKit.

##### AutoLayout

`pod 'TWTToast/UIKit/AutoLayout'`

* **`UIView+TWTConvenientConstraintAddition`** provides methods for adding constraints for several visual format strings with a single message send.

##### Blocks

`pod 'TWTToast/UIKit/Blocks'`

* **`UIActionSheet+TWTBlocks`** establishes a block-based means of handling UIActionSheets.
* **`UIAlertView+TWTBlocks`** does the same for UIAlertView, enabling easy block-based handling of UIAlertView input.

##### Color

`pod 'TWTToast/UIKit/Color'`

* **`UIColor+TWTColorHelpers`** is a collection of convenience methods for creating UIColors, e.g. from hexadecimal values.

##### Device

`pod 'TWTToast/UIKit/Device'`

* **`UIDevice+TWTSystemVersion`** provides convenient methods of retrieving and comparing iOS version information in a more performant way, using NSIntegers rather than string comparison.

##### Snapshot Image

`pod 'TWTToast/UIKit/SnapshotImage'`

* **`UIView+TWTSnapshotImage`** provides a convenient method for getting a snapshot image of a view’s hiearachy.

##### View Controller Transitions

`pod 'TWTToast/UIKit/ViewControllerTransitions'`

* **`TWTNavigationControllerDelegate`** conforms to the `UINavigationControllerDelegate` protocol and adds properties to UIViewController for specifying push and pop animation controllers.
* **`TWTSimpleAnimationController`** conforms to the `UIViewControllerAnimatedTransitioning` protocol and wraps `+[UIView transitionFromView:toView:duration:options:completion:]` to facilitate using built-in transitions provided by UIKit.


#### Mantle

`pod 'TWTToast/Mantle'`

A subspec containing various Mantle extensions used by Two Toasters.

##### Mantle Model

`pod 'TWTToast/Mantle/MantleModel'`

* **`TWTMantleModel`** contains basic extensions to `MTLModel`. For now, it simply adds the ability to exclude property keys from archiving, description, and equality checking.

##### Selective JSON Adapter

`pod 'TWTToast/Mantle/SelectiveJSONAdapter'`

* **`TWTSelectiveJSONAdapter`** extends `MTLJSONAdapter` to serialize only a subset of a model object’s property keys.


### Credits

TWTToast was created by developers at Two Toasters(@twotoasters) in order to collect our reusable code into one common repository, easily accessible via Cocoapods subspecs.

### License

All code in TWTToast is released under the MIT License. See the LICENSE file for more info.

