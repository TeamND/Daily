//
//  NoRecord.swift
//  Daily
//
//  Created by 최승용 on 3/15/24.
//

import SwiftUI

struct NoRecord: View {
    @StateObject var tabViewModel: TabViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text("No Record")
            Button {
                tabViewModel.setTagIndex(tagIndex: 1)
            } label: {
                Text("Go to add Goal")
            }
            Spacer()
        }
    }
}
