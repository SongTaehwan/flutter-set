//
//  TexToSpeechController.swift
//  Runner
//
//  Created by 송태환 on 12/4/23.
//

import AVFoundation

class TextToSpeechController: NSObject, TextToSpeechHostApi {
	private let synthesizer = AVSpeechSynthesizer()

	override init() {
		super.init()
		AVSpeechSynthesisVoice.speechVoices()
		synthesizer.delegate = self
	}

	func speak(text: String, completion: (Result<Bool, Error>) -> Void) {
		let isSpeaking = synthesizer.stopSpeaking(at: .immediate)
		let utterance = AVSpeechUtterance(string: text)
		utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
		synthesizer.speak(utterance)

		completion(.success(isSpeaking))
	}

	func stopSpeaking(completion: @escaping (Result<Bool, Error>) -> Void) {
		let isStopped = synthesizer.stopSpeaking(at: .immediate)
		completion(.success(isStopped))
	}
}

extension TextToSpeechController: AVSpeechSynthesizerDelegate {
	func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
		print("all done")
	}
}
