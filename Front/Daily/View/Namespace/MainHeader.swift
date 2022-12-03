//
//  MainHeader.swift
//  Daily
//
//  Created by 최승용 on 2022/11/08.
//

import SwiftUI

//struct MainHeader: View {
//    @StateObject var popupInfo: PopupInfo
//    @Namespace var MonthToYear
//    var body: some View {
//        HStack {
////            HStack {
////                if popupInfo.state == "Month" {
////                    Label("2022년", systemImage: "chevron.left")
////                        .matchedGeometryEffect(id: "year", in: MonthToYear)
////                        .onTapGesture {
////                            withAnimation(.spring()) {
////                                popupInfo.state = "Year"
////                            }
////                        }
////                }
////            }
//            NavigationText(popupInfo: popupInfo, MonthToYear: MonthToYear)
//                .font(.system(size: 16, weight: .bold))
//                .foregroundColor(.mint)
//                .padding(4)
//                .frame(maxWidth: UIScreen.main.bounds.size.width / 3, alignment: .leading)
//            HStack {
//                if popupInfo.state == "Year" {
//                    Text("2022년")
//                        .scaleEffect(popupInfo.state == "Year" ? 1 : 0)
//                        .matchedGeometryEffect(id: "year", in: MonthToYear)
//                } else if popupInfo.state == "Month" {
//                    Text("12월")
//                }
//            }
//            .onTapGesture {
//                withAnimation(.easeOut) {
//                    popupInfo.state = "Month"
//                }
//            }
//            .font(.system(size: 20, weight: .bold))
//            .padding(4)
//            .frame(maxWidth: UIScreen.main.bounds.size.width / 3, alignment: .center)
//            HStack(spacing: 0) {
////                Button {
////                    print("test")
////                } label: {
////                    Text("testButton")
////                }
//                AddGoalButton(popupInfo: popupInfo)
//                ShowMenuButton(popupInfo: popupInfo)
//            }
//            .font(.system(size: 16, weight: .bold))
//            .frame(maxWidth: UIScreen.main.bounds.size.width / 3, alignment: .trailing)
//        }
//        .frame(maxHeight: 40)
//        .padding(.horizontal, 10)
//        
//        
////        VStack(alignment: .trailing) {
////            HStack(alignment: .top, spacing: 0) {
////                Spacer()
////                AddGoalButton(popupInfo: popupInfo)
////                ShowMenuButton(popupInfo: popupInfo)
////            }
////            .frame(maxHeight: 40)
////            Spacer()
////        }
//    }
//}
