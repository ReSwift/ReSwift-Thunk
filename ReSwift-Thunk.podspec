Pod::Spec.new do |spec|
  spec.name         = "ReSwift-Thunk"
  spec.version      = "1.0.0-pre"
  spec.summary      = "Thunk middleware for ReSwift."
  spec.description  = <<-DESC
                      ReSwift-Thunk allows you to write action creators that return a function instead of an action. Instead of dispatching an `Action` directly, you can dispatch a `Thunk` that creates an action at a later time, for example after a network request finishes.
                      DESC

  spec.homepage     = "https://github.com/ReSwift/ReSwift-Thunk"
  spec.license      = { :type => "MIT", :file => "LICENSE.md" }
  spec.authors      = "ReSwift"

  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.10"
  spec.watchos.deployment_target = '2.0'
  spec.tvos.deployment_target = '9.0'

  spec.swift_version = "4.2"
  spec.source = {
    :git => "https://github.com/ReSwift/ReSwift-Thunk.git",
    :tag => spec.version.to_s }
  spec.source_files = "ReSwift-Thunk"

  spec.dependency "ReSwift", "~> 4.0"
end
