//
//  NoRecord.swift
//  Daily
//
//  Created by 최승용 on 3/15/24.
//

import SwiftUI

struct NoRecord: View {
    @StateObject var navigationViewModel: NavigationViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text(noRecordText)
            Button {
                navigationViewModel.setTagIndex(tagIndex: 1)
            } label: {
                Text(goRecordViewText)
            }
            Spacer()
        }
    }
}
