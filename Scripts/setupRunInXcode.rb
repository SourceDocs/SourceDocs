xcschema = <<END
<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "9999"
   version = "1.3">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "SourceDocs::SourceDocs"
               BuildableName = "SourceDocs"
               BlueprintName = "SourceDocs"
               ReferencedContainer = "container:SourceDocs.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      codeCoverageEnabled = "YES"
      shouldUseLaunchSchemeArgsEnv = "YES">
      <Testables>
         <TestableReference
            skipped = "NO">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "SourceDocs::SourceDocsTests"
               BuildableName = "SourceDocsTests.xctest"
               BlueprintName = "SourceDocsTests"
               ReferencedContainer = "container:SourceDocs.xcodeproj">
            </BuildableReference>
         </TestableReference>
      </Testables>
      <AdditionalOptions>
      </AdditionalOptions>
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "YES"
      customWorkingDirectory = "#{Dir.pwd}"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "NO">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "SourceDocs::SourceDocs"
            BuildableName = "SourceDocs"
            BlueprintName = "SourceDocs"
            ReferencedContainer = "container:SourceDocs.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
      <CommandLineArguments>
         <CommandLineArgument
            argument = "generate --clean --spm-module SourceDocsDemo --output-folder docs/reference --module-name-path"
            isEnabled = "YES">
         </CommandLineArgument>
      </CommandLineArguments>
      <AdditionalOptions>
      </AdditionalOptions>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Release"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
END

File.write("SourceDocs.xcodeproj/xcshareddata/xcschemes/SourceDocs.xcscheme", xcschema)
puts "Set up the run command for Xcode"
