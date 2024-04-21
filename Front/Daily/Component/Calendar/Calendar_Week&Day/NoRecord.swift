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
    @State var updateVersion: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Text(noRecordText)
            if updateVersion {
                NavigationLink(value: "addGoal") {
                    Text(goRecordViewText)
                }
            } else {
                NavigationLink {
                    RecordView(userInfo: userInfo, navigationViewModel: navigationViewModel)
                } label: {
                    Text(goRecordViewText)
                }
            }
            Spacer()
        }
    }
}
