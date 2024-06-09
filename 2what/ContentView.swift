import SwiftUI
import SQLite3

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginStatus: String = ""
    @State private var users: [AppUser] = []

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

                TextField("이메일", text: $email)
                    .padding()
                    .border(Color.gray, width: 1)
                    .padding(.horizontal, 10.0)

                SecureField("비밀번호", text: $password)
                    .padding()
                    .border(Color.gray, width: 1)
                    .padding([.leading, .trailing], 10.0)
                    .padding(.bottom, 30.0)

                Button(action: {
                    login(email: email, password: password)
                }) {
                    Text("로그인")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(5)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Text(loginStatus)
                    .padding()

                NavigationLink(destination: SignUpView()) {
                    Text("회원가입")
                        .padding(0.5)
                }

                NavigationLink(destination: PasswordRecoveryView()) {
                    Text("비밀번호 찾기")
                        .foregroundColor(.red)
                        .padding(0.5)
                }
                Spacer()
            }
            .padding(.leading, 9.0)
            .onAppear(perform: loadUsersFromDB)
        }
    }

    func login(email: String, password: String) {
        var db: OpaquePointer?
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("test_db.sqlite")

        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            loginStatus = "DB 열기 실패"
            return
        }

        let query = "SELECT password FROM User WHERE email = ?;"
        var queryStatement: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (email as NSString).utf8String, -1, nil)

            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let dbPassword = String(cString: sqlite3_column_text(queryStatement, 0))

                if dbPassword == password {
                    loginStatus = "로그인 성공"
                } else {
                    loginStatus = "비밀번호가 일치하지 않습니다"
                }
            } else {
                loginStatus = "이메일을 찾을 수 없습니다"
            }
        } else {
            loginStatus = "SELECT 문 작성 실패"
        }

        sqlite3_finalize(queryStatement)
        sqlite3_close(db)
    }

    func loadUsersFromDB() {
        var db: OpaquePointer?
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("test_db.sqlite")

        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            debugPrint("Cannot open DB.")
            return
        }

        let query = "SELECT email, password FROM User;"
        var queryStatement: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            var loadedUsers: [AppUser] = []
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let email = String(cString: sqlite3_column_text(queryStatement, 0))
                let password = String(cString: sqlite3_column_text(queryStatement, 1))
                loadedUsers.append(AppUser(email: email, password: password))
            }
            users = loadedUsers
        } else {
            debugPrint("SELECT 문 작성 실패")
        }

        sqlite3_finalize(queryStatement)
        sqlite3_close(db)
    }
}

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var signUpStatus: String = ""
    @State private var users: [AppUser] = []

    var body: some View {
        VStack {
            Text("회원가입")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.bottom, 100)

            TextField("이메일", text: $email)
                .padding()
                .border(Color.gray, width: 1)
                .padding(.horizontal, 10.0)

            SecureField("비밀번호", text: $password)
                .padding()
                .border(Color.gray, width: 1)
                .padding(.horizontal, 10.0)

            Button(action: {
                saveUserToDB(email: email, password: password)
                loadUsersFromDB()
            }) {
                Text("회원가입")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(5)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            Text(signUpStatus)
                .padding()

            List(users) { user in
                VStack(alignment: .leading) {
                    Text("Email: \(user.email)")
                    Text("Password: \(user.password)")
                }
            }
            Spacer()
        }
        .padding(.leading, 9.0)
        .onAppear(perform: loadUsersFromDB)
    }

    func saveUserToDB(email: String, password: String) {
        var db: OpaquePointer?
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("test_db.sqlite")

        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            signUpStatus = "DB 열기 실패"
            return
        }

        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS User (
                email TEXT PRIMARY KEY,
                password TEXT
            );
        """
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            signUpStatus = "테이블 생성 실패"
            return
        }

        let insertQuery = "INSERT INTO User (email, password) VALUES (?, ?);"
        var insertStatement: OpaquePointer?

        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (email as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (password as NSString).utf8String, -1, nil)

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                signUpStatus = "회원가입이 완료되었습니다."
            } else {
                signUpStatus = "회원가입 실패"
            }
        } else {
            signUpStatus = "INSERT 문 작성 실패"
        }

        sqlite3_finalize(insertStatement)
        sqlite3_close(db)
    }

    func loadUsersFromDB() {
        var db: OpaquePointer?
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("test_db.sqlite")

        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            debugPrint("Cannot open DB.")
            return
        }

        let query = "SELECT email, password FROM User;"
        var queryStatement: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            var loadedUsers: [AppUser] = []
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let email = String(cString: sqlite3_column_text(queryStatement, 0))
                let password = String(cString: sqlite3_column_text(queryStatement, 1))
                loadedUsers.append(AppUser(email: email, password: password))
            }
            users = loadedUsers
        } else {
            debugPrint("SELECT 문 작성 실패")
        }

        sqlite3_finalize(queryStatement)
        sqlite3_close(db)
    }
}

struct PasswordRecoveryView: View {
    var body: some View {
        VStack {
            Text("비밀번호 찾기")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.bottom, 250.0)

            TextField("이메일", text: .constant(""))
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
                    .background(Color.black)
                    .cornerRadius(5)
            }
            .padding(.horizontal, 20)
            .padding(.top, 150)
        }
    }
}

struct AppUser: Identifiable {
    let id = UUID()
    let email: String
    let password: String
}

#Preview {
    ContentView()
}

