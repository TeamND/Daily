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
        VStack {
            Image(systemName: "d.circle.fill")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(40)
                .foregroundColor(.mint)
            TextField("ID", text: $id)
                .font(.system(size: 20, weight: .bold))
                .padding(5)
                .background(.teal)
            TextField("PW", text: $pw)
                .font(.system(size: 20, weight: .bold))
                .padding(5)
                .background(.teal)
            HStack {
                Button {
                    print("test")
                } label: {
                    Image(systemName: "square")
                    Text("자동 로그인")
                        .foregroundColor(.black)
                }
                Spacer()
                Text("비밀번호 찾기")
                    .foregroundColor(.gray)
                    .underline()
                Text("회원가입")
                    .foregroundColor(.gray)
                    .underline()
            }
        }
        .padding(5)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


