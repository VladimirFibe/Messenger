//
//  ChatViewController.swift
//  Messenger
//
//  Created by Vladimir Fibe on 17.07.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Gallery
import RealmSwift

class ChatViewController: MessagesViewController {
  // MARK: - Views
  let leftBarButtonView: UIView = {
    
    return $0
  }(UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50)))
  let titleLabel: UILabel = {
    $0.adjustsFontSizeToFitWidth = true
    $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    return $0
  }(UILabel(frame: CGRect(x: 5, y: 0, width: 180, height: 25)))
  
  let subtitleLabel: UILabel = {
    $0.adjustsFontSizeToFitWidth = true
    $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    return $0
  }(UILabel(frame: CGRect(x: 5, y: 22, width: 180, height: 20)))
  
  // MARK: - Vars
  private var chatId = ""
  private var recipientId = ""
  private var recipienName = ""
  
  let currentUser = MKSender(senderId: Person.currentId, displayName: Person.currentPerson?.username ?? "Me")
  
  let refreshController = UIRefreshControl()
  let micButton = InputBarButtonItem()
  var mkMessages: [MKMessage] = []
  var allLocalMessages: Results<LocalMessage>!
  let realm = try! Realm()
  var displayingMessagesCount = 0
  var maxMessageNumber = 0
  var minMessageNumber = 0
  
  var typingCounter = 0
  // MARK: - Listeners
  var notificationToken: NotificationToken?
  // MARK: - Inits
  init(chatId: String, recipientId: String, recipientName: String) {
    super.init(nibName: nil, bundle: nil)
    self.chatId = chatId
    self.recipientId = recipientId
    self.recipienName = recipientName
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    createTypingObserver()
    configureMessageCollectionView()
    configureMessageInputBar()
    configureLefBarButton()
    configureCustomTitle()
    updateTypingIndicator(true)
    loadChats()
    listenForeNewChats()
  }
  // MARK: - Configurations
  private func configureMessageCollectionView() {
    messagesCollectionView.messagesDataSource = self
    messagesCollectionView.messageCellDelegate = self
    messagesCollectionView.messagesDisplayDelegate = self
    messagesCollectionView.messagesLayoutDelegate = self
    scrollsToLastItemOnKeyboardBeginsEditing = true
    maintainPositionOnKeyboardFrameChanged = true
    messagesCollectionView.refreshControl = refreshController
  }
  
  private func configureMessageInputBar() {
    messageInputBar.delegate = self
    let attachButton = InputBarButtonItem()
    attachButton.image = UIImage(systemName: "paperclip", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
    attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
    attachButton.onTouchUpInside { item in
      print("press attach button")
    }
    
    micButton.image = UIImage(systemName: "mic.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
    micButton.setSize(CGSize(width: 30, height: 30), animated: false)
    micButton.onTouchUpInside { item in
      print("add gesture recognizer")
    }
    
    messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
    messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
    messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
    updateMicButtonStatus(show: true)
    messageInputBar.inputTextView.isImagePasteEnabled = false
    messageInputBar.backgroundColor = .systemBackground
    messageInputBar.inputTextView.backgroundColor = .systemBackground
  }
  
  func updateMicButtonStatus(show: Bool) {
    if show {
      messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
      messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
    } else {
      messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
      messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
    }
  }
  
  private func configureLefBarButton() {
    self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonPressed))]
  }
  
  private func configureCustomTitle() {
    leftBarButtonView.addSubview(titleLabel)
    leftBarButtonView.addSubview(subtitleLabel)
    let leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonView)
    self.navigationItem.leftBarButtonItems?.append(leftBarButtonItem)
    titleLabel.text = recipienName
    subtitleLabel.text = "typing .."
  }
  // MARK: - Load Chats
  private func loadChats() {
    let predicate = NSPredicate(format: "chatRoomId = %@", chatId)
    allLocalMessages = realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: "date", ascending: true)
    if allLocalMessages.isEmpty {
      checkForOldChats()
    }
    notificationToken = allLocalMessages.observe({ changes in
      switch changes {
      case .initial:
        self.insertMessages()
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToLastItem(animated: true)
      case .update(_, _, let insertions, _):
        for index in insertions {
          self.insertMessage(self.allLocalMessages[index])
        }
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToLastItem(animated: false)
      case .error(let error):
        print("Error on new insertion: \(error.localizedDescription)")
      }
    })
  }
  
  private func listenForeNewChats() {
    FirebaseMessageListener.shared.listenForNewChats(Person.currentId, collectionId: chatId, lastMessageDate: lastMessageDate())
  }
  
  private func checkForOldChats() {
    FirebaseMessageListener.shared.checkForOldChats(Person.currentId, collectionId: chatId)
  }
  
  // MARK: - Insert Messages
  private func insertMessages() {
    maxMessageNumber = allLocalMessages.count - displayingMessagesCount
    minMessageNumber = maxMessageNumber - kNUMBEROFMESSAGES
    if minMessageNumber < 0 { minMessageNumber = 0 }
    for i in minMessageNumber..<maxMessageNumber {
      let message = allLocalMessages[i]
      insertMessage(message)
    }
  }
  
  private func loadMoreMessages(maxNumber: Int, minNumber: Int) {
    maxMessageNumber = minNumber - 1
    minMessageNumber = maxMessageNumber - kNUMBEROFMESSAGES
    if minMessageNumber < 0 { minMessageNumber = 0 }
    for i in (minMessageNumber...maxMessageNumber).reversed() {
      insertOlderMessage(allLocalMessages[i])
    }
  }
  
  private func insertOlderMessage(_ localMessage: LocalMessage) {
    let incoming = IncomingMessage(_collectionView: self)
    if let message = incoming.createMessage(localMessage: localMessage) {
      self.mkMessages.insert(message, at: 0)
      displayingMessagesCount += 1
    }
  }
  
  private func markMessageAsRead(_ localMessage: LocalMessage) {
    if localMessage.senderId != Person.currentId {
      FirebaseMessageListener.shared.updateMessageInFirebase(localMessage, memberIds: [Person.currentId, recipientId])
    }
  }
  private func insertMessage(_ localMessage: LocalMessage) {
    if localMessage.senderId != Person.currentId {
      markMessageAsRead(localMessage)
    }
    let incoming = IncomingMessage(_collectionView: self)
    if let message = incoming.createMessage(localMessage: localMessage) {
      self.mkMessages.append(message)
      displayingMessagesCount += 1
    }
  }
  
  // MARK: - Actions
  
  func messageSend(text: String? = nil,
                   photo: UIImage? = nil,
                   video: String? = nil,
                   audio: String? = nil,
                   location: String? = nil,
                   audioDuration: Float = 0.0) {
    OutgoingMessage.send(chatId: chatId,
                         text: text,
                         photo: photo,
                         video: video,
                         audio: audio,
                         location: location,
                         memberIds: [recipientId, Person.currentId])
  }
  
  @objc func backButtonPressed() {
    FirebaseRecentListener.shared.resetRecentCounter(chatRoomId: chatId)
    self.removeListeners()
    self.navigationController?.popViewController(animated: true)

//    self.navigationController?.popToRootViewController(animated: true)
  }
  
  // MARK: - update typing indicator
  
  func createTypingObserver() {
    FirebaseTypingListener.shared.createTypingOnserver(chatRoomId: chatId) { isTyping in
      DispatchQueue.main.async {
        self.updateTypingIndicator(isTyping)
      }
    }
  }
  func typingCounerUpdate() {
    typingCounter += 1
    FirebaseTypingListener.saveTypingCounter(typing: true, chatRoomId: chatId)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      self.typingCounterStop()
    }
  }
  
  func typingCounterStop() {
    typingCounter -= 1
    FirebaseTypingListener.saveTypingCounter(typing: false, chatRoomId: chatId)
  }
  func updateTypingIndicator(_ show: Bool) {
    subtitleLabel.text = show ? "Typing ..." : ""
  }
  
  // MARK: -  UIScrollview Delegate
  
  override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if refreshController.isRefreshing {
      if displayingMessagesCount < allLocalMessages.count {
        self.loadMoreMessages(maxNumber: maxMessageNumber, minNumber: minMessageNumber)
        self.messagesCollectionView.reloadDataAndKeepOffset()
      }
      refreshController.endRefreshing()
    }
  }
  // MARK: - Helpers
  
  private func lastMessageDate() -> Date {
    let lastMessageDate = allLocalMessages.last?.date ?? Date()
    return Calendar.current.date(byAdding: .second, value: 1, to: lastMessageDate) ?? lastMessageDate
  }
  
  private func removeListeners() {
    FirebaseTypingListener.shared.removeTypingListener()
    FirebaseMessageListener.shared.removeListener()
  }
}






