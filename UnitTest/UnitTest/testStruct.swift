//
//  testStruct.swift
//  UnitTest
//
//  Created by Mike Sedaghatnia on 2021-08-08.
//

import Foundation


struct ValidateUserNameAndPassword {
    
    
    
    func checkValidation(username: String?) throws -> String {
        guard let username = username else {throw checkValidate.invalidInput}
        guard username.count >= 5 else {throw checkValidate.tooShort}
        guard username.count <= 20 else {throw checkValidate.tooLong}
        guard username.rangeOfCharacter(from: .decimalDigits) != nil else {throw checkValidate.missNumbers}
        
        return username
    }

    func checkPassValidation(pass:String?) throws -> String {
        guard let pass = pass else {throw checkValidate.invalidInput}
        guard pass.rangeOfCharacter(from: .decimalDigits) != nil else {throw checkValidate.passHasNotNumber}
        for i in pass.indices {
            for t in pass.indices.suffix(from: pass.index(after: i)) {
                if pass[i] == pass[t] {
                    throw checkValidate.passRepeated
                }
            }
            
        }
        
        return pass
    }
    
    func getData(inputUrl:String, completion: @escaping(Swift.Result<Data, Error>) -> Void) {
        guard let url = URL(string: inputUrl) else {
            completion(.failure(NetworkResponseError.invalidURL))
            return}
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data , response , error in
            if error != nil  {
                completion(.failure(NetworkResponseError.failed))
                return
            }
            
            let response = response as? HTTPURLResponse
            
            let responseResult = handleNetworkResponse(response)
              print(responseResult)
            
            
            guard let data = data else {
                completion(.failure(NetworkResponseError.noData))
                return
            }
            
            print(data.count)
                completion(.success(data))
            
            
        }
        dataTask.resume()
    }
    
    func handleNetworkResponse(_ response: HTTPURLResponse?) -> Result<Error>{
        guard let _response = response else { return .failure(NetworkResponseError.failed) }
        switch _response.statusCode {
        case 200...299: return .success
        case 402, 404...500: return .failure(NetworkResponseError.clientError)
        case 400: return .failure(NetworkResponseError.badRequest)
        case 401: return .failure(NetworkResponseError.authenticationError)
        case 403: return .failure(NetworkResponseError.forbidden)
        case 501...599: return .failure(NetworkResponseError.badRequest)
        case 600: return .failure(NetworkResponseError.outdated)
        default:
            return .failure(NetworkResponseError.failed)
        }
    }
}

enum checkValidate: LocalizedError {
    case tooShort
    case tooLong
    case missNumbers
    case invalidInput
    case passRepeated
    case passHasNotNumber
    var errorDescription: String? {
        switch self {
        case .missNumbers:
            return "Please use numbers"
        case .tooLong:
            return "The password is too long"
        case .tooShort:
            return "the password is too short"
        case .invalidInput:
            return "invalid input!"
        case .passHasNotNumber:
            return "use number in password"
        case .passRepeated:
        return "it's common pass "
        }
    }
}


enum NetworkResponseError: String, Error {
    case success = "success"
    case authenticationError = "The request requires user authentication."
    case forbidden = "The user is not allowed to perform this operation."
    case clientError = "Client error."
    case invalidURL = "The URL is invalid."
    case downloadTaskFailedToSave = "Download task failed to save the file."
    case badRequest = "The request could not be understood by the server due to malformed syntax."
    case internalServerError = "Internal server error."
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
}


enum Result<String>{
    case success
    case failure(String)
}
