//
//  ContentView.swift
//  Localizer
//
//  Created by Prateek Mahendrakar on 5/17/23.
//

import MarkdownUI
import SwiftUI

struct ContentView: View {
   // MARK: - Properties

   let pasteBoard = NSPasteboard.general

   @State var text = ""

   @State var isOutputAvailable = false

   @State var markdownoutput2 = ""
   @State var markdownoutput1 = ""

   @State var output: (strings: String, code: String) = ("", "")

   @State var copyText1 = "Copy"
   @State var copyText2 = "Copy"

   @State var systemImage1 = "doc.on.clipboard"
   @State var systemImage2 = "doc.on.clipboard"

   // MARK: - Body

   var body: some View {
      GeometryReader { _ in
         VStack {
            Text("Enter Text")
            TextField("Enter text", text: $text)

            Button("Generate") {
               withAnimation {
                  output = generateLocalization(input: text)
                  isOutputAvailable = true

                  markdownoutput1 = """
                  ```swift
                  \(output.strings)
                  ```
                  """

                  markdownoutput2 = """
                  ```swift
                  \(output.code)
                  ```
                  """
               }
            }

            if isOutputAvailable {
               Text("Strings")
                  .font(.caption)

               HStack(spacing: .zero) {
                  Markdown(
                     markdownoutput1
                  )
                  .markdownTheme(.gitHub)
                  .textSelection(.enabled)

                  Button {
                     pasteBoard.clearContents()
                     pasteBoard.writeObjects([output.strings as NSString])
                     copyText1 = "Copied!"
                     systemImage1 = "doc.on.clipboard.fill"

                     Task {
                        try await Task.sleep(for: .seconds(2))
                        copyText1 = "Copy"
                     }
                  } label: {
                     Label(copyText1, systemImage: systemImage1)
                  }
               }

               Text("Code")
                  .font(.caption)
                  .padding(.top, 20)

               HStack(spacing: .zero) {
                  Markdown(markdownoutput2)
                     .markdownTheme(.gitHub)
                     .textSelection(.enabled)

                  Button {
                     pasteBoard.clearContents()
                     pasteBoard.writeObjects([output.code as NSString])
                     copyText2 = "Copied!"
                     systemImage2 = "doc.on.clipboard.fill"

                     Task {
                        try await Task.sleep(for: .seconds(2))
                        copyText2 = "Copy"
                     }
                  } label: {
                     Label(copyText2, systemImage: systemImage2)
                  }
               }

               Button("Clear") {
                  withAnimation {
                     text = ""
                     markdownoutput1 = ""
                     markdownoutput2 = ""
                     isOutputAvailable = false
                  }
               }
            }
         }
         .padding()
      }
   }
}

func generateLocalization(input: String) -> (strings: String, code: String) {
   let camelCase = input.camelCased

   let string1 = "\"\(input)\" = \"\(camelCase)\";"
   let string2 = "static let \(camelCase) = String(localized: \"\(camelCase)\", comment: \"\(input)\")"

   return (string1, string2)
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
   }
}
