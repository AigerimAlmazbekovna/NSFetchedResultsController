//
//  JokesTableViewController.swift
//  NSFetchedResultConAigerim
//
//  Created by Айгерим on 20.10.2024.
//

import UIKit
import CoreData

class JokesTableViewController: UITableViewController {
   
    private var fetchResultContoller: NSFetchedResultsController = {
        let request = Joke.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "downloadDate", ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gobackward"),
            style: .plain,
            target: self,
            action: #selector(didTapRefresh)

         )
        fetchResultContoller.delegate = self
        try? fetchResultContoller.performFetch()
    }

    
    @objc private func didTapRefresh() {
        DownloadManager.shared.downloadJoke { result in
            switch result {
                
            case .success(let jokeCodable):
                CoreDataManager.shared.saveJoke(jokeCodable: jokeCodable)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchResultContoller.sections?[section].numberOfObjects ?? .zero
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let joke = fetchResultContoller.object(at: indexPath)
        let cell = UITableViewCell()
        var config = UIListContentConfiguration.cell()
        config.text = joke.value
        config.secondaryText = joke.downloadDate?.formatted()
        cell.contentConfiguration = config

      

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension JokesTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}
