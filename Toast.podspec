Pod::Spec.new do |s|
  s.name             = "Toast"
  s.version          = "0.0.1"
  s.summary          = "Tools and Utilities for Cocoa Development"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Two Toasters" => "general@twotoasters.com" }
  s.social_media_url = "http://twitter.com/twotoasters"
  s.platform         = :ios, '6.0'
  s.source           = { :git => "http://github.com/twotoasters/Toast.git", :tag => "0.0.1" }
  s.requires_arc     = true

  ## Subspec for Files Related to UIKit
  s.subspec 'UIKit' do |sp|
    sp.source_files = "UIKit/*.{h,m}"
  end

end
