# macOS Float Label Pattern Text Field

A macOS Cocoa single-line NSTextField/NSSecureTextField that implements the Float Label Pattern. 
You can read about the float pattern [here](http://mds.is/float-label-pattern/). 

![](https://img.shields.io/github/v/tag/dagronf/DSFFloatLabelledTextControl) ![](https://img.shields.io/badge/macOS-10.11+-red) ![](https://img.shields.io/badge/Swift-5.4-orange.svg) ![](https://img.shields.io/badge/ObjectiveC-2.0-purple.svg)
![](https://img.shields.io/badge/License-MIT-lightgrey) [![](https://img.shields.io/badge/pod-compatible-informational)](https://cocoapods.org) [![](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)

## Screenshot

![](https://github.com/dagronf/dagronf.github.io/raw/master/art/projects/DSFFloatingLabel/floating_label_text_field.gif)

## Why?

I was curious as to whether this pattern would work for a Mac program.  I wanted this to be a basic drop-in for an existing text field, using the NSTextField `placeholderString` value as the floating label title.

## Installation

### Swift Package Manager

Add `https://github.com/dagronf/DSFFloatLabelledTextControl` to your project.

### Cocoapods

Add `pod 'DSFFloatLabelledTextControl', :git => 'https://github.com/dagronf/DSFFloatLabelledTextControl'` to your podfile.

## Usage

### Interface builder

* Drop in a new Text Field into your canvas and set its class to `DSFFloatLabelledTextField` or
 `DSFFloatLabelledSecureTextControl` depending on whether you need a secure field
* Set the size and style of your primary font as you would a regular text field
* Set the size of the secondary font via the attributes inspector for the control

### Dynamically

```swift
let field = DSFFloatLabelledTextField()
field.placeholderString = "Dynamic Created"
field.font = NSFont.systemFont(ofSize: 16)
parentView.addSubview(field)
		
/// Setup autolayout constraints etc.
```

## Custom Properties

These controls inherit from `NSTextField`, so all `NSTextField` functionalities (like cocoa binding and Interface Builder settings) are available.  If you can use an NSTextField, you can use this control.

* `placeholderTextSize` - the size of the text used in the floating label (in pt)
* `placeholderSpacing` - the distance between the text field text and the floating label (in px)

## Delegate Handling

You can specify a delegate (`floatLabelDelegate`), either programatically or via Interface Builder, to receive additional information regarding the actions of the control.

## Screenshot

<img src="https://github.com/dagronf/dagronf.github.io/blob/master/art/projects/DSFFloatingLabel/light-mode-secure-field.png?raw=true" alt="drawing" width="265"/>

## Credits

* Pattern devised by [Matt D. Smith](http://mds.is/matt/)
* Read about the pattern [here](http://mds.is/float-label-pattern/)
* [UITextField implementation](https://github.com/jverdi/JVFloatLabeledTextField)

## Versions

* `2.0.0`: Moved secure text field into separate class (fixing security warnings in modern Xcode) 
* `1.8.0`: Added secure text field support, delegate support

## License

```
MIT License

Copyright (c) 2023 Darren Ford

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
