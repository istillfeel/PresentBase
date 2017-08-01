//
//  PresentTableViewController.swift
//  PresentBase
//
//  Created by Daria on 30.07.17.
//  Copyright © 2017 Daria. All rights reserved.
//

import UIKit
import CoreData

class PresentTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var myGifts = [["name":"Best Friend","image":"1","item":"Camera"],["name":"Mom","image":"2","item":"Flowers"],["name":"Dad","image":"3","item":"Some kind of tech"],["name":"Sister","image":"4","item":"Sweets"]]
    
    var presents = [Present]()
    
    var managedObjectContext : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let iconImageView = UIImageView(image: UIImage(named: "Shape"))
        self.navigationItem.titleView = iconImageView

        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        loadData()
    }
    
    func loadData() {
        let presentRequest: NSFetchRequest<Present> = Present.fetchRequest()
            
        do{
            presents = try managedObjectContext.fetch(presentRequest)
            self.tableView.reloadData()
        } catch {
            print(" not working")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return presents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CellTableViewCell

        let  presentItem = presents[indexPath.row]
        
        if let presentImage = UIImage(data: presentItem.image as! Data){
            cell.backgroundImageView.image = presentImage
        }
        
        cell.nameLabel.text = presentItem.name
        cell.itemLabel.text = presentItem.presentName

        return cell
    }
 

    @IBAction func addPresent(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            picker.dismiss(animated: true, completion: {
                self.createPresentItem(with: image)
            })
        }
        
    }
    
    func createPresentItem (with image: UIImage) {
        let presentItem = Present(context: managedObjectContext)
        presentItem.image = NSData(data: UIImageJPEGRepresentation(image, 0.3)!)
        
        let imputAlert = UIAlertController(title: "New present", message: "Enter a person and a present", preferredStyle: .alert)
        imputAlert.addTextField { (textfield : UITextField) in
            textfield.placeholder = "Person"
        }
        imputAlert.addTextField { (textfield : UITextField) in
            textfield.placeholder = "Present"
        }
        imputAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction) in
            
            let personTextField = imputAlert.textFields?.first
            let presentTextField = imputAlert.textFields?.last
            
            if personTextField?.text != "" && presentTextField?.text != ""{
                presentItem.name = personTextField?.text
                presentItem.presentName = personTextField?.text
                
                do {
                    try self.managedObjectContext.save()
                   self.loadData()
                } catch {
                    print("Dont save Data\(error.localizedDescription)")
                }
            }
        }))
        imputAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(imputAlert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
}
