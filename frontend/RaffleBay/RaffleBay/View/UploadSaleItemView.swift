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
    @ObservedObject var newSaleItem = User()
    @State private var pwdConfirm = String()
    @State var value: CGFloat = 0
    
    var body: some View {
        NavigationView {
        HStack(){
            
            //Left Side Spacer
            Spacer()
            
            //Center Column
            VStack(){
                Spacer().frame(height: 80)
                Text(newSaleItem.firstName)
                
                CameraView()
                VStack(){
                    TextField("Item Name", text: $newSaleItem.firstName)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 0
                        }
                  
                  
                    
                    TextField("Item Description", text: $newSaleItem.lastName)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 1
                        }

                    TextField("Item Price", text: $newSaleItem.email)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 2
                        }

                    TextField("Number of Tickets", text: $newSaleItem.streetAddress)
                        .textFieldStyle(SignUpTextFieldStyle())
                        .onTapGesture {
                            self.value = signupFrameHeight * 5
                        }
                    if (false) {
                        Text("Ticket Price: $5")
                    }
                    
                }
                
                Spacer()

                if(newSaleItem.password != pwdConfirm) {
                    Text("Your passwords do not match.")
                        .foregroundColor(.red)
                    
                }
                //ZStack here to allow for custom shadow manipulation.
                ZStack(){
                    ShadowBoxView()
                    
                    //Signup Button
                    NavigationLink(destination: CreateSaleItem()){
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
}

struct UploadSaleItemView_Previews: PreviewProvider {
    static var previews: some View {
        UploadSaleItemView()
    }
}
