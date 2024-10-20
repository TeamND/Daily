//
//  TutorialView.swift
//  Daily
//
//  Created by 최승용 on 7/9/24.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isShowSecondSheet: Bool = false
    @State var isShowThirdSheet: Bool = false
    
    var body: some View {
        TutorialFirstView(isShowSecondSheet: $isShowSecondSheet)
            .navigationBarHidden(true)
            .sheet(isPresented: $isShowSecondSheet) {
                TutorialSecondView(isShowThirdSheet: $isShowThirdSheet)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
                    .sheet(isPresented: $isShowThirdSheet) {
                        ZStack {
                            TutorialThirdView()
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button {
                                        self.presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        Text("완료")
                                    }
                                }
                            }
                            .padding()
                        }
                            .presentationDetents([.large])
                            .presentationDragIndicator(.visible)
                }
            }
    }
}

#Preview {
    TutorialView()
}
