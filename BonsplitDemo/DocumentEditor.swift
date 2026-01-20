import SwiftUI
import Bonsplit

struct DocumentEditor: View {
    @Bindable var document: Document
    let controller: BonsplitController
    let tabId: TabID

    var body: some View {
        TextEditor(text: $document.content)
            .font(.system(.body, design: .monospaced))
            .scrollContentBackground(.hidden)
            .background(Color(nsColor: .textBackgroundColor))
            .padding(8)
            .onChange(of: document.content) { _, _ in
                if !document.isDirty {
                    document.isDirty = true
                    controller.updateTab(tabId, isDirty: true)
                }
            }
    }
}
