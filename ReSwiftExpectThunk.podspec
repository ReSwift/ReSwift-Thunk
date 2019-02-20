Pod::Spec.new do |spec|
  spec.name         = "ReSwiftExpectThunk"
  spec.version      = "1.1.0"
  spec.summary      = "Thunk testing for ReSwift."
  spec.description  = <<-DESC
                      ReSwiftExpectThunk allows you to test your Thunks.
                      DESC

  spec.homepage     = "https://github.com/ReSwift/ReSwift-Thunk"
  spec.license      = { :type => "MIT", :file => "LICENSE.md" }
  spec.authors      = "ReSwift"

  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.10"
  spec.watchos.deployment_target = '2.0'
  spec.tvos.deployment_target = '9.0'

  spec.module_name  = "ReSwiftExpectThunk"
  spec.swift_version = "4.2"
  spec.source = {
    :git => "https://github.com/ReSwift/ReSwift-Thunk.git",
    :tag => spec.version.to_s }
  spec.source_files = "ReSwift-ThunkTests/ExpectThunk.swift"

  spec.framework    = 'XCTest'
  spec.dependency "ReSwiftThunk"
end
