//
//  TitleDetailListRow.swift
//  kiwix
//
//  Created by Chris Li on 7/12/20.
//  Copyright © 2020 Chris Li. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct TitleDetailListRow: View {
    let title: String
    let detail: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(detail).foregroundColor(.secondary)
        }
    }
}

@available(iOS 13.0, *)
struct TitleDetailListRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            TitleDetailListRow(title: "File Size", detail: "5GB")
        }
    }
}
