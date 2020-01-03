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

struct CleanCommandOptions: OptionsProtocol {
    let outputFolder: String

    static func evaluate(_ mode: CommandMode) -> Result<CleanCommandOptions, CommandantError<SourceDocsError>> {
        return curry(self.init)
            <*> mode <| Option(key: "output-folder", defaultValue: SourceDocs.defaultOutputPath,
                               usage: "Output directory (defaults to \(SourceDocs.defaultOutputPath)).")
    }
}

struct CleanCommand: CommandProtocol {
    typealias Options = CleanCommandOptions

    let verb = "clean"
    let function = "Delete the output folder and quit."

    func run(_ options: CleanCommandOptions) -> Result<(), SourceDocsError> {
        do {
            try CleanCommand.removeReferenceDocs(docsPath: options.outputFolder)
            return Result.success(())
        } catch let error {
            return Result.failure(SourceDocsError.internalError(message: error.localizedDescription))
        }
    }

    static func removeReferenceDocs(docsPath: String) throws {
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
