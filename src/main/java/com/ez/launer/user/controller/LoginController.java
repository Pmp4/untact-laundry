package com.ez.launer.user.controller;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.mail.MessagingException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ez.launer.user.model.DmailSender;
import com.ez.launer.user.model.DriverAllVO;
import com.ez.launer.user.model.EmailSender;
import com.ez.launer.user.model.SHA256Encryption;
import com.ez.launer.user.model.UserService;
import com.ez.launer.user.model.UserVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class LoginController {
	private static final Logger logger
	=LoggerFactory.getLogger(LoginController.class);
	
	private static final Logger accessLogger
	=LoggerFactory.getLogger("accessLogger");

	
	private final UserService userService;
	private final SHA256Encryption sha256;
	private final EmailSender emailSender;
	private final DmailSender dmailSender;

	@GetMapping("/login")
	public String login_get() {

		logger.info("로그인 화면");
		
		
		return "/user/login";
	}

	@PostMapping("/login")
	public String login_post(@ModelAttribute UserVO vo,
		@RequestParam(required = false) String saveUseremail,
		HttpServletRequest request,HttpServletResponse response, 
		Model model) throws NoSuchAlgorithmException {
		logger.info("로그인 처리, 파라미터 vo={}, saveUseremail={}", vo, saveUseremail);
		
		
		String pwd = sha256.encrypt(vo.getPwd());
		vo.setPwd(pwd);

		int result=userService.loginChk(vo.getEmail(), vo.getPwd());
		logger.info("들어온 값, vo.getEmail={},vo.getPwd={}",vo.getEmail(),vo.getPwd());
		logger.info("로그인 처리 결과 result={}", result);
		
		
		String msg="로그인 처리 실패", url="/user/login";
		if(result==UserService.LOGIN_OK) {
			UserVO uVo=userService.selectByEmail(vo.getEmail());
			logger.info("로그인 처리-회원정보 조회결과 uVo={}", uVo);

			//accesslog 추가
			accessLogger.info("userNO={}",uVo.getNo());

			HttpSession session=request.getSession();
			session.setAttribute("email", vo.getEmail());
			session.setAttribute("name", uVo.getName());
			session.setAttribute("no", uVo.getNo());
			session.setAttribute("classNo", String.valueOf(uVo.getUserCode()));
			
			Cookie ck = new Cookie("chkUseremail", vo.getEmail());
			ck.setPath("/");
			if(saveUseremail!=null) {  //아이디 저장하기 체크한 경우
				ck.setMaxAge(1000*24*60*60);
				response.addCookie(ck);
			}else {
				ck.setMaxAge(0);  //쿠키 제거
				response.addCookie(ck);				
			}
			
			msg=uVo.getName() +"님 로그인되었습니다.";

			//리턴 페이지 관련 로직//
			//리턴 페이지 관련 로직//
			Cookie[] cookies = request.getCookies();
			int returnURLChk = 0;
			String returnURL = "";
			for(Cookie cookie : cookies) {
				if(cookie.getName().equals("tempURL")) {
					returnURLChk++;
					returnURL = cookie.getValue();
					break;
				}
			}

			Cookie myCookie = new Cookie("tempURL", null);
			myCookie.setMaxAge(0);
			myCookie.setPath("/");
			response.addCookie(myCookie);

			if(returnURLChk > 0) {
				url = returnURL;
			}else {
				url="/";
			}
			//리턴 페이지 관련 로직//
			//리턴 페이지 관련 로직//
		}else if(result==UserService.DISAGREE_PWD) {
			msg="비밀번호가 일치하지 않습니다.";
		}else if(result==UserService.NONE_USEREMAIL) {
			msg="해당 이메일이 존재하지 않습니다.";			
		}
		
		model.addAttribute("msg", msg);
		model.addAttribute("url", url);
		
		return "/common/message";
	}
	
	@GetMapping("/findId")
	public void findId() {
		logger.info("이메일 찾기 화면");

	}
	
	@ResponseBody
	@PostMapping("/findId")
	public String findId_post(@ModelAttribute UserVO vo, DriverAllVO dvo,
			@RequestParam int searchType, Model model) {
		String result="";
		
		if(searchType==1) {
			logger.info("일반회원 이메일 찾기, 파라미터 vo={}, searchType={}",vo, searchType);
				
			String findEmail=userService.findEmail(vo);
			if(findEmail==null || findEmail.isEmpty()) {
				result="해당 정보와 일치하는 이메일이 존재하지 않습니다";
			}else {
				result=findEmail;
			}
			
			logger.info("일반회원 이메일 찾기 정보 결과 result={}", result);
			model.addAttribute("result", result);
		}else if(searchType==2) {
			logger.info("배송기사 이메일 찾기, 파라미터 dvo={}, searchType={}",dvo, searchType);
			
			String findDmail=userService.findDmail(dvo);
			if(findDmail==null || findDmail.isEmpty()) {
				result="해당 정보와 일치하는 이메일이 존재하지 않습니다";
			}else {
				result=findDmail;
			}
			
			logger.info("배송기사 이메일 찾기 정보 결과 result={}", result);
			model.addAttribute("result", result);
		}
		
		return result;
	}
	
	@GetMapping("/findPwd")
	public void findPwd() {
		logger.info("비밀번호 찾기 화면");

	}
	
	@PostMapping("/findPwd")
	public String findPwd_post(@ModelAttribute UserVO vo, DriverAllVO dvo,
			@RequestParam int searchType, Model model) throws NoSuchAlgorithmException, MessagingException {
		int result=0, socialChk=0;
		String randomPwd="";
		//임시비밀번호 만들기
		StringBuffer sb = new StringBuffer();
		StringBuffer sc = new StringBuffer("!@#$%^&*-=?~");// 특수문자 이상한거는 뺌
		// 대문자
		sb.append((char)((Math.random() * 26)+65)); // 첫글자 대문자

		for( int i = 0; i<3; i++) {
			sb.append((char)((Math.random() * 26)+65));
		} 
		// 소문자 4개
		for( int i = 0; i<4; i++) {
			sb.append((char)((Math.random() * 26)+97));
		}  
		// 숫자 2개
		for( int i = 0; i<2; i++) {
			sb.append((char)((Math.random() * 10)+48));
		}
		// 특수문자를 두개  발생시켜 랜덤하게 중간에 끼워 넣는다
		
		//대문자3개중 하나
		sb.setCharAt(((int)(Math.random()*3)+1), sc.charAt((int)(Math.random()*sc.length()-1))); 
		
		//소문자4개중 하나
		sb.setCharAt(((int)(Math.random()*4)+4), sc.charAt((int)(Math.random()*sc.length()-1))); 
		randomPwd = sb.toString();


		if(searchType==1) {
			logger.info("일반회원 비밀번호 찾기, 파라미터 vo={}, searchType={}",vo, searchType);
			
		
			String encodingRandomPwd = sha256.encrypt(randomPwd);
			vo.setRandomPwd(encodingRandomPwd);
			logger.info("임시비밀번호 , 암호화된 임시비밀번호 randomPwd={}, vo.getRandomPwd={} ",randomPwd, encodingRandomPwd);
			
			socialChk=userService.chkSocial(vo.getEmail());
			logger.info("소셜 계정여부 확인 결과 socialChk={}", socialChk);
			
			String msg="", url="";
			if(socialChk!=userService.SOCIAL_EMAIL) {
				result=userService.randomPwd(vo);
				logger.info("일반회원 임시비밀번호 부여 결과 result={}", result);
				if(result>0) {
					msg="입력하신 이메일 주소로 임시 비밀번호가 발송되었습니다.                "
							+ "임시비밀번호로 로그인 후 비밀번호를 변경해주시기 바랍니다.";
					url="/user/login";	
					
					//emailSender.sendEmail(vo,randomPwd);
					
				}else {
					msg="해당 정보와 일치하는 계정이 존재하지 않습니다";
					url="/user/findPwd";
				}
			}else {
				msg="해당 이메일 주소는 소셜계정으로 가입된 이메일 입니다. 러너 일반회원으로 가입된 계정만 이용가능한 서비스 입니다.";
				url="/user/login";
			}
			
			model.addAttribute("msg", msg);
			model.addAttribute("url", url);
			
		}else if(searchType==2) {
			logger.info("일반회원 비밀번호 찾기, 파라미터 vo={}, searchType={}",dvo, searchType);
			
			String encodingRandomPwd = sha256.encrypt(randomPwd);
			dvo.setRandomPwd(encodingRandomPwd);
			logger.info("임시비밀번호 , 암호화된 임시비밀번호 randomPwd={}, vo.getRandomPwd={} ",randomPwd, encodingRandomPwd);
			
			result=userService.randomDpwd(dvo);
			logger.info("배송기사 임시비밀번호 부여 결과 result={}", result);
			String msg="", url="";
			
			if(result>0) {
				msg="입력하신 이메일 주소로 임시 비밀번호가 발송되었습니다.                "
						+ "임시비밀번호로 로그인 후 비밀번호를 변경해주시기 바랍니다.";
				url="/user/login";	

				//dmailSender.sendDmail(dvo,randomPwd);

			}else {
				msg="해당 정보와 일치하는 계정이 존재하지 않습니다";
				url="/user/findPwd";
			}
			
			model.addAttribute("msg", msg);
			model.addAttribute("url", url);
			
		}
		
		return "/common/message";
	}
	
	@GetMapping("/findId_modal")
	public void findId_modal() {
		logger.info("아이디 찾기 모달");

	}

	
}