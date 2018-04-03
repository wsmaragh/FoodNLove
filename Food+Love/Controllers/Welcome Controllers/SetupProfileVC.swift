
//  FillOutProfileVC.swift
//  Food+Love
//  Created by C4Q on 3/13/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.


import UIKit
import Firebase


class SetupProfileVC: UIViewController, UIScrollViewDelegate {

	// MARK: Outlets/Properties
	@IBOutlet weak var profileScrollView: UIScrollView!
	@IBOutlet weak var pageControl: UIPageControl!


	//Scenedock Views
	@IBOutlet var preferenceSlide: PreferenceProfile!
	@IBOutlet var aboutSlide: AboutProfile!
	@IBOutlet var signupSlide: UIView!
	@IBOutlet var videoSlide: UIView!
	@IBOutlet weak var actionButton: UIButton!

	//Properties Fields
	@IBOutlet weak var favoriteFoodCategory1TF: UITextField!
	@IBOutlet weak var favoriteFoodCategory2TF: UITextField!
	@IBOutlet weak var favoriteFoodCategory3TF: UITextField!
	@IBOutlet weak var favoriteRestaurant: UITextField!
	@IBOutlet weak var genderSC: UISegmentedControl!
	@IBOutlet weak var genderPreferenceSC: UISegmentedControl!
	@IBOutlet weak var dobPicker: UIDatePicker!
	@IBOutlet weak var zipcodeTF: UITextField!
	@IBOutlet weak var firstNameTF: UITextFieldX!
	@IBOutlet weak var emailTF: UITextFieldX!
	@IBOutlet weak var passwordTF: UITextFieldX!
	@IBOutlet weak var profileImageButton: UIButton!
	@IBOutlet weak var bioTV: UITextView!

	// MARK: Properties
	private var imagePicker = UIImagePickerController()
	var currentUser: User?
	private var profileSlides = [UIView]()
	private var slideIndex = 0


	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		imagePicker.delegate = self
		currentUser = Auth.auth().currentUser
		profileScrollView.delegate = self
		profileSlides = [preferenceSlide, aboutSlide, signupSlide, videoSlide]
		addSlidesToScrollView(slides: profileSlides)
		setupPageControl()
		navigationController?.title = "Setup Profile"
//		addShadeView()
	}


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
	}


	fileprivate func addShadeView(){
		let shade = UIView(frame: self.view.frame)
		shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
		view.addSubview(shade)
		view.sendSubview(toBack: shade)
	}
	
	// MARK: Helper Methods
	func addSlidesToScrollView(slides: [UIView]) {
		profileScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: profileScrollView.bounds.height)
		profileScrollView.isPagingEnabled = true
		profileScrollView.isDirectionalLockEnabled = true
		for i in 0..<slides.count {
			slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: profileScrollView.frame.height)
			profileScrollView.addSubview(slides[i])
		}
	}

	func setupPageControl(){


	}

	// MARK: Helper Methods
	private func setupTextFields(){
		//Underline
		self.firstNameTF.underlined(color: .white)
		self.emailTF.underlined(color: .white)
		self.passwordTF.underlined(color: .white)
		//LeftViewMode
		self.firstNameTF.leftViewMode = .always
		self.emailTF.leftViewMode = .always
		self.passwordTF.leftViewMode = .always
		//Text Color
		firstNameTF.textColor = .white
		emailTF.textColor = .white
		passwordTF.textColor = .white
		//Placeholder Color
		if let firstNamePlaceholder = firstNameTF.placeholder {
			firstNameTF.attributedPlaceholder = NSAttributedString(string: firstNamePlaceholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightText])
		}
		if let emailPlaceholder = emailTF.placeholder {
			emailTF.attributedPlaceholder = NSAttributedString(string: emailPlaceholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightText])
		}
		if let passwordPlaceholder = passwordTF.placeholder {
			passwordTF.attributedPlaceholder = NSAttributedString(string: passwordPlaceholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightText])
		}
	}


	// MARK: Action
	@IBAction func addVideoButton(_ sender: UIButton) {


	}


//	@IBAction func signup(_ sender: UIButtonX) {
//		guard let name = self.firstNameTF.text, name != "" else {
//			showAlert(title: "Please enter a name", message: ""); return
//		}
//		guard let email = self.emailTF.text, email != "" else {
//			showAlert(title: "Please enter an email", message: ""); return
//		}
//		guard let password = self.passwordTF.text, password != "" else {
//			showAlert(title: "Please enter a valid password", message: ""); return
//		}
//		if profileImageButton.image(for: UIControlState.normal) == #imageLiteral(resourceName: "selfieCamera") {
//			showAlert(title: "Please add a profile image", message: ""); return
//		}
//		guard let image = self.profileImageButton.image(for: .normal) else {return}
//		if email.contains(" ") {
//			showAlert(title: "No spaces allowed in email!", message: nil); return
//		}
//		if password.contains(" ") {
//			showAlert(title: "No spaces allowed in password!", message: nil); return
//		}
//
//		AuthUserService.manager.createUser(name: name, email: email, password: password, profileImage: image)
//	}

	@IBAction func nextPage(_ sender: UIButton) {
		let count = profileSlides.count
		if slideIndex < count - 1 {
			let currentPage = profileScrollView.contentOffset.x / profileScrollView.frame.size.width
			let point = CGPoint(x: view.bounds.width * (currentPage + 1), y: 0)
			profileScrollView.setContentOffset(point, animated: true)
			pageControl.currentPage = Int(currentPage)
			slideIndex = pageControl.currentPage + 1
			print("Slide index:", slideIndex)
			print("pageControl.currentPage:", pageControl.currentPage)
		}

		if slideIndex == count - 1 {
			actionButton.setTitle("Complete", for: .normal)
			print(slideIndex)
			print("complete profile now")
		}

		if actionButton.title(for: .normal) == "Complete" && pageControl.currentPage == 3{
			print("create account")
			//create auth account
			//add lover details to database
			//transition to main
		}

	}

	@IBAction func addProfileImage(_ sender: UIButton) {
		let alertController = UIAlertController(title: "Add profile image", message: "", preferredStyle: UIAlertControllerStyle.alert)
		let existingPhotoAction = UIAlertAction(title: "Choose Existing Photo", style: .default) { (alertAction) in
			self.launchCamera(type: UIImagePickerControllerSourceType.photoLibrary)
		}
		let newPhotoAction = UIAlertAction(title: "Take New Photo", style: .default) { (alertAction) in
			self.launchCamera(type: UIImagePickerControllerSourceType.camera)
		}
		alertController.addAction(existingPhotoAction)
		alertController.addAction(newPhotoAction)
		present(alertController, animated: true, completion: nil)
	}

	
	@objc private func createNewAccount() {
		guard let name = self.firstNameTF.text, name != "" else {
			showAlert(title: "Please enter a name", message: ""); return
		}
		guard let email = self.firstNameTF.text, email != "" else {
			showAlert(title: "Please enter an email", message: ""); return
		}
		guard let password = self.passwordTF.text, password != "" else {
			showAlert(title: "Please enter a valid password", message: ""); return
		}
		if profileImageButton.image(for: UIControlState.normal) == #imageLiteral(resourceName: "selfieCamera") {
			showAlert(title: "Please add a profile image", message: ""); return
		}
		guard let image = self.profileImageButton.image(for: .normal) else {
			showAlert(title: "Please add a profile image", message: ""); return
		}
		if email.contains(" ") {
			showAlert(title: "No spaces allowed in email!", message: nil); return
		}
		if password.contains(" ") {
			showAlert(title: "No spaces allowed in password!", message: nil); return
		}
		AuthUserService.manager.createUser(name: name, email: email, password: password, profileImage: image)
	}

	func completeProfile(){
		//add user details to database
		guard let favCat1 = favoriteFoodCategory1TF.text else {return}
		guard let favCat2 = favoriteFoodCategory2TF.text else {return}
		guard let favCat3 = favoriteFoodCategory3TF.text else {return}
		guard let favRest = favoriteRestaurant.text else {return}
		guard let zipcode = 	zipcodeTF.text else {return}
		guard let bio = bioTV.text else {return}

		let gender = genderSC.selectedSegmentIndex == 0 ? "Male" : "Female"
		let genderPreference =  genderPreferenceSC.selectedSegmentIndex == 0 ? "Male" : "Female"
		let dobDate = dobPicker.date
		let dob = DBService.manager.formatDateforDOB(with: dobDate)
		DBService.manager.addLoverDetails(favCat1: favCat1, favCat2: favCat2, favCat3: favCat3, favRestaurant: favRest, zipcode: zipcode, gender: gender, genderPreference: genderPreference, dateOfBirth: dob, bio: bio)


		print("user details added")
	}

	

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width
		pageControl.currentPage = Int(currentPage)
		slideIndex = pageControl.currentPage
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.emailTF.resignFirstResponder()
		self.passwordTF.resignFirstResponder()
		self.firstNameTF.resignFirstResponder()
	}

	private func showAlert(title: String, message: String?) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
		alertController.addAction(okAction)
		present(alertController, animated: true, completion: nil)
	}

	//Camera
	func launchCamera(type: UIImagePickerControllerSourceType){
		if UIImagePickerController.isSourceTypeAvailable(type){
			imagePicker.sourceType = type
			imagePicker.allowsEditing = true
			self.present(imagePicker, animated: true, completion: nil)
		}
	}
	

}


// MARK: TextField Delegate
extension SetupProfileVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}


// MARK: Image Picker
extension SetupProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		var selectedImageFromPicker: UIImage?
		print("in image picker")
		if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
			selectedImageFromPicker = editedImage
			print("Edited image selected from library/camera")
		}
		else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
			selectedImageFromPicker = originalImage
			print("original image selected from library/camera")
		}
		if let selectedImage = selectedImageFromPicker {
			profileImageButton.setImage(selectedImage, for: .normal)
		}
		imagePicker.dismiss(animated: true, completion: nil)
	}

	//Cancel camera
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		imagePicker.dismiss(animated: true, completion: nil)
	}

}


