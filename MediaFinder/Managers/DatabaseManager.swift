import Foundation
import SQLite

class DatabaseManager {
    static let sharedInstance = DatabaseManager()
    private var db: Connection? = nil
    let userData = Table("userData")
    private let id = Expression<Int>("id")
    private let email = Expression<String>("email")
    private let password = Expression<String>("password")
    private let contactNum = Expression<String>("contactNum")
    private let gender = Expression<String>("gender")
    private let address = Expression<String>("address")
    private let name = Expression<String>("name")
    private let photo = Expression<Data>("photo")
    let cachedData = Table("chachedData")
    private let text = Expression<String>("text")
    private let userid = Expression<Int>("userid")
    
    static func shared() -> DatabaseManager {
        return DatabaseManager.sharedInstance
    }
    
    
    func DbConnection() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("userData").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.db = database
        } catch {
            print(error)
        }
    }
    
    func createUsersTable() {
        if isTableExists(table: self.userData) == false {
        do {
            try db?.run(userData.create { t in
                t.column(self.id, primaryKey: .autoincrement)
                t.column(self.name)
                t.column(self.password)
                t.column(self.gender)
                t.column(self.address)
                t.column(self.contactNum)
                t.column(self.email, unique: true)
                t.column(self.photo)
                print("table created")
            })
            }
            catch   {
                print(error)
            }
        } else {
            print("Table Already Exists")
        }
    }
    
    func createCachDataTable() {
    if isTableExists(table: cachedData) == false {
    do {
        try db?.run(cachedData.create { t in
            t.column(self.userid, primaryKey: .autoincrement)
            t.column(text)
            t.foreignKey(self.userid, references: userData, self.id)
            print("table created")
        })
       print("data insterted")
        }   catch   {
            print(error)
            }
        }
    }
    
    func isTableExists(table: Table) -> Bool {
        if (try? db?.scalar(table.exists)) != nil {
            return true
        }
        return false
    }
    
    func updateCacheData(text: String) {
        let id = UserDefaults.standard.integer(forKey: "id")
        do {
            let user = cachedData.filter(self.userid == id)
            
            try self.db?.run(user.update(self.text <- text))
        } catch {
            print(error)
        }
    }
    
    func insertCacheData() {
            let cachedData = self.cachedData.insert(self.text <- "jack johnson")
            do {
                try self.db?.run(cachedData)
            } catch {
                print(error)
            }
    }
    
    func listUsersTable() {
        guard let dataB = self.db else {return}
        do {
            let userData = try dataB.prepare(self.userData)
            for data in userData {
                print(data[id], data[name], data[email], data[password])
            }
        } catch {
            print(error)
        }
    }
    
    func listCachDataTable() {
        guard let dataB = self.db else {return}
        do {
            let cachedData = try dataB.prepare(self.cachedData)
            for cachData in cachedData {
                print(cachData[self.userid], cachData[self.text])
            }
        } catch {
            print(error)
        }
    }
    
    func userExists(email: String, password: String) -> Bool {
        guard let dataB = self.db else {return false}
        do {
            let userData = try dataB.prepare(self.userData)
            for user in userData {
                if email == user[self.email] && password == user[self.password] {
                    UserDefaults.standard.set(user[self.id], forKey: UserDefaultsKeys.id)
                    return true
                }
            }
        } catch {
            print(error)
        }
        return false
    }
    
    func emailNotExists(email: String) -> Bool {
        guard let dataB = self.db else {return true}
        do {
            let userData = try dataB.prepare(self.userData)
            for user in userData {
                if email == user[self.email] {
                    return false
                }
            }
        } catch {
            print(error)
        }
        return true
    }
    
    func getUserData() -> Users? {
        guard let dataB = self.db else {return nil}
        do {
            let id = UserDefaults.standard.integer(forKey: UserDefaultsKeys.id)
            let userData = try dataB.prepare(self.userData)
            for user in userData {
                if id == user[self.id] {
                    
                   return Users(name: user[self.name], email: user[self.email], password: user[self.password], contactNum: user[self.contactNum], gender: user[self.gender], address: user[self.address], image: user[self.photo])
                }
                
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func insertUsers(user: Users) {
        guard let dataB = self.db else {return}
        do {
            let insert = userData.insert(self.name <- user.name, self.email <- user.email, self.password <- user.password, self.contactNum <- user.contactNum, self.gender <- user.gender, self.address <- user.address, self.photo <- user.image)
            try dataB.run(insert)

        } catch {
            print("Insert failed")
        }
        print(user.name ?? "",user.email ?? "",user.password ?? "")
    }
    
    func getCachedData() -> String {
        var cachedData = "Jack Johnson"
        guard let dataB = self.db else {return cachedData}
        let id = UserDefaults.standard.integer(forKey: UserDefaultsKeys.id)
        do {
            for cachData in try dataB.prepare(self.cachedData) {
                    if cachData[userid] == id {
                        cachedData = cachData[self.text]
                    }
            }
        } catch {
            print("Select failed")
        }
        return cachedData
    }
    
}
