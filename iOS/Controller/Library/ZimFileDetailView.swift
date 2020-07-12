//
//  ZimFileDetailView.swift
//  Kiwix
//
//  Created by Chris Li on 7/11/20.
//  Copyright © 2020 Chris Li. All rights reserved.
//

import Combine
import SwiftUI
import RealmSwift



@available(iOS 13.0, *)
struct ZimFileDetailView: View {
    let zimFile: ZimFile
    @ObservedObject private var viewModel: ViewModel
    
    init(zimFile: ZimFile) {
        self.zimFile = zimFile
        self.viewModel = ViewModel(zimFile)
    }
    
    var body: some View {
        List {
            if let language = viewModel.language { TitleDetailListRow(title: "Language", detail:  language)}
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
}

@available(iOS 13.0, *)
fileprivate class ViewModel: ObservableObject {
    private let database = try? Realm(configuration: Realm.defaultConfig)
    let zimFile: ZimFile
    
    var language: String? {
        Locale.current.localizedString(forLanguageCode: zimFile.languageCode)
    }
    
    init(_ zimFile: ZimFile) {
        self.zimFile = zimFile
    }
}

@available(iOS 13.0, *)
struct ZimFileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let zimFile = ZimFile(value: [
            "languageCode": "en"
        ])
        return ZimFileDetailView(zimFile: zimFile)
    }
}
