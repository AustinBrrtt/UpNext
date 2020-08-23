//
//  MultilineTextField.swift
//  UpNext
//
//  Created by Austin Barrett on 5/13/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

struct MultilineTextField: View {
    @State var delayIsOver: Bool = false // Delay showing UITextView to work around NavigationView bug
    @State var viewHeight: CGFloat
    @Binding var text: String
    
    let lineHeight: CGFloat = 40
    var placeholder: String
    var accessibilityIdentifier: String
    
    var placeholderText: String { text.isEmpty ? placeholder : (delayIsOver ? "" : "Loading...") }
    
    init (_ placeholder: String, text: Binding<String>, accessibilityIdentifier: String = "Multiline Text") {
        self.placeholder = placeholder
        self.accessibilityIdentifier = accessibilityIdentifier
        self._text = text
        
        let lineCount: CGFloat = text.wrappedValue.reduce(0) { (count, char) in
            char == "\n" ? count + 1 : count
        }
        self._viewHeight = State<CGFloat>(initialValue: lineCount * lineHeight)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack {
                Text(placeholderText)
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            delayIsOver = true
                        }
                    }
                Spacer()
            }
            if (delayIsOver) {
                UITextViewWrapper(text: $text, calculatedHeight: $viewHeight, accessibilityIdentifier: accessibilityIdentifier)
                    .frame(minHeight: viewHeight, maxHeight: viewHeight)
            }
        }
    }
}

private struct UITextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var accessibilityIdentifier: String
    
    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isEditable = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.clear
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.accessibilityIdentifier = accessibilityIdentifier
        textView.isAccessibilityElement = true
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        UITextViewWrapper.recalculateHeight(view: uiView, currentHeight: $calculatedHeight)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, height: $calculatedHeight)
    }
    
    private static func recalculateHeight(view: UIView, currentHeight: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if currentHeight.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                currentHeight.wrappedValue = newSize.height // call in next render cycle.
            }
        }
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        @Binding var calculatedHeight: CGFloat
        
        init(text: Binding<String>, height: Binding<CGFloat>) {
            self._text = text
            self._calculatedHeight = height
        }
        
        func textViewDidChange(_ uiView: UITextView) {
            text = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, currentHeight: $calculatedHeight)
        }
    }
}

struct MultilineTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MultilineTextField("Enter all of your darkest secrets...", text: .constant(""))
            MultilineTextField("Enter all of your darkest secrets...", text: .constant("Did I mention the other day that I think that tacos are the only food that does not contain a secret deposit of expensive minerals normally found only deep within the intestines of a gorilla-whale?"))
        }
        .padding()
        .previewLayout(.fixed(width: 400, height: 100))
    }
}
