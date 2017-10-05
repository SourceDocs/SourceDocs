import Foundation

let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
SourceDocs().run(arguments: arguments)
