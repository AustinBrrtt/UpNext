//
//  ImportExportView.swift
//  UpNextMkII
//
//  Created by Austin Barrett on 5/10/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

struct ImportExportView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var domains: [Domain]
    
    let prettyPrint = false
    
    @State var importText: String = ""
    @State var exportText: String = ""
    @State var showImport: Bool = true
    
    let failureMessage: String = "Failed to Export data"
    
    var body: some View {
        VStack {
            Text("This page will not appear in the final build and is intended to make major changes during development less risky")
                .font(.footnote)
            Picker(selection: $showImport, label: Text("Import/Export")) {
                Text("Import").tag(true)
                Text("Export").tag(false)
            }.pickerStyle(SegmentedPickerStyle())
            if (showImport) {
                TextField("Import", text: $importText)
                Button(action: {
                    importData()
                }) {
                    Text("Import Data")
                }
            }
            if (!showImport) {
                // Toggle(isOn: $prettyPrint) { Text("Pretty Print?") }
                TextField("Export", text: $exportText)
                    .onAppear {
                        exportText = exportedData(prettyPrint: prettyPrint)
                    }
            }
            Spacer()
        }.padding()
            .navigationBarTitle(Text("Import/Export"), displayMode: .inline)
    }
    
    private func exportedData(prettyPrint: Bool) -> String {
        let encoder = JSONEncoder()
        if prettyPrint {
            encoder.outputFormatting = .prettyPrinted
        }
        if let data = try? encoder.encode(CodableRoot(domains: domains)) {
            return String(data: data, encoding: .utf8) ?? failureMessage
        }
        return failureMessage
    }
    
    private func importData() {
        guard let codable = CodableRoot.fromJSONString(importText) else {
            print("Failed to import data")
            return
        }
        if let _ = try? codable.overwrite(domains: domains) {
            goBack()
        }
    }
    
    private func goBack() {
        presentationMode.wrappedValue.dismiss()
    }

}

struct ImportExportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportExportView(domains: .constant([]))
    }
}
