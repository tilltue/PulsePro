// The MIT License (MIT)
//
// Copyright (c) 2020–2022 Alexander Grebenyuk (github.com/kean).

import SwiftUI
import Pulse

struct MessageDetailsViewPro: View {
    let viewModel: ConsoleMessageDetailsViewModel
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var isMetaVisible = false
    var onClose: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button(action: { isMetaVisible = true }) {
                    Image(systemName: "info.circle")
                }.padding(.leading, 4)
                if let badge = viewModel.badge {
                    BadgeView(viewModel: BadgeViewModel(title: badge.title, color: badge.color.opacity(colorScheme == .light ? 0.25 : 0.5)))
                }
                Spacer()
                if let onClose = onClose {
                    Button(action: onClose) {
                        Image(systemName: "xmark").foregroundColor(.secondary)
                    }.buttonStyle(PlainButtonStyle())
                }
            }
            .padding([.leading, .trailing], 6)
            .frame(height: 27, alignment: .center)
            Divider()
            ConsoleMetadataView(message: viewModel.message)
            textView
                .background(colorScheme == .dark ? Color(NSColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1)) : .clear)
        }
        .sheet(isPresented: $isMetaVisible, content: {
            VStack(spacing: 0) {
                HStack {
                    Text("Message Details")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Button("Close") { isMetaVisible = false }
                        .keyboardShortcut(.cancelAction)
                }.padding()
                ConsoleMessageMetadataView(message: viewModel.message)
            }.frame(width: 440, height: 600)
        })
    }

    private var textView: some View {
        RichTextViewPro(viewModel: .init(string: NSAttributedString(string: viewModel.text, attributes: [
            .foregroundColor: NSColor.labelColor,
            .font: NSFont.systemFont(ofSize: CGFloat(AppSettings.shared.messageFontSize)),
            .paragraphStyle: NSParagraphStyle.make(lineHeight: Constants.ResponseViewer.lineHeight(for: AppSettings.shared.messageFontSize))
        ])), content: .message)
    }
}

#if DEBUG
struct MessageDetailsViewPro_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MessageDetailsViewPro(viewModel: .init(message: try! LoggerStore.mock.allMessages()[0]))
                .previewLayout(.fixed(width: 600, height: 400))
        }
    }
}
#endif
