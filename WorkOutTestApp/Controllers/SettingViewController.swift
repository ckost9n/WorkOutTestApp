//
//  SettingViewController.swift
//  WorkOutTestApp
//
//  Created by Konstantin on 10.02.2022.
//

import UIKit
import RealmSwift

class SettingViewController: UIViewController {
    
    private let editingProfileLabel: UILabel = {
       let label = UILabel()
        label.text = "EDITING PROFILE"
        label.font = .robotoMedium24()
        label.textColor = .specialGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "Close Button"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let addPhotoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .specialLightGray
        imageView.layer.borderWidth = 5
        imageView.image = UIImage(named: "addPhoto")
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let addPhotoView: UIView = {
       let view = UIView()
        view.backgroundColor = .specialGreen
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let firstNameLabel = UILabel(text: "    First name")
    
    private let firstNameTextField = UITextField(cornerRadius: 10, leftViewWidth: 15)
    
    private let secondNameLabel = UILabel(text: "    First name")
    
    private let secondNameTextField = UITextField(cornerRadius: 10, leftViewWidth: 15)

    private let heightLabel = UILabel(text: "   Height")
    
    private let heightTextField = UITextField(cornerRadius: 10, leftViewWidth: 15)
    
    private let weightLabel = UILabel(text: "   Weight")
    
    private let weightTextField = UITextField(cornerRadius: 10, leftViewWidth: 15)
    
    private let targetLabel = UILabel(text: "   Target")
    
    private let targetTextField = UITextField(cornerRadius: 10, leftViewWidth: 15)
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .specialGreen
        button.setTitle("SAVE", for: .normal)
        button.titleLabel?.font = .robotoBold16()
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var firstNameStackView = UIStackView()
    private var secondNameStackView = UIStackView()
    private var heightStackView = UIStackView()
    private var weightStackView = UIStackView()
    private var targetStackView = UIStackView()
    private var generalStackView = UIStackView()
    
    private let localRealm = try! Realm()
    private var userArray: Results<UserModel>!
    
    private var userModel = UserModel()
    
    override func viewDidLayoutSubviews() {
        addPhotoImageView.layer.cornerRadius = addPhotoImageView.frame.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setConstraints()
        addTaps()
        
        userArray = localRealm.objects(UserModel.self)
        
        loadUserInfo()
    }
    
    private func setupViews() {
        view.backgroundColor = .specialBackground
        
        view.addSubview(editingProfileLabel)
        view.addSubview(closeButton)
        view.addSubview(addPhotoView)
        view.addSubview(addPhotoImageView)
        
        firstNameStackView = UIStackView(
            arrangedSubviews: [firstNameLabel, firstNameTextField],
            axis: .vertical,
            spacing: 3)
        
        secondNameStackView = UIStackView(
            arrangedSubviews: [secondNameLabel, secondNameTextField],
            axis: .vertical,
            spacing: 3)
        
        heightStackView = UIStackView(
            arrangedSubviews: [heightLabel, heightTextField],
            axis: .vertical,
            spacing: 3)
        
        weightStackView = UIStackView(
            arrangedSubviews: [weightLabel, weightTextField],
            axis: .vertical,
            spacing: 3)
        
        targetStackView = UIStackView(
            arrangedSubviews: [targetLabel, targetTextField],
            axis: .vertical,
            spacing: 3)
        
        generalStackView = UIStackView(
            arrangedSubviews: [
                firstNameStackView,
                secondNameStackView,
                heightStackView,
                weightStackView,
                targetStackView
            ],
            axis: .vertical,
            spacing: 20)
        
        view.addSubview(generalStackView)
        view.addSubview(saveButton)
        
    }
    
    private func loadUserInfo() {
        if userArray.count != 0 {
            firstNameTextField.text = userArray[0].userFirstName
            secondNameTextField.text = userArray[0].userSecondName
            heightTextField.text = "\(userArray[0].userHeight)"
            weightTextField.text = "\(userArray[0].userWeight)"
            targetTextField.text = "\(userArray[0].userTarget)"
            
            guard let data = userArray[0].userImage else { return }
            guard let image = UIImage(data: data) else { return }
            addPhotoImageView.image = image
            addPhotoImageView.contentMode = .scaleAspectFit
        }
    }
    
    private func setUserModel() {
        
        guard let firstName = firstNameTextField.text,
              let secondName = secondNameTextField.text,
              let height = heightTextField.text,
              let weight = weightTextField.text,
              let target = targetTextField.text else { return }
        
        guard let intHeight = Int(height),
              let intWeight = Int(weight),
              let intTarget = Int(target) else { return }
        
        userModel.userFirstName = firstName
        userModel.userSecondName = secondName
        userModel.userWeight = intWeight
        userModel.userHeight = intHeight
        userModel.userTarget = intTarget
        
        if addPhotoImageView.image == UIImage(named: "addPhoto") {
            userModel.userImage = nil
        } else {
            guard let imageData = addPhotoImageView.image?.pngData() else { return }
            userModel.userImage = imageData
        }
        
    }
    
    private func addTaps() {
        let tapImageView = UITapGestureRecognizer(target: self, action: #selector(setUserPhoto))
        addPhotoView.isUserInteractionEnabled = true
        addPhotoView.addGestureRecognizer(tapImageView)
    }
    
    @objc func setUserPhoto() {
        alertPhotoOrCamera { [weak self] source in
            guard let self = self else { return }
            self.chooseImagePicker(source: source)
        }
    }

    @objc func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func saveButtonTapped() {
        setUserModel()
        
        if userArray.count == 0 {
            RealmManager.shared.saveUserModel(model: userModel)
            
        } else {
            RealmManager.shared.updateUserModel(model: userModel)
        }
        userModel = UserModel()
        alertOk(title: "Изменения сохранены!", message: nil)
    }

}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension SettingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        addPhotoImageView.image = image
        addPhotoImageView.contentMode = .scaleAspectFit
        dismiss(animated: true)
    }
    
}

// MARK: - Set Constraints

extension SettingViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            editingProfileLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            editingProfileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.centerYAnchor.constraint(equalTo: editingProfileLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            addPhotoImageView.topAnchor.constraint(equalTo: editingProfileLabel.bottomAnchor, constant: 20),
            addPhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addPhotoImageView.heightAnchor.constraint(equalToConstant: 100),
            addPhotoImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            addPhotoView.topAnchor.constraint(equalTo: addPhotoImageView.topAnchor, constant: 50),
            addPhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addPhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addPhotoView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            firstNameTextField.heightAnchor.constraint(equalToConstant: 40),
            secondNameTextField.heightAnchor.constraint(equalToConstant: 40),
            heightTextField.heightAnchor.constraint(equalToConstant: 40),
            weightTextField.heightAnchor.constraint(equalToConstant: 40),
            targetTextField.heightAnchor.constraint(equalToConstant: 40),
            
            generalStackView.topAnchor.constraint(equalTo: addPhotoView.bottomAnchor, constant: 20),
            generalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            generalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: generalStackView.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            saveButton.heightAnchor.constraint(equalToConstant: 55)
        ])
        
    }
    
}
