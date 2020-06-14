//
//  ContentView.swift
//  SwiftUI_login
//
//  Created by Jimmy Leu on 2020/5/27.
//  Copyright © 2020 Jimmy Leu. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View{
    
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View{
        
        NavigationView{
            VStack{
                if self.status{
                    Homescreen()
                }else{
                    ZStack{
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                            
                            Text("")
                        }
                        .hidden()
                        
                        Login(show: self.$show)
                    }
                }
                
                
            }
            
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear{
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                        self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    }
            }
        }
        
    }
    
}

struct Homescreen: View {
    var body: some View{
        VStack{
            Text(" Logged in successfully")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black.opacity(0.7))
            Button(action: {
                
                try! Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
            }){
                Text("Log out")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color("Color"))
            .cornerRadius(10)
            .padding(.top, 25)
        }
    }
}



struct Login: View{
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show: Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View{
        
        
        ZStack{
            ZStack(alignment: .topTrailing){
                       
                       GeometryReader{ _ in
                           
                           VStack{
                                   Image("logo")
                                   Text("log in to your account")
                                       .font(.title).fontWeight(.bold).foregroundColor(self.color).padding(.top, 35)
                                   
                                   TextField("Email", text:self.$email)
                                    .autocapitalization(.none)
                                   .padding()
                                       .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") :  self.color, lineWidth: 2))
                                       .padding(.top, 25)
                                   HStack(spacing: 15){
                                       
                                       VStack{
                                           if self.visible{
                                               TextField("Password",text: self.$pass)
                                           }else{
                                               SecureField("Password",text:self.$pass)
                                           }
                                       }
                                       
                                       Button(action: {
                                           self.visible.toggle()
                                       }){
                                           Image(systemName: self.visible ? "eye.slash.fill": "eye.fill").foregroundColor(self.color)
                                       }
                                       
                                   }.padding()
                                   .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") :  self.color, lineWidth: 2))
                                   .padding(.top, 25)
                                   
                                   HStack{
                                       Spacer()
                                       
                                       Button(action: {
                                        self.reset()
                                       }){
                                           Text("Forget password")
                                               .fontWeight(.bold)
                                               .foregroundColor(Color("Color"))
                                       }
                                       
                                       
                                   }.padding(.top, 25)
                                   
                                   Button(action: {
                                        
                                    self.verify()
                                    
                                       }){Text("Log In")}
                                       .foregroundColor(.white)
                                       .padding(.vertical)
                                       .frame(width:UIScreen.main.bounds.width-50 )
                                   .background(Color("Color"))
                                   .cornerRadius(10)
                                       .padding(.top, 25)
                                   
                                   
                               }
                           .padding(.horizontal,25)
                           
                       }
                       
                       Button(action: {
                            self.show.toggle()
                       }){
                       Text("Register").fontWeight(.bold).foregroundColor(Color("Color"))
                       }.padding()

                       
                   }
            
            if self.alert{
                 ErrorView(alert: self.$alert, error: self.$error)
            }
        }
        
        

    }
    
    
    func reset(){
        if self.email != "" {
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err ) in
                if err != nil {
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                print("success")
                self.error = "RESET"
                self.alert.toggle()
            }
        }
    }
    
    func verify(){
        
        if self.email  != "" && self.pass != "" {
            
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
                
                if err != nil{
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                print("success")
                
                UserDefaults.standard.set(true,forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"),object: nil)
            }
        }else{
            
            self.error = "Please fill all the content properly"
            self.alert.toggle()
        }
    }
}


struct SignUp   : View{
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var repass = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View{
        
        ZStack{
            ZStack(alignment: .topLeading){
                    
                    GeometryReader{ _ in
                        
                        VStack{
                                Image("logo")
                                Text("log in to your account")
                                    .font(.title).fontWeight(.bold).foregroundColor(self.color).padding(.top, 35)
                                
                                TextField("Email", text:self.$email)
                                .padding()
                                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") :  self.color, lineWidth: 2))
                                    .padding(.top, 25)
                                HStack(spacing: 15){
                                    
                                    VStack{
                                        if self.visible{
                                            TextField("Password",text: self.$pass)
                                        }else{
                                            SecureField("Password",text:self.$pass)
                                        }
                                    }
                                    
                                    Button(action: {
                                        self.visible.toggle()
                                    }){
                                        Image(systemName: self.visible ? "eye.slash.fill": "eye.fill").foregroundColor(self.color)
                                    }
                                    
                                }.padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") :  self.color, lineWidth: 2))
                                .padding(.top, 25)
                                
                                HStack(spacing: 15){
                                    
                                    VStack{
                                        if self.visible{
                                            TextField("Re-eneter Password",text: self.$repass)
                                        }else{
                                            SecureField("Re-enter Password",text:self.$repass)
                                        }
                                    }
                                    
                                    Button(action: {
                                        self.visible.toggle()
                                    }){
                                        Image(systemName: self.visible ? "eye.slash.fill": "eye.fill").foregroundColor(self.color)
                                    }
                                    
                                }.padding()
                                .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") :  self.color, lineWidth: 2))
                                .padding(.top, 25)
                                
                                Button(action: {
                                    
                                    self.register()
                                    
                                    }){Text("Register")}
                                    .foregroundColor(.white)
                                    .padding(.vertical)
                                    .frame(width:UIScreen.main.bounds.width-50 )
                                .background(Color("Color"))
                                .cornerRadius(10)
                                    .padding(.top, 25)
                                
                                
                            }
                        .padding(.horizontal,25)
                        
                    }
                    
                    Button(action: {
                        self.show.toggle()
                    }){
                        Image(systemName: "chevron.left").foregroundColor(Color("Color"))
                            .font(.title)
                    }.padding()

                    
                }
            
            if self.alert{
                ErrorView (alert: self.$alert, error: self.$error)
            }
            
        }.navigationBarBackButtonHidden(true)
        
        
        
        
    }
    
    func register(){
        if self.email != "" {
            if self.pass == self.repass{
                
                Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
                    if err != nil{
                        
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    print("success")
                    
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name:NSNotification.Name("status"), object: nil)
                }
                
            }else{
                self.error = "Password missmatch"
                self.alert.toggle()
            }
            
        }else{
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }
}

struct ErrorView: View{
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    
    var body: some View{
        GeometryReader { _ in
            
            VStack{
                
                HStack{
                    Text(self.error == "RESET" ? "Message" :"Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                    
                Text(self.error == "RESET" ? "Password reset link has been sent successfully " :self.error)
                        .foregroundColor(self.color)
                        .padding(.top)
                        .padding(.horizontal, 25)
                    
                    Button(action: {
                        self.alert.toggle()
                    }){
                        Text(self.error == "RESET" ? "Confirm" :"Cancel")
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width-120)
                    }
                .background(Color("Color"))
                .cornerRadius(10)
                    .padding(.top, 25)
            }
                .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width-70)
                   .background(Color.white)
                   .cornerRadius(15)
            
            
        }.background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
       
    }

}
