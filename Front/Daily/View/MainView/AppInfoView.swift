//
//  AppInfoView.swift
//  Daily
//
//  Created by 최승용 on 3/9/24.
//

import SwiftUI

struct AppInfoView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    
    var body: some View {
        ViewThatFits(in: .vertical) {
            VStack {
                AppInfo()
                GroupBox {
                    HStack {
                        Text("튜토리얼")
                            .foregroundColor(.gray)
                        
//                        NavigationLink {
//                            TutorialView(isFirst: false)
                        Button {
                            withAnimation {
                                alertViewModel.showToast(message: commingSoonToastMessage)
                            }
                        } label: {
                            Text("시작하기")
                                .fontWeight(.bold)
                        }
                        .hTrailing()
                    }
                }
                Spacer()
            }
                .padding()
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    AppInfo()
                    Spacer()
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AppInfoView()
}
