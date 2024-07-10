//
//  TutorialView.swift
//  Daily
//
//  Created by 최승용 on 7/9/24.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.presentationMode) var presentationMode
    var isFirst: Bool
    
    var body: some View {
        ZStack {
            CalendarView(userInfoViewModel: UserInfoViewModel(), calendarViewModel: CalendarViewModel())
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
                .padding()
                Spacer()
                if isFirst {
                    Button {
                        print("goMainView")
                    } label: {
                        Text("Daily 시작하기")
                    }
                } else {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("완료")
                    }
                }
            }
            .background {
                Rectangle()
                    .fill(.gray.opacity(0.5))
                    .ignoresSafeArea()
                    .onTapGesture {
                        print("background")
                    }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    TutorialView(isFirst: false)
}
