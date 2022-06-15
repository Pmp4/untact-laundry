package com.ez.launer.admin;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminController {
	
	private static final Logger logger
		= LoggerFactory.getLogger(AdminController.class);

	//private final MemberService memberService;
	
	@RequestMapping("/main")
	public String main() {
		logger.info("메인 페이지");
		
		return "/admin/main";
	}
	
	@RequestMapping("/")
	public String index() {
		logger.info("index 페이지");
		
		return "/admin/index";
	}
}