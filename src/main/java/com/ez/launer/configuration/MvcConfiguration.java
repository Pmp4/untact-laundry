package com.ez.launer.configuration;

import java.util.Collections;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.SessionCookieConfig;
import javax.servlet.SessionTrackingMode;

import org.springframework.boot.web.servlet.ServletContextInitializer;
import com.ez.launer.controller.*;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class MvcConfiguration implements WebMvcConfigurer{

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		// 레지스트리에 인터셉터 등록
		registry.addInterceptor(new LoginInterceptor())
				.addPathPatterns("/laundryService/**")
				.addPathPatterns("/mypage/**")
				.addPathPatterns("/user/**")
				.excludePathPatterns("/mypage/signout")
				.excludePathPatterns("/user/join/**", "/user/login/**", "/user/logout")
				.excludePathPatterns("/user/findId/**", "/user/findPwd/**")
				.excludePathPatterns("/user/checkEmail/**", "/user/checkHp/**")
				.excludePathPatterns("/user/kakaoLogin/**")
				.excludePathPatterns("/user/checkEmail/**")
				.excludePathPatterns("/user/checkHp/**")
				.excludePathPatterns("/user/checkDhp/**")
				.excludePathPatterns("/user/findPwd/**")
				.excludePathPatterns("/user/pricelist/**")
				.excludePathPatterns("/user/chkAddress/**")
				.excludePathPatterns("/user/agreement/**")
				.excludePathPatterns("/user/privacy/**")
				.excludePathPatterns("/laundryService/order/guide");

		registry.addInterceptor(new DeliveryInterceptor())
				.addPathPatterns("/delivery/**")
				.excludePathPatterns("/delivery/join/**")
				.excludePathPatterns("/delivery/checkDmail/**")
				.excludePathPatterns("/delivery/checkDhp/**");

		registry.addInterceptor(new AdminInterceptor())
				.addPathPatterns("/admin/**")
				.excludePathPatterns("/admin/adminLogin");

		registry.addInterceptor(new LoginReturnInterceptor())
				.addPathPatterns("/mypage/signout")
				.addPathPatterns("/user/join/**", "/user/login/**")
				.addPathPatterns("/user/findId/**", "/user/findPwd/**")
				.addPathPatterns("/user/kakaoLogin/**")
				.addPathPatterns("/user/findPwd/**")
				.addPathPatterns("/user/chkAddress/**")
				.addPathPatterns("/delivery/join/**")
				.addPathPatterns("/delivery/checkDmail/**")
				.addPathPatterns("/admin/adminLogin")
				.excludePathPatterns("/delivery/checkDhp/**");


		/*registry.addInterceptor(new LoginInterceptor())
				.addPathPatterns("/laundryService/**")
				.addPathPatterns("/mypage/**")
				.addPathPatterns("/user/**")
				.excludePathPatterns("/user/login/**")
				.excludePathPatterns("/user/join/**")
				.excludePathPatterns("/user/findId/**")
				.excludePathPatterns("/user/findPwd/**")
				.excludePathPatterns("/user/checkEmail/**")
				.excludePathPatterns("/user/checkHp/**")
				.excludePathPatterns("/mypage/signout")
				.excludePathPatterns("/user/kakaoLogin/**")
				.excludePathPatterns("/user/checkEmail/**")
				.excludePathPatterns("/user/checkHp/**")
				.excludePathPatterns("/user/findPwd/**")
				.excludePathPatterns("/user/pricelist/**")
				.excludePathPatterns("/user/chkAddress/**")
				.excludePathPatterns("/laundryService/order/guide");
		
		//관리자 인터셉터
		registry.addInterceptor(new AdminLoginInterceptor())
				.addPathPatterns("/admin/**")
				.excludePathPatterns("/admin/adminLogin");

		registry.addInterceptor(new DeliveryInterceptor())
				.addPathPatterns("/delivery/**")
				.excludePathPatterns("/delivery/join/**")
				.excludePathPatterns("/delivery/checkDmail/**")
				.excludePathPatterns("/delivery/checkDhp/**");
//				.excludePathPatterns("/delivery/board/notice");

		registry.addInterceptor(new AdminLogoutInterceptor())
						.addPathPatterns("/*")
								.excludePathPatterns("/admin/**");
*//*
		registry.addInterceptor(new AdminLogoutInterceptor())
//				.addPathPatterns("/*")
				.addPathPatterns("/user/**")
//				.addPathPatterns("/delivery/**")
				.excludePathPatterns("/admin/**")
//				.excludePathPatterns("/user/login/**")
//				.excludePathPatterns("/user/join/**")
				.excludePathPatterns("/user/board/**");
//				.excludePathPatterns("/delivery/board/**");*//*


		registry.addInterceptor(new LoginCheckInterceptor())
				.addPathPatterns("/user/login/**")
				.addPathPatterns("/user/join/**")
				.addPathPatterns("/delivery/join/**");
*/
		/*registry.addInterceptor(new AdminLoginInterceptor())
		.excludePathPatterns("/admin/login/adminLogin")
		//=> 인터셉처 설정한 경로중에서, 제외할 경로 설정(예외처리)
		.addPathPatterns("/admin/**");*/
		//=> 같은뜻! => .addPathPatterns("/admin/*/*", "/admin/*");
	}

	@Bean
	public CommonsMultipartResolver multipartResolver() {
		CommonsMultipartResolver multipartResolver 
			= new CommonsMultipartResolver();
		multipartResolver.setDefaultEncoding("UTF-8"); // 파일 인코딩 설정
		multipartResolver.setMaxUploadSizePerFile(20 * 1024 * 1024); // 파일당 업로드 크기 제한 (2MB)
		multipartResolver.setMaxInMemorySize(20 * 1024 * 1024);
		return multipartResolver;
	}


	//j-session 삭제
	@Bean
	public ServletContextInitializer clearJsession() {
		return new ServletContextInitializer() {
			@Override
			public void onStartup(ServletContext servletContext) throws ServletException {
				servletContext.setSessionTrackingModes(Collections.singleton(SessionTrackingMode.COOKIE));
				SessionCookieConfig sessionCookieConfig=servletContext.getSessionCookieConfig();
				sessionCookieConfig.setHttpOnly(true);
			}
		};
	}
}