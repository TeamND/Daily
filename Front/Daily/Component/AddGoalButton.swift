//
//  AddGoalButton.swift
//  Daily
//
//  Created by 최승용 on 2022/11/07.
//

import SwiftUI

struct AddGoalButton: View {
    var body: some View {
        Button {
            print("add")
        } label: {
            VStack {
                Spacer()
                Image(systemName: "plus")
                Text("add")
                    .font(.system(size: 12))
            }
        }
    }
}

struct AddGoalButton_Previews: PreviewProvider {
    static var previews: some View {
        AddGoalButton()
    }
}
