
Pod::Spec.new do |spec|


  spec.name         = "AsyncEventBus"
  spec.version      = "0.0.1"
  spec.summary      = "A publish/subscribe event bus for iOS."

  spec.homepage     = "https://github.com/whf881211/AsyncEventBus"


  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "ryanhfwang" => "ryanhfwang@tencent.com" }
  spec.platform     = :ios, "9.0"
  spec.swift_versions = "4.0"
  spec.source       = { :git => "https://github.com/whf881211/AsyncEventBus.git", :tag => "0.0.1" }
  spec.source_files  = "EventBusExample/EventBusExample/source/*", "EventBusExample/EventBusExample/source/Protocol/*", "EventBusExample/EventBusExample/source/Imp/*"
  spec.exclude_files = ""
  spec.requires_arc = true



end
