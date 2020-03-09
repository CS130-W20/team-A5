//
//  SignupView.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 2/6/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftyJSON

struct CaptureImageView {
  
  /// MARK: - Properties
  @Binding var isShown: Bool
  @Binding var image: Image?
@Binding var pic_url: String
  
  func makeCoordinator() -> CameraController {
    return CameraController(isShown: $isShown, image: $image, pic_url: $pic_url)
  }
}

extension CaptureImageView: UIViewControllerRepresentable {
  func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    /// Default is images gallery. Un-comment the next line of code if you would like to test camera
//    picker.sourceType = .camera
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIImagePickerController,
                              context: UIViewControllerRepresentableContext<CaptureImageView>) {
    
  }
}

struct CameraView: View {
  
    
  @State var image: Image? = nil
  @State var showCaptureImageView: Bool = false
  @Binding var pic_url: String
    
  var body: some View {
    ZStack {
      VStack {
        Button(action: {
          self.showCaptureImageView.toggle()
        }) {
          Text("Choose photo")
        }
        image?.resizable()
          .frame(width: 250, height: 200)
          .clipShape(Rectangle())
          .overlay(Rectangle().stroke(Color.white, lineWidth: 4))
          .shadow(radius: 10)
        
        
      }
      if (showCaptureImageView) {
        CaptureImageView(isShown: $showCaptureImageView, image: $image, pic_url: $pic_url)
      }
    }

  }
}

struct UploadSaleItemView : View {
    @EnvironmentObject var navigation: NavigationStack
    
    //Create some user and use a password confirmation var to confirm
    @ObservedObject var newSaleItem = SaleItem(item_name: "", item_id: 0, seller_id: 0, pic_url: "", item_description: "", sale_price: "", ticket_price: "", total_tickets: "", created_at: "" )
    @ObservedObject var oldSaleItem = User()
    @State var temp_total_ticket: String = ""
    @State var value: CGFloat = 0
    @State var noEmpty: Bool = true
    @State var image: Image? = nil
    
    var body: some View {
        HStack(){
            
            //Left Side Spacer
            Spacer()
            
            //Center Column
            VStack(){
                HStack(){
                    Button(action: {
                        self.navigation.unwind()
                    }){
                       Text("Back")
                            .foregroundColor(Color.gray)
                            .fontWeight(.semibold)
                            .font(.custom("Poppins", size: 24))
                    }
                    Spacer()
                }.padding()
                Spacer().frame(height: 80)
                
                CameraView(pic_url: $newSaleItem.pic_url)
                VStack(){
                    TextField("Item Name", text: $newSaleItem.item_name)
                        .textFieldStyle(SignUpTextFieldStyle())

                    TextField("Item Description", text: $newSaleItem.item_description)
                        .textFieldStyle(SignUpTextFieldStyle())

                    TextField("Total Item Price", text: $newSaleItem.sale_price)
                        .textFieldStyle(SignUpTextFieldStyle())

                    TextField("Number of Tickets", text: $newSaleItem.total_tickets)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(SignUpTextFieldStyle())
                

                    if (newSaleItem.total_tickets != "") {                        
//                        newSaleItem.ticket_price = String(Int(newSaleItem.sale_price) / Int(newSaleItem.total_tickets))
                        Text("Ticket Price: " + String(newSaleItem.sale_price))
                    }
                    

                    
                
                Spacer()
                //ZStack here to allow for custom shadow manipulation.
                if(!noEmpty) {
                    Text("Please enter a username/password.")
                        .foregroundColor(.red)
                }
                ZStack(){
                    ShadowBoxView()
                    
                    //Signup Button
                    Button(action:{
                        if((self.newSaleItem.item_name.count != 0) && (self.newSaleItem.item_description.count != 0) && (self.newSaleItem.sale_price.count != 0) && (self.newSaleItem.total_tickets.count != 0)){
                                self.navigation.advance(
                                NavigationItem( view: AnyView(CreateSaleItem(newSaleItem: self.newSaleItem))))
                            }else{
                                self.noEmpty = false
                            }
                    }){
                        Text("Submit")
                        .blueButtonText()
                        .frame(minWidth:0, maxWidth: frameMaxWidth)
                    }.buttonStyle(BigBlueButtonStyle())
                    
                }
             
                }
            
            //Right Side Spacer
            Spacer()
        }
        
    }
}
}

struct UploadSaleItemView_Previews: PreviewProvider {
    static var previews: some View {
        UploadSaleItemView()
    }
}

