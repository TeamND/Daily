//
//  Calendar_Year.swift
//  Daily
//
//  Created by 최승용 on 2022/11/06.
//

import SwiftUI

struct Calendar_Year: View {
    @Binding var isActive: Bool
    var body: some View {
        VStack {
            NavigationLink(destination: Calendar_Month(), isActive: $isActive) {
                Text("Year Calender")
            }
        }
        .navigationBarTitle("2022 년", displayMode: .inline)
        .navigationBarItems(
            trailing: Button {
                print("add")
            } label: {
                VStack {
                    Spacer()
                    Image(systemName: "plus")
                    Text("add")
                        .font(.system(size: 12))
                }
            }
        )
    }
}

struct Calendar_Year_Previews: PreviewProvider {
    static var previews: some View {
        Calendar_Year(isActive: .constant(true))
    }
}
