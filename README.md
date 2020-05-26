# ios-native-template

Step to change project name.
1. https://tecadmin.net/delete-commit-history-in-github/ follow this step to remove git history
2. Change root folder name inside finder
3. Open .xcworkspace file
4. Change root project name inside xcode
5. Edit the Podfile target name
6. Run `pod deintegrate -> pod install` in terminal inside the folder path
7. Open your project.xcworkspace, Edit Scheme -> Run -> Executable -> Set your target
8. Change bundle name, signing profile, etc
