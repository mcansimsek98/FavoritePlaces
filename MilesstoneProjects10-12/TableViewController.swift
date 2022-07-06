//
//  ViewController.swift
//  MilesstoneProjects10-12
//
//  Created by Mehmet Can Şimşek on 5.07.2022.
//

import UIKit

class TableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var favImageArray = [Image]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite Places"
        
        navigationController?.navigationBar.tintColor = .cyan
        view.backgroundColor = .cyan
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(selectImage))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        let defaults = UserDefaults.standard
        
        if let savedImages = defaults.object(forKey: "imageFav") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                favImageArray = try jsonDecoder.decode([Image].self, from: savedImages)
            }catch {
                print("başarısız")
            }
        }
        
    }
    
    @objc func selectImage() {
        let picer = UIImagePickerController()
        let camera = UIImagePickerController.isSourceTypeAvailable(.camera)
        if camera {
            picer.sourceType = .camera
        }else {
            let alert = UIAlertController(title: "Camera is not working", message: "Choose from Photo Library", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { _ in
                picer.sourceType = .photoLibrary
                picer.allowsEditing = true
                picer.delegate = self
                self.present(picer, animated: true)
            }))
            present(alert, animated: true)
            
        }
        picer.allowsEditing = true
        picer.delegate = self
        present(picer, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.5) {
            try? jpegData.write(to: imagePath)
        }
        
        let favImage = Image(name: "Unknown", image: imageName)
        favImageArray.append(favImage)
        saved()
        tableView.reloadData()
        
        dismiss(animated: true)
        
    }
    
    func getImageURL(for imageName: String) -> URL {
            return getDocumentsDirectory().appendingPathComponent(imageName)
        }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favImageArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let image = favImageArray[indexPath.row]
        if let cell = cell as? Cell {
            cell.nameLbl.text = image.name
            let path = getImageURL(for: image.image)
            cell.photoView.image = UIImage(contentsOfFile: path.path)
            cell.photoView.layer.borderWidth = 1
            cell.photoView.layer.cornerRadius = cell.photoView.frame.height / 2
        }
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let image = favImageArray[indexPath.row]
        
        let alert = UIAlertController(title: "What do you want to do?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { [weak self] _ in
            self?.renameText(image: image)
        }))
        alert.addAction(UIAlertAction(title: "Details", style: .default, handler: { _ in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailsViewController {
                vc.currentImage = indexPath.row
                vc.selectedImageName = image.name
                vc.pictures = self.favImageArray
                print(image.image)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(alert, animated: true)
    }
    
    @objc func renameText(image: Image) {
        let ac = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Sumbit", style: .default, handler: { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            image.name = newName
            self?.saved()
            self?.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        present(ac, animated: true)
    }

    
    func saved() {
        let jsonEncoder = JSONEncoder()
        if let saveData = try? jsonEncoder.encode(favImageArray) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "imageFav")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favImageArray.remove(at: indexPath.row)
            saved()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
}

