//
//  SpeechController.swift
//  Runner
//
//  Created by 송태환 on 12/2/23.
//

import Foundation
import Speech

class SpeechController: SpeechHostApi {
	private let audioEngine = AVAudioEngine()
	private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
	private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko_KR"))
	private var recognitionTask: SFSpeechRecognitionTask?

	private let speechFlutterApi: SpeechFlutterApi

	init(api: SpeechFlutterApi) {
		self.speechFlutterApi = api
	}

	func startRecording(completion: @escaping (Result<Void, Error>) -> Void) {
		guard audioEngine.isRunning == false else {
			completion(.failure(SpeechError.alreadyRecording))
			return
		}

		do {
			recognitionTask?.cancel()
			self.recognitionTask = nil

			let audioSession = AVAudioSession.sharedInstance()
			try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
			try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

			let inputNode = audioEngine.inputNode
			inputNode.removeTap(onBus: 0)
			let recordingFormat = inputNode.outputFormat(forBus: 0)
			inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
				self.recognitionRequest?.append(buffer)
			}

			audioEngine.prepare()
			try audioEngine.start()

			recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
			guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
			recognitionRequest.shouldReportPartialResults = true

			if #available(iOS 13, *) {
				speechRecognizer?.supportsOnDeviceRecognition = true

				if speechRecognizer?.supportsOnDeviceRecognition ?? false {
					recognitionRequest.requiresOnDeviceRecognition = true
					print("iOS: Enable On Device Mode")
				}
			} else {
				print("iOS: Network Mode")
			}

			recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
				print("RESULT")
				if let result = result {
					DispatchQueue.main.async {
						let transcribedString = result.bestTranscription.formattedString
						// MARK: - Native to Flutter
						self.speechFlutterApi.sendSpeechText(text: transcribedString) { result in
							switch result {
							case .failure(let error):
								print(error)
							case .success(_):
								print("Successfully sent text!")
							}
						}
					}
				}

				if error != nil {
					print("ERROR: \(error)")
					self.audioEngine.stop()
					inputNode.removeTap(onBus: 0)
					self.recognitionRequest = nil
					self.recognitionTask = nil
				}
			}
		} catch {
			completion(.failure(error))
		}
	}

	func stopRecording(completion: @escaping (Result<Void, Error>) -> Void) {
		guard audioEngine.isRunning == true else {
			return completion(.failure(SpeechError.alreadyStopped))
		}

		recognitionRequest?.endAudio()
		audioEngine.stop()
		completion(.success(()))
	}

	func getPermissions(){
		SFSpeechRecognizer.requestAuthorization{authStatus in
			OperationQueue.main.addOperation {
				switch authStatus {
				case .authorized:
					print("authorised..")
				default:
					print("none")
				}
			}
		}
	}
}

enum SpeechError: String, Error {
	case alreadyStopped = "Already Stopped"
	case alreadyRecording = "Already Recording"
}
