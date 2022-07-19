//
//  BookedView.swift
//  MikesApp
//
//  Created by Marquel Hendricks on 3/1/22.
//

import SwiftUI
import Firebase

struct Booked : View {
    
    @Binding var data : Data
    @Binding var doc : String
    @Binding var loading : Bool
    @Binding var book : Bool
    
    var body: some View{
                    
            VStack(spacing: 25) {
                    
                    /*let db = Firestore.firestore()
                    
                    db.collection("Booking").document(self.doc).delete { (err) in
                        
                        if err != nil{
                            
                            print((err?.localizedDescription)!)
                            return
                        }
                        
                        self.loading.toggle()
                    }*/
            }
            .background(Color.black.opacity(0.25).edgesIgnoringSafeArea(.all))
    }
}
