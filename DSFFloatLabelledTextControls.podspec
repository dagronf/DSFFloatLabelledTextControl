Pod::Spec.new do |s|
  s.name         = "DSFFloatLabelledTextControls"
  s.version      = "1.0"
  s.summary      = "A macOS Cocoa single-line NSTextField that implements the Float Label Pattern"
  s.description  = <<-DESC
    A macOS Cocoa single-line NSTextField that implements the Float Label Pattern.
  DESC
  s.homepage     = "https://github.com/dagronf/DSFFloatLabelledTextControl"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Darren Ford" => "dford_au-reg@yahoo.com" }
  s.social_media_url   = ""
  s.osx.deployment_target = "10.11"
  s.source       = { :git => ".git", :tag => s.version.to_s }
  s.source_files  = "DSFFloatLabelledTextControl/DSFFloatLabelledTextField.swift"
  s.frameworks  = "Cocoa"
  s.swift_version = "5.0"
end
