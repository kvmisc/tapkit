Pod::Spec.new do |s|
  s.name         = "tapkit"
  s.version      = "2.0.9"
  s.summary      = "An Objective-C library for iPhone developers."
  s.homepage     = "https://github.com/kvmisc/tapkit"
  s.license      = "MIT"
  s.author       = { "Kevin Wu" => "kvmisc@163.com" }
  s.platform     = :ios, "8.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/kvmisc/tapkit.git", :tag => s.version.to_s }
  s.source_files  = "tapkit/*"
end
