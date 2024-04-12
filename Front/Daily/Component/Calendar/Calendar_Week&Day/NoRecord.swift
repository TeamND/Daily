//
//  NoRecord.swift
//  Daily
//
//  Created by 최승용 on 3/15/24.
//

import SwiftUI

struct NoRecord: View {
    @ObservedObject var userInfo: UserInfo
    @ObservedObject var navigationViewModel: NavigationViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text(noRecordText)
            NavigationLink {
                RecordView(userInfo: userInfo, navigationViewModel: navigationViewModel)
            } label: {
                Text(goRecordViewText)
            }
            Spacer()
        }
    }
}
