//
//  ContentView.swift
//  Daily
//
//  Created by 최승용 on 2022/10/31.
//

import SwiftUI

struct LoginView: View {
    @State var id: String = ""
    @State var pw: String = ""
    var body: some View {
        VStack(alignment: .leading) {
            TextField("ID", text: $id)
                .font(.system(size: 20, weight: .bold))
                .padding(4)
                .background(.teal)
            TextField("PW", text: $pw)
                .font(.system(size: 20, weight: .bold))
                .padding(4)
                .background(.teal)
            Button {
                print("toggle auto login")
            } label: {
                Image(systemName: "square")
                Text("자동 로그인")
                    .foregroundColor(.black)
            }
            Button {
                print("do login")
            } label: {
                Text("로그인")
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(4)
            .background(.mint)
            HStack {
                Spacer()
                Text("비밀번호 찾기")
                    .foregroundColor(.gray)
                    .underline()
                Text("회원가입")
                    .foregroundColor(.gray)
                    .underline()
            }
        }
        .padding(8)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
