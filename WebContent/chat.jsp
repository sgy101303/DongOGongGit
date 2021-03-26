<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page session="false"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="kr" xmlns="http://www.w3.org/1999/xhtml" xmlns:th="http://www.thymeleaf.org">
<head>
    <link rel="stylesheet" th:href="@{resources/assets/css/styles.css}" />
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Chat - Kokoa Clone</title>
</head>
<body id="chat-screen">
<div class="status-bar">
    <div class="status-bar__column">
        <span>No Service</span>
        <i class="fas fa-wifi"></i>
    </div>
    <div class="status-bar__column">
        <span>18:43</span>
    </div>
    <div class="status-bar__column">
        <span>90%</span>
        <i class="fas fa-battery-full fa-lg"></i>
        <i class="fas fa-bolt"></i>
    </div>
</div>
<header class="alt-header">
    <div class="alt-header__column">
        <a th:href="${'/chat/room/list/'+userId}">
            <i class="fas fa-angle-left fa-3x"></i>
        </a>
    </div>
    <div class="alt-header__column">
        <h1 class="alt-header__title__message" th:if="${userId == chatMessageList.get(0).getSenderId()}" th:text="${chatMessageList.get(0).getReceiverName()}"></h1>
        <h1 class="alt-header__title__message" th:if="${userId == chatMessageList.get(0).getReceiverId()}" th:text="${chatMessageList.get(0).getSenderName()}"></h1>
    </div>
    <div class="alt-header__column">
        <span><i class="fas fa-search fa-lg"></i></span>
        <span><i class="fas fa-bars fa-lg"></i></span>
    </div>
</header>

<main class="main-screen main-chat">
    <div class="chat__timestamp" th:text="${createDataTime}">
    </div>
    <div th:each="message, index : ${chatMessageList}">
        <div class="message-row leftMessage" th:if="${message.getReceiverId() == userId}">
            <img th:src="${message.getSenderProfileImg()}" />
            <div class="message-row__content">
                <span class="message__author" th:text="${message.getSenderName()}"></span>
                <div class="message__info">
                    <span class="message__bubble" th:text="${message.getChatMessage()}"></span>
                    <span class="message__time" th:datetime="${message.getModifiedDateTime()}"></span>
                </div>
            </div>
        </div>
        <div class="message-row rightMessage" th:if="${message.getSenderId() == userId}">
            <div class="message-row message-row--own">
                <div class="message-row__content">
                    <div class="message__info">
                        <span class="message__bubble" th:text="${message.getChatMessage()}"></span>
                        <span class="message__time" th:datetime="${message.getModifiedDateTime()}"></span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<form class="reply">
    <div class="reply__column">
        <i class="far fa-plus-square fa-lg"></i>
    </div>
    <div class="reply__column">
        <input type="text" placeholder="Write a message..." id="message" autofocus/>
        <i class="far fa-smile-wink fa-lg"></i>
        <button id = "send_message_btn" onclick="sendMessage()">
            <i class="fas fa-arrow-up"></i>
        </button>
    </div>
</form>

<div id="no-mobile">
    <span>Your screen is too big ㅠㅠ</span>
</div>

<script
        src="https://kit.fontawesome.com/6478f529f2.js"
        crossorigin="anonymous"
></script>


<script src="http://code.jquery.com/jquery-1.10.2.js"></script>
<script th:inline="javascript">
    /*<![CDATA[*/
    let Message = document.getElementById("message");

    function sendMessage() {
        let message = $('#message').val();
        let chatRoomId = /*[[${chatRoomId}]]*/ '';
        let senderId = /*[[${chatMessageList.get(0).getSenderId}]]*/ '';
        let receiverId = /*[[${chatMessageList.get(0).getReceiverId}]]*/ '';
        let userId = /*[[${userId}]]*/ '';

        if(senderId != userId) {
            let tmp = senderId;
            senderId = userId;
            receiverId = tmp;
        }

        // alert(receiverId);
        //문자열 좌우 공백 제거
        if (message.trim() === '') {
            return;
        }

        let url = '../../../../send/message.do';

        let data = {
            chatRoomId : chatRoomId,
            senderId : senderId,
            receiverId : receiverId,
            readYn : 'N',
            chatMessage : message
        };

        $.ajax({
            url: url ,
            async: false,
            type:'POST',
            data: JSON.stringify(data),
            contentType:'application/json; charset = utf-8',
            dataType: 'json', // 리턴해주는 타입을 지정해줘야함
            success: function(res) {
                // location.reload();

                console.log("호출성공");
                console.log(JSON.parse(res)); //찾아보기
            },// 요청 완료 시
            error:function() {
                console.log("실패입니다.");
            }// 요청 실패.
        });
    }

    //enter 키 누를 시 전송 ajax 불러오기
    $("input[id=message]").keydown(function (key) {
        if(key.keyCode === 13){
            sendMessage(); //실행 명령
        }
    });

    /*]]>*/
</script>

</body>
</html>