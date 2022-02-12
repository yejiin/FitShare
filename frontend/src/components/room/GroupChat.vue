<template>
  <div class="container">
    <label><b>Group chat</b></label>
    <!-- <div id="msgArea" class="col"></div> -->
    <div>
      <textarea
        name=""
        id="textarea"
        class="col"
        cols="30"
        rows="10"
        :value="state.textarea"
        disabled
      ></textarea>
    </div>
    <div>
      <label for="message">Your Message</label>
      <input
        type="text"
        class="border-2 border-slid rounded border-gray-600 w-full p-2"
        id="message"
        v-model="state.message"
        @keyup.enter="sendMessage()"
        autofocus
      />
      <button
        class="border-2 border-slid rounded border-gray-600 w-full p-2"
        type="button"
        @click="sendMessage()"
      >
        전송
      </button>
    </div>
  </div>
</template>

<script>
import { reactive, computed, onMounted } from "vue";
import { useRoute } from "vue-router";
import { useStore } from "vuex";
import { useCookies } from "vue3-cookies";

import SockJS from "sockjs-client";
import Stomp from "stompjs";

export default {
  name: "GroupChat",
  setup() {
    const route = useRoute();
    const store = useStore();
    const { cookies } = useCookies();

    onMounted(() => {
      connect();
    });

    const state = reactive({
      roomId: 0,
      userName: "",
      message: "",
      textarea: "",
    });

    state.roomId = route.params.roomId; // 쇼핑룸 생성 시 쇼핑룸 id 가져오기
    state.userName = computed(() => store.state.login.user_name); // vuex에서 가져오기

    var sockJs = new SockJS("http://i6a405.p.ssafy.io/api/v1/chat");
    var stomp = Stomp.over(sockJs);

    const accessToken = cookies.get("accessToken");

    // 연결
    const connect = () => {
      stomp.connect(
        {
          Authorization: "Bearer " + accessToken,
        },
        (frame) => {
          console.log("------ connect -------");
          console.log(frame);
          console.log("---------------------");
          console.log("------ subscribe -------");
          console.log("/topic/rooms/" + state.roomId);
          console.log("---------------------");
          // 구독 (채팅방을 구독한다고 생각하면 된다)
          stomp.subscribe(`/topic/rooms/${state.roomId}`, (response) => {
            // 구독을 설정할 때, 메시지를 받으면 어떻게 처리할건지도 설정
            console.log("------ onMessage -------");
            console.log(response);
            console.log("---------------------");
            getMessages(response);
          });
        }
      );
    };

    // 메세지를 보냈을 때
    const sendMessage = () => {
      if (state.message !== "") {
        let sendMsg = {
          roomId: state.roomId,
          senderName: state.userName,
          message: state.message,
        };
        stomp.send(
          `/app/rooms/${state.roomId}`,
          {
            Authorization: "Bearer " + accessToken,
          },
          JSON.stringify(sendMsg)
        );
        state.message = "";
      }
    };

    // 메세지를 받았을 때
    const getMessages = (receiveMsg) => {
      // Stomp
      var receiveMsgBody = JSON.parse(receiveMsg.body);
      console.log(receiveMsg);
      state.textarea +=
        "[" +
        receiveMsgBody.senderName +
        "] : " +
        receiveMsgBody.message +
        "\n";
    };

    return {
      state,
      sockJs,
      stomp,
      accessToken,
      connect,
      sendMessage,
      getMessages,
    };
  },
};
</script>

<style scoped>
#textarea {
  height: 700px;
  resize: none;
}
</style>
