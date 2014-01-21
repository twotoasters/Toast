## TWTToast

[![Build Status](https://travis-ci.org/twotoasters/Toast.png?branch=travis-ci)](https://travis-ci.org/twotoasters/Toast)

A repo for small utilities we use in Cocoa Development. Conveniently broken up into small subspecs for à la carte use.

### Subspecs

#### Core

`pod 'TWTToast/Core'`

A subspec chock full of Foundation extensions and similar utilities.

##### TWTHighOrderFunctions

* **`TWTSimpleMap(id<NSObject, NSFastEnumeration> enumeration, TWTMapBlock block)`** provides a simple implementation of Map. Map recieves an enumeration of objects and applies the block to each item, returning the resulting array.

#### UIKit

`pod 'TWTToast/UIKit'`

A subspec containing our humble extensions to UIKit.

##### AutoLayout

`pod 'TWTToast/UIKit/AutoLayout'`

* **`UIView+TWTConvenientConstraintAddition`** provides methods for adding constraints for several visual format strings with a single message send.

##### Color

`pod 'TWTToast/UIKit/Color'`

* **`UIColor+TWTColorHelpers`** is a collection of convenience methods for creating UIColors, e.g. from hexadecimal values.

##### Device

`pod 'TWTToast/UIKit/Device'`

* **`UIDevice+TWTSystemVersion`** provides convenient methods of retrieving and comparing iOS version information in a more performant way, using NSIntegers rather than string comparison.

##### Blocks

`pod 'TWTToast/UIKit/Blocks'`

* **`UIActionSheet+TWTBlocks`** establishes a block-based means of handling UIActionSheets.
* **`UIAlertView+TWTBlocks`** does the same for UIAlertView, enabling easy block-based handling of UIAlertView input.

### Credits

TWTToast was created by developers at Two Toasters(@twotoasters) in order to collect our reusable code into one common repository, easily accessible via Cocoapods subspecs.

### License

All code in TWTToast is released under the MIT License. See the LICENSE file for more info.

