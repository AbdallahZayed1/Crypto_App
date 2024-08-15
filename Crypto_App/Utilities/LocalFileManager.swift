//
//  LocalFileManager.swift
//  Crypto_App
//
//  Created by Abdallah Zayed on 05/08/2024.
//

import Foundation
import SwiftUI

class LocalFileManager {
    static let instance = LocalFileManager()
    
    func save_image (image : UIImage , imageName : String , folderName : String )  throws {
        createFolderIfNeeded(folderName: folderName)
        guard let data = image.pngData(),
        let url = getImagePath(Imagename: imageName, FolderName: folderName)
        else {throw URLError(.badURL)}
        do {
            try data.write(to: url)
        }catch {
            print("file araf")
            print(error)
        }
    }
    
    func get_image (imageName : String , folderName : String ) -> UIImage?{
        guard
            let url = getImagePath(Imagename: imageName, FolderName: folderName),
            FileManager.default.fileExists(atPath: url.path())
        else { return nil}
        return UIImage(contentsOfFile: url.path())
    }
    
    
    
    
    
    
    private func createFolderIfNeeded (folderName : String) {
        guard let FolderUrl = getFolderPath(name: folderName) else { return}
        
        if  !FileManager.default.fileExists(atPath: FolderUrl.path()) {
            do {
                try  FileManager.default.createDirectory(at: FolderUrl, withIntermediateDirectories: true)
            } catch let error {
                print("error creating folder", error)
            }
        }
    }
    
    
    private func getFolderPath (name : String)  -> URL?{
       guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else{ return nil }
        return url.appendingPathComponent(name, conformingTo: .folder)
    }
    
    
    private func getImagePath (Imagename : String , FolderName : String)  -> URL? {
        guard let Folderurl =  getFolderPath(name: FolderName)
        else{return nil }
        return Folderurl.appendingPathComponent(Imagename, conformingTo: .image)
    }
}
