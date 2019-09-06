Pod::Spec.new do |spec|
  spec.name         = "ReSwiftThunk"
  spec.version      = "1.2.0"
  spec.summary      = "Thunk middleware for ReSwift."
  spec.description  = <<-DESC
                      ReSwift-Thunk allows you to write action creators that return a function instead of an action. Instead of dispatching an `Action` directly, you can dispatch a `Thunk` that creates an action at a later time, for example after a network request finishes.
                      DESC

  spec.homepage     = "https://github.com/ReSwift/ReSwift-Thunk"
  spec.license      = { :type => "MIT", :file => "LICENSE.md" }
  spec.authors      = "ReSwift"

  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.10"
  spec.watchos.deployment_target = "2.0"
  spec.tvos.deployment_target = "9.0"

  spec.module_name  = "ReSwiftThunk"
  spec.swift_versions = ["5.0", "4.2", "4.1"]
  spec.source = {
    :git => "https://github.com/ReSwift/ReSwift-Thunk.git",
    :tag => spec.version.to_s }

  spec.subspec "Core" do |sp|
    sp.source_files = "ReSwift-Thunk"
  end

  spec.subspec "ExpectThunk" do |sp|
    sp.ios.deployment_target = "8.0"
    sp.osx.deployment_target = "10.10"
    sp.tvos.deployment_target = "9.0"
    sp.dependency "ReSwiftThunk/Core"
    sp.pod_target_xcconfig = { "ENABLE_BITCODE" => "NO" }
    sp.framework    = "XCTest"
    sp.source_files = "ReSwift-ThunkTests/ExpectThunk.swift"
  end

  spec.default_subspec = "Core"

  spec.dependency "ReSwift", "~> 5.0"
end
