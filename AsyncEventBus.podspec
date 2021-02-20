
Pod::Spec.new do |spec|


  spec.name         = "AsyncEventBus"
  spec.version      = "0.0.4"
  spec.summary      = "A publish/subscribe event bus for iOS."

  spec.homepage     = "https://github.com/whf881211/AsyncEventBus"


  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "whf881211" => "whf881211@gmail.com" }
  spec.platform     = :ios, "9.0"
  spec.swift_versions = "4.0"
  spec.source       = { :git => "https://github.com/whf881211/AsyncEventBus.git", :tag => "0.0.4" }
  spec.source_files  = "source/*.swift", "source/Protocol/*", "source/Imp/*"
  spec.exclude_files = ""
  spec.requires_arc = true



end
