//
//  PayeesViewController.swift
//  IOS-FinalProject-LSBank
//
//  Created by Daniel Carvalho on 14/11/21.
//

import UIKit



class PayeesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PayeesTableRefresh, UISearchBarDelegate {
            
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var refreshControl = UIRefreshControl()
    
    var payeeList : [Payee] = []

    @IBOutlet weak var actLoading: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!


    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    private func initialize(){
        customizeView()
                       
        refreshTable()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.enableTapGestureRecognizer(target: self, action: #selector(tableViewTapped(tapGestureRecognizer:)))

        refreshControl.addTarget(self, action: #selector(tableRefreshControl), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        searchBar.delegate = self
        
    }


    
    
    private func customizeView() {
        
    }

    @objc func tableRefreshControl(send : UIRefreshControl) {
        
        DispatchQueue.main.async {
            print("Refreshing table")
            self.searchBar.text = ""
            
            self.refreshTable()
            self.refreshControl.endRefreshing()
        }
        
    }
    
    
    private func refreshTable() {

        self.payeeList = Payee.allByFirstName(context: self.context)
        
        tableView.reloadData()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func tableViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.view.endEditing(true)
    }


        
    
    @IBAction func btnClose(_ sender : Any?) {
        
        navigationController?.popViewController(animated: true)
        
    }

    
    @IBAction func btnAddTouchUp(_ sender : Any?) {
        
        performSegue(withIdentifier: Segue.toNewPayeeView, sender: nil)
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.payeeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PayeeTableViewCell
        
        cell.lblFullName!.text = "\(self.payeeList[indexPath.row].firstName!) \(self.payeeList[indexPath.row].lastName!)"
        cell.lblEmail!.text = self.payeeList[indexPath.row].email!

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let payee = self.payeeList[indexPath.row]
            
            let _ = payee.delete(context: self.context)
            self.refreshTable()
            
        })
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }


    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let sendAction = UIContextualAction(style: .normal, title:  "Send money", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let payee = self.payeeList[indexPath.row]
                
            DispatchQueue.main.async {
                Toast.show(view: self, title: "Send money", message: "You have to implement the send money here!")
            }
            
        })
        sendAction.image = UIImage(systemName: "square.and.arrow.up")
        sendAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [sendAction])
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! NewPayeeViewController
        vc.delegate = self
    }
    
    func payeesTableRefresh() {
        // this is the protocol stub
        self.refreshTable()
    }

    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            self.payeeList = Payee.allByFirstName(context: self.context)
            tableView.reloadData()
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async {
            self.actLoading.startAnimating()
        }
        
        let stringToFind : String = searchBar.text!.uppercased()
        
        self.payeeList = Payee.allByFirstName(context: self.context)

        if searchBar.text!.count > 0 {
            var payeeList : [Payee] = []
            for payee in self.payeeList {
                if ((payee.firstName?.range(of: stringToFind, options: .caseInsensitive)) != nil) ||
                    ((payee.lastName?.range(of: stringToFind, options: .caseInsensitive)) != nil) ||
                    ((payee.email?.range(of: stringToFind, options: .caseInsensitive)) != nil) {
                    payeeList.append(payee)
                }
            }
            self.payeeList = payeeList
        }
        tableView.reloadData()

        DispatchQueue.main.async {
            self.actLoading.stopAnimating()
        }
        
    }
    
    
}
