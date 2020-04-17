//
//  Clean.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/24/17.
//

import Foundation
import Commandant
import Curry
import Rainbow
import SourceDocsLib

public struct CleanCommandOptions: OptionsProtocol {
    let outputFolder: String

    /// Initializer for options for the Clean command.
    ///
    /// - Parameter outputFolder: Output directory (defaults to "Documentation/Reference").
    public init(outputFolder: String = SourceDocsLib.defaultOutputPath) {
        self.outputFolder = outputFolder
    }

    public static func evaluate(_ mode: CommandMode) -> Result<CleanCommandOptions, CommandantError<SourceDocsError>> {
        return curry(self.init)
            <*> mode <| Option(key: "output-folder", defaultValue: SourceDocsLib.defaultOutputPath,
                               usage: "Output directory (defaults to \(SourceDocsLib.defaultOutputPath)).")
    }
}

public struct CleanCommand: CommandProtocol {
    public typealias Options = CleanCommandOptions

    public let verb = "clean"
    public let function = "Delete the output folder and quit."

    public func run(_ options: CleanCommandOptions) -> Result<(), SourceDocsError> {
        do {
            try CleanCommand.removeReferenceDocs(docsPath: options.outputFolder)
            return Result.success(())
        } catch let error {
            return Result.failure(SourceDocsError.internalError(message: error.localizedDescription))
        }
    }

    public static func removeReferenceDocs(docsPath: String) throws {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: docsPath, isDirectory: &isDir) {
            fputs("Removing reference documentation at '\(docsPath)'...".green, stdout)
            do {
                try FileManager.default.removeItem(atPath: docsPath)
                fputs(" ✔".green + "\n", stdout)
            } catch let error {
                fputs(" ❌\n", stdout)
                throw error
            }
        } else {
            fputs("Did not find any reference docs at '\(docsPath)'.\n", stdout)
        }
    }

}
