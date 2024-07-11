//
//  TutorialFirstView.swift
//  Daily
//
//  Created by 최승용 on 7/11/24.
//

import SwiftUI

struct TutorialFirstView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isShowSecondSheet: Bool
    
    var body: some View {
        ZStack {
            CalendarView(userInfoViewModel: UserInfoViewModel(), calendarViewModel: CalendarViewModel(isTutorial: true))
            VStack {
                HStack {
                    Spacer()
                    Text("1 / 3")
                        .padding(CGFloat.fontSize * 1.5)
                        .font(.system(size: CGFloat.fontSize * 2, weight: .bold))
                        .foregroundStyle(.primary)
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("ThemeColor"))
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.primary, lineWidth: 1)
                            }
                        }
                }
                Spacer()
                HStack {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("완료")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .background {
                Rectangle()
                    .fill(.gray.opacity(0.6))
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowSecondSheet = true
                    }
            }
        }
    }
}

#Preview {
    TutorialFirstView(isShowSecondSheet: .constant(false))
}
