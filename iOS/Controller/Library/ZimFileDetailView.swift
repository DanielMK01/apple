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

@available(iOS 14.0, *)
struct ZimFileDetailView: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(zimFile: ZimFile) {
        self.viewModel = ViewModel(zimFile)
    }
    
    var body: some View {
        List {
            if viewModel.zimFileState == .onDevice {
                Button(action: {
                    
                }, label: {
                    CenteredButtonLabel(text: "Open Main Page")
                })
            }
            Section {
                switch viewModel.zimFileState {
                case .remote:
                    Button(action: {
                        DownloadService.shared.start(zimFileID: viewModel.zimFile.id, allowsCellularAccess: false)
                    }, label: {
                        CenteredButtonLabel(text: "Download")
                    })
                default:
                    Text("")
                }
            }
            Section {
                TitleDetailListRow(title: "Language", detail:  viewModel.language)
                TitleDetailListRow(title: "Size", detail:  viewModel.size)
                TitleDetailListRow(title: "Date", detail:  viewModel.creationDate)
            }
            Section {
                CapabilityListRow(title: "Index", isAvailable: viewModel.zimFile.hasIndex)
                CapabilityListRow(title: "Pictures", isAvailable: viewModel.zimFile.hasPictures)
                CapabilityListRow(title: "Videos", isAvailable: viewModel.zimFile.hasVideos)
                CapabilityListRow(title: "Details", isAvailable: viewModel.zimFile.hasDetails)
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
            if viewModel.zimFileState == .onDevice {
                Button(action: {
                    
                }, label: {
                    CenteredButtonLabel(text: "Delete File").foregroundColor(.red)
                })
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(viewModel.zimFile.title)
        .onAppear {
            UITableView.appearance(
                whenContainedInInstancesOf: [ZimFileDetailController.self]
            ).cellLayoutMarginsFollowReadableWidth = true
        }
    }
}

@available(iOS 14.0, *)
fileprivate struct CenteredButtonLabel: View {
    let text: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(text).fontWeight(.medium)
            Spacer()
        }
    }
}

@available(iOS 14.0, *)
fileprivate struct CapabilityListRow: View {
    let title: String
    let isAvailable: Bool

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if isAvailable {
                Image(systemName: "checkmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(.green)
            } else{
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(.red)
            }
        }
    }
}

@available(iOS 14.0, *)
fileprivate class ViewModel: ObservableObject {
    let zimFile: ZimFile
    @Published private(set) var zimFileState: ZimFile.State
    
    private let database = try? Realm(configuration: Realm.defaultConfig)
    private var token : NotificationToken?
    private let unknown = "Unknown"
    private let countFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    init(_ zimFile: ZimFile) {
        self.zimFile = zimFile
        self.zimFileState = zimFile.state
        self.token = zimFile.observe { [unowned self] change in
            switch change {
            case .change(zimFile, _):
                zimFileState = zimFile.state
            case .deleted:
                break
            default:
                break
            }
        }
    }
    
    var language: String {
        Locale.current.localizedString(forLanguageCode: zimFile.languageCode) ?? unknown
    }
    
    var size: String {
        zimFile.sizeDescription ?? unknown
    }
    
    var creationDate: String {
        zimFile.creationDateDescription ?? unknown
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
}

@available(iOS 14.0, *)
fileprivate struct ZimFileDetailView_Previews: PreviewProvider {
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

@available(iOS 14.0, *)
class ZimFileDetailController: UIHostingController<ZimFileDetailView> {
    convenience init(zimFile: ZimFile) {
        self.init(rootView: ZimFileDetailView(zimFile: zimFile))
    }
}
