//
//  ViewController.swift
//  Storage
//
//  Created by rizwankce on 12/19/2017.
//  Copyright (c) 2017 rizwankce. All rights reserved.
//

import UIKit
import SwiftStorage

enum Result<T> {
    case success(T)
    case failure(Error)
}

class ViewController: UIViewController {

    private let storage: Storage<[Job]> = Storage(storageType: .document, filename: "remote-jobs.json")
    private var jobs = [Job]()

    private let tableView = UITableView()
    private let refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "JobCell")
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refresh
        view.addSubview(tableView)
    }

    @objc private func refreshData() {
        loadData(useCache: true)
    }

    private func loadData(useCache: Bool = false) {
        if useCache, let jobs = storage.storedValue {
            self.jobs = jobs
            DispatchQueue.main.async {
                self.refresh.endRefreshing()
                self.tableView.reloadData()
            }
        } else if let jobs = storage.storedValue {
            self.jobs = jobs
            DispatchQueue.main.async { self.tableView.reloadData() }
        } else {
            fetch { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async { self.refresh.endRefreshing() }
                switch result {
                case .success(let jobs):
                    self.storage.save(jobs)
                    self.jobs = jobs
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                }
            }
        }
    }

    func fetch(_ completion: ((Result<[Job]>) -> Void)?) {
        guard let url = URL(string: "https://remoteok.io/remote-jobs.json") else { return }
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            do {
                let jobs = try decoder.decode([Job].self, from: data)
                completion?(.success(jobs))
            } catch {
                completion?(.failure(error))
            }
        }).resume()
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath)
        let job = jobs[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(job.position) at \(job.company)\n\(job.url)"
        return cell
    }
}
