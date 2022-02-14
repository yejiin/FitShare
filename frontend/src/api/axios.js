import axios from "axios";
import { useRouter } from "vue-router";
// import { useCookies } from "vue3-cookies";
import { useStore } from "vuex";

const http = axios.create({
  baseURL: "https://i6a405.p.ssafy.io/api/v1/",
  headers: {
    "Content-type": "application/json",
  },
});

// const { cookies } = useCookies();
const router = useRouter();
const store = useStore();

/* axios 요청 전 헤더 설정 */
http.interceptors.request.use((config) => {
  config.headers[
    "Authorization"
  ] = `Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI0Iiwicm9sZXMiOiJVU0VSIiwiZXhwIjoxNjQ3OTA5NTI5fQ.l1TfGZtQarYUWrLy6uI-6gFLX5CVQn62t28USVkJe0_kazLFL824YCDLrGbxx1hAhBWe5lxbtK5SArTgOP77uA`;
  return config;
});

/* axios 응답 후 401 에러 처리 */
http.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response.data.status == 401) {
      const isLogin = store.getters["user/isLogin"];

      if (!isLogin) {
        // alert 추가
        router.push({ name: "Login" });
      } else {
        const originalRequest = error.config;
        const refreshToken = store.getters["user/refreshToken"];
        await store.dispatch("user/refreshToken", {
          refreshToken: refreshToken,
        });

        return axios(originalRequest);
      }
    }

    throw error;
  }
);

export default http;
