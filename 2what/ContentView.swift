//
//  ContentView.swift
//  2what
//
//  Created by 김유정 on 5/24/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("Image")
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 10.0)
                    .frame(height: 150)
                    .padding(.bottom, 50.0)
                    .padding(.top, 30.0)
                
                TextField("이메일", text: .constant(""))
                    .padding()
                    .border(Color.gray, width: 1)
                    .padding(.horizontal, 10.0)
                
                TextField("비밀번호", text: .constant(""))
                    .padding()
                    .border(Color.gray, width: 1)
                    .padding([.leading,.trailing], 10.0)
                    .padding(.bottom, 30.0)
                
                Button(action: {
                    // 로그인 액션 추가
                }) {
                    Text("로그인")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black) // 어두운 배경색 설정
                        .cornerRadius(5) // 모서리 둥글기 설정
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                NavigationLink(destination: SignUpView()) {
                    Text("회원가입")
                        .padding(0.5)
                }
                
                NavigationLink(destination: PasswordRecoveryView()) {
                    Text("비밀번호 찾기")
                        .foregroundColor(.red)
                        .padding(0.5)
                }
                
                .padding(0.5)
                
                Spacer()
            }
            .padding(.leading, 9.0)
            
           // .navigationTitle()
        
        }
    }
}

//비밀번호찾기
struct PasswordRecoveryView: View {
    var body: some View {
        Text("비밀번호 찾기")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.top, 20)
            .padding(.bottom, 250.0)
        
        TextField("이메일", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
            .padding()
            .border(Color.gray, width: 1)
            .padding(.horizontal, 10.0)
            .padding(.bottom, 100.0)
        Button(action: {
            // 비밀번호찾기 액션 추가
        }) {
            Text("비밀번호 찾기")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black) // 어두운 배경색 설정
                .cornerRadius(5) // 모서리 둥글기 설정
            }
            .padding(.horizontal, 20)
            .padding(.top, 150)
        
        
    }
    
}
//회원가입화면
struct SignUpView: View {
    var body: some View {
        Text("회원가입")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.top, 20)
            .padding(.bottom, 100)
        
        TextField("이메일", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
            .padding()
            .border(Color.gray, width: 1)
            .padding(.horizontal, 10.0)
        
        SecureField("비밀번호", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/ )
            .padding()
            .border(Color.gray, width: 1)
            .padding(.horizontal, 10.0)
            
        
        Text("-8글자 이상이어야 합니다.\n-이메일 주소가 포함되면 안됩니다.\n-문자 혹은 숫자가 최소 하나 이상 포함되어야 합니다.\n-공백이 포함되면 안됩니다.")
            .font(.body)
            .fontWeight(.thin)
            .multilineTextAlignment(.leading)
            .foregroundStyle(.gray)
            .padding(.top,5)
            .padding(.bottom, 200.0)
        
        Button(action: {
            // 회원가입 액션 추가
        }) {
            Text("회원가입")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black) // 어두운 배경색 설정
                .cornerRadius(5) // 모서리 둥글기 설정
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        
        
    }
    
        
}


#Preview {
    ContentView()
}

