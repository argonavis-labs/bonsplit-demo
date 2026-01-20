import SwiftUI
import Bonsplit

@main
struct BonsplitDemoApp: App {
    @State private var controller = BonsplitController()
    @State private var documents: [TabID: Document] = [:]
    @State private var documentCounter = 1

    var body: some Scene {
        WindowGroup {
            MainContentView(controller: controller, documents: $documents, documentCounter: $documentCounter)
                .frame(minWidth: 600, minHeight: 400)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(after: .newItem) {
                Button("New Tab") {
                    createNewDocument()
                }
                .keyboardShortcut("n", modifiers: .command)

                Divider()

                Button("Split Horizontally") {
                    _ = controller.splitPane(orientation: .horizontal)
                }
                .keyboardShortcut("d", modifiers: [.command, .shift])

                Button("Split Vertically") {
                    _ = controller.splitPane(orientation: .vertical)
                }
                .keyboardShortcut("d", modifiers: [.command, .option])
            }
        }
    }

    private func createNewDocument() {
        let title = "Untitled \(documentCounter).swift"
        let document = Document(title: title)
        if let tabId = controller.createTab(title: title, icon: "swift") {
            documents[tabId] = document
            documentCounter += 1
        }
    }
}

struct MainContentView: View {
    let controller: BonsplitController
    @Binding var documents: [TabID: Document]
    @Binding var documentCounter: Int

    var body: some View {
        BonsplitView(controller: controller) { tab in
            if let document = documents[tab.id] {
                DocumentEditor(document: document, controller: controller, tabId: tab.id)
            } else {
                emptyPaneView
            }
        } emptyPaneView: {
            emptyPaneView
        }
        .onAppear {
            createInitialTabs()
        }
    }

    private var emptyPaneView: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No Document Open")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Press ⌘N to create a new document")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .windowBackgroundColor))
    }

    private func createInitialTabs() {
        // Create 3 initial tabs like the demo screenshot
        for i in 1...3 {
            let title = "Document \(i).swift"
            let document = Document(title: title, content: sampleContent(for: i))
            if let tabId = controller.createTab(title: title, icon: "swift") {
                documents[tabId] = document
                documentCounter = i + 1
            }
        }
    }

    private func sampleContent(for index: Int) -> String {
        switch index {
        case 1:
            return """
            import SwiftUI

            struct ContentView: View {
                var body: some View {
                    Text("Hello, World!")
                }
            }
            """
        case 2:
            return """
            import Foundation

            class DataManager {
                static let shared = DataManager()

                func fetchData() async throws -> [String] {
                    // Implementation here
                    return []
                }
            }
            """
        case 3:
            return """
            import SwiftUI

            @main
            struct MyApp: App {
                var body: some Scene {
                    WindowGroup {
                        ContentView()
                    }
                }
            }
            """
        default:
            return ""
        }
    }
}
