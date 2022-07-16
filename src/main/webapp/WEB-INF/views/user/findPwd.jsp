<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags/layouts/user" %>

<t:wrapper>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div id="findIdPwd_wrap">
	<div class="findIdPwdsubWrap">
		<div class="titleArea">
			<h2>비밀번호 찾기</h2>
			<ul>
				<li>본인 이름과 가입하실때 입력한 전화번호, 이메일 주소를 입력하시면</li>
	        	<li>이메일로 임시 비밀 번호가 발송됩니다.</li>
    		</ul>
		</div>
		<form name="findPwdfrm" method="post" 
			action="<c:url value='/user/findPwd'/>">
				<div class="findIdPwdfrm_Wrap">
					<div id="findIdPwdbox">
			            <p class="memberType"><strong>회원유형</strong>
			            	<select id="searchType" name="searchType">
								<option value=1 selected="selected">일반회원</option>
								<option value=2>배송 기사 회원</option>
							</select>
						</p>
						<p id="name_view" style=""><strong id="name_lable">이름</strong>
							<input id="name" name="name" type="text">
						</p>
						<p id="mobile_view"><strong>휴대폰 번호</strong> 
							<input type="text" name="hp" id="hp" maxlength="11" 
								placeholder="-를 제외하고 입력해주세요">
						</p>
						<p id="email_view" style=""><strong id="email_lable">이메일 주소</strong>
							<input id="email" name="email" type="text">
						</p>
						<div class="findIdPwdBtnWrap">
                			<button class="findIdPwdBtn" id="findPwdBtn">확인</button>
            			</div>
					</div>
				</div>
		</form>
	</div>
</div>
</t:wrapper>