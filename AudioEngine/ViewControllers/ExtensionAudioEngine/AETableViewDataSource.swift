//
//  AETableViewDataSource.swift
//  AudioEngine
//
//  Created by Александр Панин on 22.02.2022.
//

import UIKit

extension AudioEngineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nodeCell", for: indexPath)  as! NodeTableViewCell
        let node = dataSongs[indexPath.row]
        let data = dataPlayingSong[indexPath.row]
        
        cell.configure( node: node, data: data, indexRow: indexPath )
        cell.delegate = self
        return cell
    }
}

