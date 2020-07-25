//
//  ZimFileDetailView.swift
//  Kiwix
//
//  Created by Chris Li on 7/11/20.
//  Copyright © 2020 Chris Li. All rights reserved.
//

import Combine
import SwiftUI
import UIKit
import RealmSwift

@available(iOS 13.0, *)
struct ZimFileDetailView: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(zimFile: ZimFile) {
        self.viewModel = ViewModel(zimFile)
    }
    
    var body: some View {
        List {
            Section {
                TitleDetailListRow(title: "Language", detail:  viewModel.language)
                TitleDetailListRow(title: "Size", detail:  viewModel.size)
                TitleDetailListRow(title: "Date", detail:  viewModel.creationDate)
            }
            Section {
                TitleDetailListRow(title: "Index", detail:  viewModel.hasIndex)
                TitleDetailListRow(title: "Pictures", detail:  viewModel.hasPictures)
                TitleDetailListRow(title: "Videos", detail:  viewModel.hasVideos)
                TitleDetailListRow(title: "Details", detail:  viewModel.hasDetails)
            }
            Section {
                TitleDetailListRow(title: "Article Count", detail:  viewModel.articleCount)
                TitleDetailListRow(title: "Media Count", detail:  viewModel.mediaCount)
            }
            Section {
                TitleDetailListRow(title: "Creator", detail:  viewModel.creator)
                TitleDetailListRow(title: "Publisher", detail:  viewModel.publisher)
            }
            Section {
                TitleDetailListRow(title: "ID", detail:  viewModel.shortID)
            }
            Section {
                Button(action: {
                    
                }) {
                    HStack {
                        Spacer()
                        Text("Delete File").fontWeight(.medium)
                        Spacer()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    .listRowInsets(EdgeInsets(top: 0, leading: 150, bottom: 0, trailing: 150))
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
}

//@available(iOS 13.0, *)
//extension View {
//
//    func readableGuidePadding() -> some View {
//        modifier(ReadableGuidePadding())
//    }
//
//}
//
//@available(iOS 13.0, *)
//private struct ReadableGuidePadding: ViewModifier {
//
//    @Environment(\.horizontalSizeClass) var horizontal
//
//    func body(content: Content) -> some View {
//       content.padding(.horizontal, horizontal == .regular ? 84: 16)
//    }
//
//}

@available(iOS 13.0, *)
fileprivate class ViewModel: ObservableObject {
    private let database = try? Realm(configuration: Realm.defaultConfig)
    let zimFile: ZimFile
    private let unknown = "Unknown"
    private let countFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var language: String {
        Locale.current.localizedString(forLanguageCode: zimFile.languageCode) ?? unknown
    }
    
    var size: String {
        zimFile.sizeDescription ?? unknown
    }
    
    var creationDate: String {
        zimFile.creationDateDescription ?? unknown
    }
    
    var hasIndex: String {
        zimFile.hasIndex ? "Yes" : "No"
    }
    
    var hasPictures: String {
        zimFile.hasPictures ? "Yes" : "No"
    }
    
    var hasVideos: String {
        zimFile.hasVideos ? "Yes" : "No"
    }
    
    var hasDetails: String {
        zimFile.hasDetails ? "Yes" : "No"
    }
    
    var articleCount: String {
        countFormatter.string(for: zimFile.articleCount.value) ?? unknown
    }
    
    var mediaCount: String {
        countFormatter.string(for: zimFile.mediaCount.value) ?? unknown
    }
    
    var creator: String {
        zimFile.creator ?? unknown
    }
    
    var publisher: String {
        zimFile.publisher ?? unknown
    }
    
    var shortID: String {
        String(zimFile.id.prefix(8))
    }
    
    init(_ zimFile: ZimFile) {
        self.zimFile = zimFile
    }
}

@available(iOS 13.0, *)
struct ZimFileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let zimFile = ZimFile(value: [
            "id": "d87a3cf1-545b-49a0-ad51-108547970796",
            "languageCode": "en",
            "size": 1000000000,
            "creationDate": Date(),
            "hasIndex": true,
            "hasPictures": false,
            "hasVideos": true,
            "hasDetails": false,
            "articleCount": 10000000,
            "mediaCount": 1000,
            "creator": "Home Lab",
            "publisher": "Kiwix"
        ])
        return ZimFileDetailView(zimFile: zimFile)
    }
}

@available(iOS 13.0, *)
class ZimFileDetailController: UIHostingController<ZimFileDetailView> {
    convenience init(zimFile: ZimFile) {
        self.init(rootView: ZimFileDetailView(zimFile: zimFile))
    }
}
