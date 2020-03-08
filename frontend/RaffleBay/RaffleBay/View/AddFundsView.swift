//
//  AddFundsView.swift
//  RaffleBay
//
//  Created by Meera Rachamallu on 3/7/20.
//  Copyright © 2020 Meera Rachamallu. All rights reserved.
//

import UIKit
import SwiftUI
import Stripe
class AddFundsView: UIViewController {
    var paymentIntentClientSecret: String?
    var amount = 0.0
    var auth_token = ""
    lazy var cardTextField: STPPaymentCardTextField = {
        let cardTextField = STPPaymentCardTextField()
        return cardTextField
    }()
    lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 5
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.setTitle("Pay", for: .normal)
        button.addTarget(self, action: #selector(pay), for: .touchUpInside)
        return button
    }()
    
    lazy var addFunds: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter the amount of funds you wish to add"
        textfield.textAlignment = .center
        textfield.borderStyle = .roundedRect
        textfield.addTarget(self, action: #selector(AddFundsView.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        return textfield
    }()
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        amount = Double(addFunds.text!) ?? 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [addFunds, cardTextField, payButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalToSystemSpacingAfter: view.leftAnchor, multiplier: 2),
            view.rightAnchor.constraint(equalToSystemSpacingAfter: stackView.rightAnchor, multiplier: 2),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
        ])
        startCheckout()
    }

    
    func displayAlert(title: String, message: String, restartDemo: Bool = false) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: "You are ready to make some purchases!", preferredStyle: .alert)
            if restartDemo {
                alert.addAction(UIAlertAction(title: "Done", style: .cancel) { _ in
                    self.cardTextField.clear()
                    self.startCheckout()
                })
            }
            else {
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func startCheckout() {

        post_add_funds(auth_token: auth_token, fund_amt: amount * 100) {
            response in
            let clientSecret = response["client_secret"]
            print("Created PaymentIntent")
            self.paymentIntentClientSecret = clientSecret.string
        }

    }
    
    @objc
    func pay() {
        guard let paymentIntentClientSecret = paymentIntentClientSecret else {
            return;
        }
        // Collect card details
        let cardParams = cardTextField.cardParams
        let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: nil, metadata: nil)
        let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
        paymentIntentParams.paymentMethodParams = paymentMethodParams

        // Submit the payment
        let paymentHandler = STPPaymentHandler.shared()
        paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
            switch (status) {
            case .failed:
                self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
                break
            case .canceled:
                self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
                break
            case .succeeded:
                self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "", restartDemo: true)
                break
            @unknown default:
                fatalError()
                break
            }
        }
    }
}
    
extension AddFundsView: STPAuthenticationContext {
    func authenticationPresentingViewController() -> UIViewController {
        return self
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



struct AddFundsWrapper: UIViewControllerRepresentable {
    @ObservedObject var authenticationVM = AuthenticationViewModel()
    
    func makeUIViewController(context: Context) -> UIViewController {
        let addFundsViewController = AddFundsView()
        addFundsViewController.auth_token = self.authenticationVM.auth_token
        return addFundsViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}
