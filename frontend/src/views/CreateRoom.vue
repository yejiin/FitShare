<template>
  <div>
    <Navbar />
    <div id="container">
      <div class="create-container">
        <div id="new-room">
          <div id="dialog" class="vertical-center">
            <div class="d-flex flex-row title">
              <i class="bi bi-house-door me-4"></i>
              <h1>New Room</h1>
            </div>
            <div class="form-group position-relative">
              <!-- 입장가능 인원 -->
              <div class="row">
                <label class="counts"><i class="bi bi-asterisk"></i>입장 가능 인원</label>
                <div class="dropdown-wrapper">
                  <div class="form-select" @click="isCntVisible = !isCntVisible">
                    <!-- :class="isFocused ? 'focus-outline': '' " , changeOutline() -->
                    <p v-if="selectedCnt">{{ selectedCnt }}</p>
                    <p v-else>인원수를 선택하세요</p>
                  </div>
                  <div v-show="isCntVisible" class="dropdown-popover">
                    <div class="options">
                      <ul class="scroll cnt-ul">
                        <li v-for="(cnt, index) in counts" :key="index" :value="cnt" @click="selectCnt(cnt)">
                          {{ cnt }}
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
              <p class="cnt-error" v-if="cntError">{{ cntError }}</p>
              <!-- 쇼핑몰 사이트 검색 -->
              <div class="row mall-container">
                <label><i class="bi bi-asterisk"></i>쇼핑몰 사이트</label>
                <div class="dropdown-wrapper">
                  <div class="form-select" @click="isMallListVisible = !isMallListVisible">
                    <p v-if="selectedMall">{{ selectedMall.name }}</p>
                    <p v-else>쇼핑몰을 선택하세요</p>
                  </div>
                  <div v-if="isMallListVisible" class="dropdown-popover">
                    <input
                      @keyup="searchMall()"
                      v-model="searchQuery"
                      class="search-mall-input"
                      type="text"
                      placeholder="쇼핑몰 이름이나 도메인을 검색하세요"
                    />
                    <span v-if="searchedMalls.length === 0"><p class="text-center">검색결과 없음</p></span>
                    <div class="options">
                      <ul class="scroll">
                        <li v-for="mall in searchedMalls" :key="mall.id" :value="mall.name" @click="selectMall(mall)">
                          {{ mall.name }}
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
              <p class="mall-error" v-if="mallError">{{ mallError }}</p>
              <!-- 사이트 직접 입력 -->
              <div class="d-flex flex-row-reverse" v-if="!isMall">
                <div class="mall-input-container">
                  <div class="mall-input mb-2">
                    <label><i class="bi bi-asterisk"></i>사이트 이름</label>
                    <input v-model="inputMallName" class="form-control text-input shadow-none" type="text" />
                  </div>
                  <div class="mall-input">
                    <label><i class="bi bi-asterisk"></i>사이트 주소</label>
                    <input v-model="inputMallUrl" class="form-control text-input shadow-none" type="text" />
                  </div>
                </div>
              </div>
              <!-- 공개범위 설정 -->
              <div
                class="row private-container"
                :class="isPrivate ? 'private-margin-change' : ''"
                :style="[isMall ? { 'margin-top': '203px' } : { 'margin-top': '75px' }]"
              >
                <label>공개범위</label>
                <span class="form-radio">
                  <span @click="selectPublic()" class="radio-box">
                    <input
                      class="form-check-input"
                      type="radio"
                      name="flexRadioDefault"
                      checked="checked"
                      id="public"
                    />
                    <label class="form-check-label" for="public">공개</label>
                  </span>
                  <span @click="selectPrivate()" class="radio-box">
                    <input class="form-check-input" type="radio" name="flexRadioDefault" id="private" />
                    <label class="form-check-label" for="private">비공개</label>
                  </span>
                </span>
              </div>
              <!-- 비밀번호 입력 -->
              <div class="row password-container" v-show="isPrivate">
                <label>비밀번호</label>
                <input
                  v-model="password"
                  class="form-control shadow-none"
                  type="password"
                  placeholder="6자리 이하로 작성해주세요"
                />
                <p class="password-error" v-if="passwordError">{{ passwordError }}</p>
              </div>
              <div class="button-box">
                <button class="btn shadow-none" @click="validationCheck()">생성하기</button>
                <button class="btn shadow-none" @click="goToMain()">취소</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { reactive, ref, toRefs, watch } from "vue";
import { useRouter } from "vue-router";
import axios from "../api/axios";
import Navbar from "@/components/Navbar.vue";

export default {
  name: "CreateRoom",
  components: { Navbar },
  setup() {
    const router = useRouter();

    let counts = ref([1, 2, 3, 4, 5, 6]);
    let selectedCnt = ref(null);
    let isCntVisible = ref(false);

    let searchQuery = ref("");
    let searchedMalls = ref({}); // 쇼핑몰 검색결과
    let selectedMall = ref(null);
    let isMallListVisible = ref(false);

    let isPrivate = ref(false);
    let password = ref(null);

    const error = reactive({
      cntError: null,
      mallError: null,
      passwordError: null,
    });

    const state = reactive({
      isMall: true,
      inputMallName: null,
      inputMallUrl: null,
    });

    // 쇼핑몰 입력부분 생성
    watch(searchedMalls, (searchedMalls) => {
      if (searchedMalls.length === 0) {
        state.isMall = false;
        selectedMall.value = null;
      } else {
        state.isMall = true;
      }
    });

    // select dropdown
    const selectCnt = (cnt) => {
      selectedCnt.value = cnt;
      isCntVisible.value = false;
    };

    const selectMall = (mall) => {
      selectedMall.value = mall;
      isMallListVisible.value = false;
    };

    // 쇼핑몰 검색
    const searchMall = () => {
      axios
        .get(`shopping-malls?keyword=${searchQuery.value}`)
        .then((res) => {
          searchedMalls.value = res.data.data;
        })
        .catch((err) => console.log(err));
    };

    // dropdown 닫기
    document.addEventListener("click", function (e) {
      if (isMallListVisible.value == true) {
        if (
          e.target.className !== "dropdown-popover" &&
          e.target.className !== "form-select" &&
          e.target.className !== "" &&
          e.target.className !== "search-mall-input"
        ) {
          isMallListVisible.value = false;
        }
      }
      if (isCntVisible.value == true) {
        if (
          e.target.className !== "dropdown-popover" &&
          e.target.className !== "form-select" &&
          e.target.className !== "" &&
          e.target.className !== "search-mall-input"
        ) {
          isCntVisible.value = false;
        }
      }
    });

    const selectPrivate = () => {
      isPrivate.value = true;
    };

    const selectPublic = () => {
      isPrivate.value = false;
    };

    // 유효성 검사
    const validationCheck = () => {
      let isValid = true;
      // 인원수
      if (!selectedCnt.value) {
        error.cntError = "인원수를 선택해주세요!";
        isValid = false;
      } else error.cntError = "";

      // 쇼핑몰 확인
      if (!selectedMall.value) {
        if (!state.inputMallName || !state.inputMallUrl) {
          error.mallError = "쇼핑몰을 선택하거나 입력해주세요!";
          isValid = false;
        } else error.mallError = "";
      } else error.mallError = "";

      // 비밀번호 확인
      if (isPrivate.value) {
        if (!password.value) {
          error.passwordError = "비밀번호를 입력해주세요";
          return;
        } else if (password.value.length > 6) {
          error.passwordError = "비밀번호는 6자리 이하로 작성해주세요";
          return;
        } else error.passwordError = "";
      }
      if (isValid) makeShoppingRoom();
    };

    // 쇼핑룸 생성
    const makeShoppingRoom = () => {
      let mallId = null;
      if (selectedMall.value) {
        mallId = selectedMall.value.id;
        state.inputMallName = null;
        state.inputMallUrl = null;
      }
      if (!isPrivate.value) password.value = null;

      const roomData = {
        customShoppingMall: !state.isMall,
        participantCount: selectedCnt.value,
        password: password.value,
        private: isPrivate.value,
        shoppingMallId: mallId,
        shoppingMallName: state.inputMallName,
        shoppingMallUrl: state.inputMallUrl,
      };

      axios
        .post("shopping-rooms/", roomData)
        .then((res) => {
          const data = res.data.data;
          router.push({
            name: "ShoppingRoom",
            params: {
              roomId: data.shoppingRoomId,
              token: data.token,
              mallUrl: data.shoppingRoomUrl,
              hostId: data.hostId,
            },
          });
        })
        .catch((err) => {
          if (err.response.data.statusCode == 400) {
            error.mallError = "유효하지 않은 쇼핑몰입니다. 다시 입력해주세요.";
          }
        });
    };

    const goToMain = () => {
      router.push({ name: "Main" });
    };

    return {
      selectPrivate,
      selectPublic,
      makeShoppingRoom,
      goToMain,
      ...toRefs(state),
      ...toRefs(error),
      counts,
      searchQuery,
      selectedCnt,
      selectedMall,
      isMallListVisible,
      isCntVisible,
      selectMall,
      selectCnt,
      isPrivate,
      password,
      searchedMalls,
      searchMall,
      validationCheck,
    };
  },
};
</script>

<style scoped>
#container {
  display: flex;
  justify-content: center;
}

.create-container {
  display: flex;
  justify-content: center;
}

#new-room {
  margin: 40px 187px 0px;
  width: 682px;
  height: 831px;
  background: #fdfaf3;
  border-radius: 16px;
  box-shadow: 0 0 5px 1px #dadada;
}

.row {
  display: flex;
  justify-content: space-between;
  height: 35px;
  line-height: 35px;
}

.dropdown-wrapper {
  width: 454px;
  height: 35px;
  position: relative;
  padding: 0;
}

.dropdown-popover {
  z-index: 2;
  position: absolute;
  border: 1px solid lightgray;
  top: 35px;
  left: 0;
  right: 0;
  background-color: #fff;
  max-width: 100%;
  min-height: 40px;
  padding: 10px;
  box-shadow: 0 0 6px #d3e2e7;
}

.form-select {
  width: 454px;
  height: 35px;
  padding: 5px 10px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 1rem;
  cursor: pointer;
}

p {
  margin: 0;
}

.bi-asterisk {
  font-size: 10px;
  color: red;
  margin-right: 4px;
}

.mall-container {
  margin-top: 80px;
}

.search-mall-input {
  width: 100%;
  height: 30px;
  border: 1px solid lightgray;
  border-radius: 2px;
  font-size: 16px;
  padding-left: 8px;
}

.options {
  width: 100%;
}

ul {
  list-style: none;
  text-align: left;
  padding-left: 8px;
  max-height: 115px;
  overflow-y: scroll;
}
.cnt-ul {
  max-height: 100px;
}

li {
  width: 100%;
  border-bottom: 1px solid lightgray;
  cursor: pointer;
  font-size: 16px;
}

li:hover {
  width: 100%;
  border-bottom: 1px solid lightgray;
  background-color: lightgray;
  cursor: pointer;
  font-size: 16px;
}

input:focus {
  outline: none;
  box-shadow: none;
}

.title {
  font-size: 36px;
  margin-bottom: 60px;
}

#dialog {
  margin: 27px 30px 0;
}

label {
  font-size: 20px;
  width: 170px;
  height: 38px;
  line-height: 38px;
}

/* 비밀번호 여부 */
.private-container {
  margin-bottom: 159px;
}

.private-margin-change {
  margin-top: 75px;
  margin-bottom: 54px;
}

.form-radio {
  display: flex;
  flex-direction: row;
  margin-right: 115px;
  width: 350px;
}

.radio-box {
  display: flex;
  flex-direction: row;
}

.form-radio input {
  margin: 9px 18px 5px 0;
}

.form-radio label {
  font-size: 20px;
  width: 60px;
  margin-right: 73px;
  cursor: pointer;
}

.mall-input-container {
  width: 530px;
  display: flex;
  flex-direction: column;
  margin-top: 44px;
}

.mall-input {
  display: flex;
  flex-direction: row;
}

.text-input {
  width: 324px;
  height: 35px;
}

.password-container {
  margin-bottom: 70px;
}

.password-container input {
  width: 454px;
  height: 35px;
}

.password-container input:focus {
  border: 2px solid #d3e2e7;
  box-shadow: 0 0 10px #d3e2e7;
}

.password-container input::placeholder {
  text-align: start;
}

.button-box {
  text-align: center;
}

button {
  width: 250px;
  height: 50px;
  flex-grow: 0;
  margin: 0 15px;
  border-radius: 12px;
  /* border: solid 2px #000; */
  background: #8abdbe;
  box-shadow: 0 0 10px black;
}

/* error */
.cnt-error {
  color: red;
  margin: 5px 0 0 285px;
}
.mall-error {
  color: red;
  margin: 5px 0 0 285px;
}
.password-error {
  color: red;
  margin-left: 285px;
}

/* scroll */
.scroll::-webkit-scrollbar {
  width: 7px;
}
.scroll::-webkit-scrollbar-track {
  background-color: transparent;
}
.scroll::-webkit-scrollbar-thumb {
  border-radius: 10px;
  background-color: #d3e2e7;
}
</style>
