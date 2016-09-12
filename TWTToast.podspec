Pod::Spec.new do |s|
  s.name             = "TWTToast"
  s.version          = "0.19"
  s.summary          = "Tools and Utilities for Cocoa Development"
  s.homepage         = "https://github.com/twotoasters/Toast"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Two Toasters" => "general@twotoasters.com" }
  s.social_media_url = "http://twitter.com/twotoasters"
  s.platform         = :ios, '7.0'
  s.source           = { :git => "https://github.com/twotoasters/Toast.git", :tag => s.version.to_s }
  s.requires_arc     = true

  ## Subspec for CoreAnimation files
  s.subspec 'CoreAnimation' do |ss|
    ss.requires_arc = true

    ss.subspec 'EasingFunctions' do |sss|
      sss.requires_arc = true
      sss.source_files = "CoreAnimation/Easing Functions/*.{h,m}"
    end
  end

  ## Subspec for files related to Foundation
  s.subspec 'Foundation' do |ss|
    ss.requires_arc = true

    ss.subspec 'AsynchronousOperation' do |sss|
      sss.requires_arc = true
      sss.source_files = "Foundation/Asynchronous Operation/*.{h,m}"
    end

    ss.subspec 'BlockEnumeration' do |sss|
      sss.requires_arc = true
      sss.source_files = "Foundation/Block Enumeration/*.{h,m}"
    end

    ss.subspec 'ConcurrentAccessor' do |sss|
      sss.requires_arc = true
      sss.source_files = "Foundation/Concurrent Accessor/*.{h,m}"
    end

    ss.subspec 'DateRange' do |sss|
      sss.requires_arc = true
      sss.source_files = "Foundation/Date Range/*.{h,m}"
    end

    ss.subspec 'ErrorUtilities' do |sss|
      sss.requires_arc = true
      sss.source_files = "Foundation/Error Utilities/*.{h,m}"
    end

    ss.subspec 'KVO' do |sss|
      sss.requires_arc = true
      sss.source_files = "Foundation/KVO/*.{h,m}"
    end

    ss.subspec 'NSArrayIndexPathAdditions' do |sss|
      sss.requires_arc = true
      sss.source_files = "Foundation/NSArray Index Path Additions/*.{h,m}"
    end

    ss.subspec 'SubclassResponsibility' do |sss|
      sss.requires_arc = true
      sss.dependency 'TWTToast/Foundation/ErrorUtilities'
      sss.source_files = "Foundation/Subclass Responsibility/*.{h,m}"
    end

    ss.subspec 'TreeNode' do |sss|
      sss.requires_arc = true
      sss.source_files = "Foundation/Tree Node/*.{h,m}"
    end
  end

  ## Subspec for files related to UIKit
  s.subspec 'UIKit' do |ss|
    ss.requires_arc = true
    ss.subspec 'AutoLayout' do |sss|
      sss.requires_arc = true
      sss.source_files = "UIKit/Auto Layout/*.{h,m}"
    end

    ss.subspec 'BlockActions' do |sss|
      sss.requires_arc = true
      sss.source_files = "UIKit/Block Actions/*.{h,m}"
    end

    ss.subspec 'Blocks' do |sss|
      sss.requires_arc = true
      sss.source_files = "UIKit/Blocks/*.{h,m}"
    end

    ss.subspec 'Color' do |sss|
      sss.requires_arc = true
      sss.source_files = "UIKit/Color/*.{h,m}"
    end

    ss.subspec 'Device' do |sss|
      sss.requires_arc = true
      sss.source_files = "UIKit/Device/*.{h,m}"
    end

    ss.subspec 'Gradient' do |sss|
        sss.requires_arc = true
        sss.source_files = "UIKit/Gradient/*.{h,m}"
    end

    ss.subspec 'NibBackedView' do |sss|
      sss.requires_arc = true
      sss.source_files = "UIKit/Nib-Backed View/*.{h,m}"
    end

    ss.subspec 'PrepareForSegue' do |sss|
      sss.requires_arc = true
      sss.source_files = "UIKit/Prepare for Segue/*.{h,m}"
    end

    ss.subspec 'SnapshotImage' do |sss|
      sss.requires_arc = true
      sss.source_files = "UIKit/Snapshot Image/*.{h,m}"
    end

    ss.subspec 'TextStyle' do |sss|
      sss.requires_arc = true
      sss.source_files = "UIKit/Text Style/*.{h,m}"
    end

    ss.subspec 'ViewControllerCompletion' do |sss|
      sss.requires_arc = true
      sss.source_files = "UIKit/View Controller Completion/*.{h,m}"
    end

    ss.subspec 'ViewControllerTransitions' do |sss|
      sss.requires_arc = true
      sss.source_files = "UIKit/View Controller Transitions/*.{h,m}"
    end
  end

  ## Subspec for files related to Mantle
  s.subspec 'Mantle' do |ss|
    ss.requires_arc = true
    ss.dependency 'Mantle', '~> 1.4.0'

    ss.subspec 'MantleModel' do |sss|
      sss.requires_arc = true
      sss.source_files = "Mantle/Mantle Model/*.{h,m}"
    end

    ss.subspec 'ModelClassDeserialization' do |sss|
      sss.requires_arc = true
      sss.dependency 'TWTToast/Foundation/BlockEnumeration'
      sss.source_files = "Mantle/Model Class Deserialization/*.{h,m}"
    end

    ss.subspec 'SelectiveJSONAdapter' do |sss|
      sss.requires_arc = true
      sss.source_files = "Mantle/Selective JSON Adapter/*.{h,m}"
    end
  end
end
