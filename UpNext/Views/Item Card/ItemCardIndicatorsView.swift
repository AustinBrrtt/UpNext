//
//  ItemCardIndicatorsView.swift
//  UpNext
//
//  Created by Austin Barrett on 6/4/20.
//  Copyright © 2020 Austin Barrett. All rights reserved.
//

import SwiftUI

struct ItemCardIndicatorsView: View {
    var item: DomainItem
    
    var body: some View {
        VStack {
            HStack {
                if item.hasReleaseDate {
                    Image(systemName: "calendar")
                    Text(item.displayDate)
                        .padding(.trailing)
                }
                Spacer()
                if item.notes != nil {
                    Image(systemName: "note.text")
                        .transition(.identity)
                }
            }
            
        }
    }
}

 struct ItemCardIndicatorsView_Previews: PreviewProvider {
    static var basicItem = DomainItem(name: "Item Without Properties")
    static var dateItem: DomainItem {
        var item = DomainItem(name: "Item With Date")
        item.releaseDate = Date(timeIntervalSinceReferenceDate: 600000000)
        return item
    }
    static var notesItem: DomainItem {
        var item = DomainItem(name: "Item With Notes")
        item.notes = "Well isn't that just a lovely little flipping story? Who d'ya thinks gonna believe that little fairy tale you've cooked up? Ha!"
        return item
    }
    static var complexItem: DomainItem {
        var item = DomainItem(name: "Item With Properties")
        item.releaseDate = Date(timeIntervalSinceReferenceDate: 600000000)
        item.notes = "Well isn't that just a lovely little flipping story? Who d'ya thinks gonna believe that little fairy tale you've cooked up? Ha!"
        item.moveOnRelease = true
        return item
    }

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
