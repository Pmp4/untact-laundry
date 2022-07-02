package com.ez.launer.user.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpSession;


@Controller
@RequestMapping("/user/login/naver")
public class NaverLoginController {
    private static final Logger logger = LoggerFactory.getLogger(NaverLoginController.class);
    private final String CLIENT_ID = "sA1wXjzUVJ_q15yX5Z3k";
    private final String CLIENT_SECRET = "LzHF30VRtz";


    /*
    * oAuth2.0 에 접근? 하기 위한 절차는
    * [1] 인가코드 발급 (프론트단에서 받아옴)
    * [2] 인가코드를 토대로 액세스토큰을 발급(이건 백엔드)
    * [3] 액세스 토큰을 활용해 사용자 정보를 json형태로 받는다
    * 몰루
    * */

    //[2]인가코드를 바탕으로 액세스 토큰을 발급받는다.
    private String getAccessToken(String code, String state) throws JsonProcessingException {
        // HTTP Header 생성
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        // HTTP Body 생성
        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("grant_type", "authorization_code");
        body.add("client_id", CLIENT_ID);
        body.add("client_secret", CLIENT_SECRET);
        body.add("code", code);
        body.add("state", state);

        // HTTP 요청 보내기
        HttpEntity<MultiValueMap<String, String>> naverTokenRequest =
                new HttpEntity<>(body, headers);
        RestTemplate rt = new RestTemplate();
        ResponseEntity<String> response = rt.exchange(
                "https://nid.naver.com/oauth2.0/token",
                HttpMethod.POST,
                naverTokenRequest,
                String.class
        );

        // HTTP 응답 (JSON) -> 액세스 토큰 파싱
        String responseBody = response.getBody();
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(responseBody);
        return jsonNode.get("access_token").asText();
    }

    private JsonNode getNaverUserInfo(String accessToken) throws JsonProcessingException {
        // HTTP Header 생성
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        // HTTP 요청 보내기
        HttpEntity<MultiValueMap<String, String>> naverUserInfoRequest = new HttpEntity<>(headers);
        RestTemplate rt = new RestTemplate();
        ResponseEntity<String> response = rt.exchange(
                "https://openapi.naver.com/v1/nid/me",
                HttpMethod.POST,
                naverUserInfoRequest,
                String.class
        );

        // HTTP 응답 받아오기
        String responseBody = response.getBody();
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(responseBody);

        /*Long id = jsonNode.get("response").get("id").asLong();
        String nickname = jsonNode.get("response").get("nickname").asText();
        String profileImage = jsonNode.get("response").get("profile_image").asText();*/
        JsonNode jsonResponse = jsonNode.get("response");

        /*return NaverUserInfoDto.builder()
                .id(id)
                .nickname(nickname)
                .profileImage(profileImage)
                .build();*/
        return jsonResponse;
    }



    @RequestMapping("/auth")
    @ResponseBody
    public String authNaver(@RequestParam String code, @RequestParam String state)
            throws JsonProcessingException {
        logger.info("code : {}", code);

        String accessToken = getAccessToken(code, state);
        logger.info("accessToken : {}", accessToken);

        JsonNode json = getNaverUserInfo(accessToken);

        logger.info("json : {}", json);

        return "code : " + code;
    }
}