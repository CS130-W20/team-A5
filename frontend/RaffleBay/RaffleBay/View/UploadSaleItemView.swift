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
  
  func makeCoordinator() -> CameraController {
    return CameraController(isShown: $isShown, image: $image)
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
        CaptureImageView(isShown: $showCaptureImageView, image: $image)
      }
    }
  }
}

struct UploadSaleItemView : View {
   
    //Create some user and use a password confirmation var to confirm
    @ObservedObject var newSaleItem = SaleItem(item_name: "", seller_id: 0, pic_url: "", item_description: "", sale_price: "", ticket_price: "", total_tickets: "" )
    @ObservedObject var oldSaleItem = User()
    @State var temp_total_ticket: String = ""
    @State var value: CGFloat = 0
    
    var body: some View {
        HStack(){
            
            //Left Side Spacer
            Spacer()
            
            //Center Column
            VStack(){
                Spacer().frame(height: 80)
                
                CameraView()
                VStack(){
                    TextField("Item Name", text: $newSaleItem.item_name)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 0
                        }
                  
                  
                    
                    TextField("Item Description", text: $newSaleItem.item_description)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 1
                        }

                    TextField("Item Price", text: $newSaleItem.sale_price)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 2
                        }

                    TextField("Number of Tickets", text: $newSaleItem.total_tickets)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 5
                        }
                    if (newSaleItem.total_tickets != "") {
//                        $newSaleItem.ticket_price = "1"
                        Text("Ticket Price: $5")
                    }
                    
                }
                
                Spacer()
                //ZStack here to allow for custom shadow manipulation.
                ZStack(){
                    ShadowBoxView()
                    
                    //Signup Button
                    NavigationLink(destination: CreateSaleItem(newSaleItem: newSaleItem)){
                        Text("Submit")
                          .blueButtonText()
                          .frame(minWidth:0, maxWidth: frameMaxWidth)
                    }
                    .buttonStyle(BigBlueButtonStyle())
                }
             
                }
                .offset(y: -self.value)
                .animation(.spring())
                .onAppear(){
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ (noti) in
                        self.value = 0
                    }
                }
            
            //Right Side Spacer
            Spacer()
        }
        
    }
}

struct UploadSaleItemView_Previews: PreviewProvider {
    static var previews: some View {
        UploadSaleItemView()
    }
}
