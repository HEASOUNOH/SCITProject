package global.sesoc.www.socket;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import global.sesoc.www.dao.T_MessageRepository;
import global.sesoc.www.dto.T_Message;
import global.sesoc.www.dto.T_MessageRoom;

public class EchoHandler extends TextWebSocketHandler {

	@Autowired
	T_MessageRepository repository;
	
	int count = 0;

	 private static final Logger logger = LoggerFactory.getLogger(EchoHandler.class);
	   private List<T_MessageRoom> RoomList = new ArrayList<>();
	   private List<WebSocketSession> sessionList = new ArrayList<WebSocketSession>();
	   private List<T_MessageRoom> slist = new ArrayList<>();

	   @Override
	   public void afterConnectionEstablished(WebSocketSession session) throws Exception {
	      sessionList.add(session);
	      logger.info("{} 연결됨", session.getId());
	   }

	   @Override
	   protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
	      // TODO Auto-generated method stub
	      logger.info("{}로부터 {}받음", session.getId(), message.getPayload());
	      String userA = null;
	      String talker = session.getId();
	      String userB = null;
	      // 채팅 시간 저장
	      Date chatDate = new Date();
	      SimpleDateFormat datetype = new SimpleDateFormat("yyyy/MM/dd ");
	      SimpleDateFormat time = new SimpleDateFormat(" hh시mm분ss초 a");
	      String date = datetype.format(chatDate);
	      date += time.format(chatDate);

	      int index = 0;
	      if (message.getPayload().indexOf(":::") != -1) {
	         String userid = message.getPayload().split(":::")[1];
	         T_MessageRoom chat = new T_MessageRoom(userid, session.getId(), session);
	         repository.addUser(chat);
	         RoomList.add(chat);
	         return;
	      }
	      //0번 메시지 , 1번 리시브 아이디, 2번 보내는 아이디
	      String mesContext = message.getPayload().split("-")[0];
	      userB = message.getPayload().split("-")[1];
	      userA = message.getPayload().split("-")[2];

	      boolean flag = false;
	      
	      for (T_MessageRoom chat : RoomList) {
	         if(userB.equals(chat.getUserid())) {
	            flag = true;
	         }
	      }
	      if(flag) {
	    	  T_Message msg = new T_Message(mesContext, userA, userB, 0);
	         repository.addMessage(msg);
	      } else {
	    	  T_Message msg = new T_Message(mesContext, userA, userB, 1);
	         repository.addMessage(msg);
	      }

	      boolean flag2 = false;
	      
	      for (T_MessageRoom chat1 : RoomList) {
	         if (userB.equals(chat1.getUserid())) {
	            flag2 = true;
	            T_MessageRoom chat = new T_MessageRoom(chat1.getUserid(), chat1.getId(), chat1.getSession());
	            slist.add(chat);
	         }
	      }
	      if(flag2) {
	         slist.get(slist.size()-1).getSession().sendMessage(new TextMessage(message.getPayload() + "-" + date));
	      }
	      
	      logger.info("{}로부터 {}받음", session.getId(), message.getPayload());
	   }

	   @Override
	   public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
	      sessionList.remove(session);
	      int s = 0;
	      for (int i = 0; i < RoomList.size(); i++) {
	         if (RoomList.get(i).getId().equals(session.getId())) {
	            s = i;
	            repository.deleteUser(RoomList.get(i).getId());
	            break;
	         }
	      }
	      RoomList.remove(s);

	      logger.info("{} 연결끊김", session.getId());
	   }
}
