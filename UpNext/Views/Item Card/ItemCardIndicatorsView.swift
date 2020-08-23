//
//  ItemCardIndicatorsView.swift
//  UpNext
//
//  Created by Austin Barrett on 6/4/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

struct ItemCardIndicatorsView: View {
    @EnvironmentObject var model: DomainsModel
    var item: DomainItem
    
    var body: some View {
        VStack {
            HStack {
                if let foundItem = model.item(withId: item.id) {
                    if let _ = foundItem.releaseDate {
                        Image(systemName: "calendar")
                        Text(foundItem.displayDate)
                            .padding(.trailing)
                    }
                    Spacer()
                    if let _ = foundItem.notes {
                        Image(systemName: "note.text")
                            .transition(.identity)
                    }
                }
            }
            
        }
    }
}

 struct ItemCardIndicatorsView_Previews: PreviewProvider {
    static var basicItem = DomainItem.createMock(name: "Item Without Properties")
    static var dateItem = DomainItem.createMock(name: "Item With Date", releaseDate: Date(timeIntervalSinceReferenceDate: 600000000))
    static var notesItem = DomainItem.createMock(name: "Item With Notes", notes: "Well isn't that just a lovely little flipping story? Who d'ya thinks gonna believe that little fairy tale you've cooked up? Ha!")
    static var complexItem = DomainItem.createMock(name: "Item With Properties", notes: "Well isn't that just a lovely little flipping story? Who d'ya thinks gonna believe that little fairy tale you've cooked up? Ha!", moveOnRelease: true, releaseDate: Date(timeIntervalSinceReferenceDate: 600000000))

    static var previews: some View {
        VStack {
            Text("Indicators for Item without properties:")
                .font(.headline)
            ItemCardIndicatorsView(item: basicItem)
                .frame(width: 400)
                .padding()
                .border(Color.black)
            Text("Indicators for Item with date only:")
                .font(.headline)
            ItemCardIndicatorsView(item: dateItem)
                .frame(width: 400)
                .padding()
                .border(Color.black)
            Text("Indicators for Item with notes only:")
                .font(.headline)
            ItemCardIndicatorsView(item: notesItem)
                .frame(width: 400)
                .padding()
                .border(Color.black)
            Text("Indicators for Item with all properties:")
                .font(.headline)
            ItemCardIndicatorsView(item: complexItem)
                .frame(width: 400)
                .padding()
                .border(Color.black)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
 }
