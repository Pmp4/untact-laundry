<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags/layouts/user" %>

<t:wrapper>
<script type="text/javascript">
	$(function(){
		$("#startDay").datepicker({
			dateFormat:'yy-mm-dd',
			changeYear:true,
			dayNamesMin:['일','월','화','수','목','금','토'],
			monthNames:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
		});
		$("#endDay").datepicker({
			dateFormat:'yy-mm-dd',
			changeYear:true,
			dayNamesMin:['일','월','화','수','목','금','토'],
			monthNames:['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월']
		});
	});
	$(function(){
		$('#btMonth1').click(function(){
        	$.setDate(1, 'M');	
        });
        
        $('#btMonth3').click(function(){
        	$.setDate(3, 'M');
        });
        
        $('#btMonth6').click(function(){
        	$.setDate(6, 'M');
        });
        $.setDate = function(term, type){
    		
    		var str=$('#endDay').val().split('-');
    		var d = new Date(str[0], str[1]-1, str[2]);
    		if(type=="D"){
    			d.setDate(d.getDate()-term);	
    		}else if(type=='M'){
    			d.setMonth(d.getMonth()-term);
    		}
    		
    		$('#startDay').val($.findDate(d));
    	}	
    	
    	$.findDate = function(date){
    	     return date.getFullYear()+"-" + $.formatDate(date.getMonth()+1) +"-"
             	+ $.formatDate(date.getDate());
       	}
       
    	$.formatDate = function(d){
    		if(d<10) 
    			d="0" + d;
    		
    		return d;
    	}
	});
</script>
<style>
.paymentdetails_wrap {
	margin: 0 auto;
	width: 1200px;
}

.paymentdetails_top {
	width: 100%;
	height: 150px;
}

.paymentdetails_title {
	width: 1000px;
	font-size: 30px;
	font-weight: bold;
	margin-bottom: 80px;
}

.paymentdetails_date {
	width: 1200px;
	margin: 0 auto;
	margin-bottom: 30px;
	margin-left: 45px;
}



.paymentdetails_amountPayment {
	text-align: right;
	font-size: 20px;
}

.paymentdetails_amountPayment span {
	font-weight: bold;
}

.paymentdetails_back {
	text-align: center;
}

.paymentdetails_date a:visited {
	color: black;
	text-decoration: none;
}

.paymentdetails_date a:link {
	color: black;
	text-decoration: none;
}

.paymentdetails_container {
	max-width: 1200px;
	margin-left: auto;
	margin-right: auto;
	padding-left: 10px;
	padding-right: 10px;
	margin-bottom: 70px;
}

.paymentdetails_table li {
	border-radius: 3px;
	padding: 5px 30px;
	display: flex;
	justify-content: space-between;
	margin-bottom: 10px;
}

.paymentdetails_table-header {
	background-color: #045FB4;
	font-size: 17px;
	font-weight: bold;
	text-transform: uppercase;
	letter-spacing: 0.03em;
	color: white;
	text-align: center;
}

.paymentdetails_table-row {
	background-color: #ffffff;
	box-shadow: 0px 0px 9px 0px rgba(0, 0, 0, 0.1);
	font-size: 15px;
	font-weight: bold;
	text-align: center;
}

.paymentdetails_col-1 {
	flex-basis: 15%;
}

.paymentdetails_col-2 {
	flex-basis: 40%;
}

.paymentdetails_col-3 {
	flex-basis: 10%;
}

.paymentdetails_col-4 {
	flex-basis: 15%;
}

.paymentdetails_col-5 {
	flex-basis: 10%;
}

a {
	display: block;
}
</style>
	<div class="paymentdetails_wrap">
		<div class="paymentdetails_top"></div>
		<div class="paymentdetails_title">
			<p>결제 내역</p>
		</div>
		<div class="paymentdetails_date">
			<form name="frm1" method="post" action="<c:url value=''/>">
				<input type="button" value="1개월" class="btn btn-outline-dark" id="btMonth1">
				<input type="button" value="3개월" class="btn btn-outline-dark" id="btMonth3">
				<input type="button" value="6개월" class="btn btn-outline-dark" id="btMonth6">
				<br> <br> <input type="text" name="startDay" id="startDay"
					value="${dateSearchVO.startDay }"> ~ <input type="text"
					name="endDay" id="endDay" value="${dateSearchVO.endDay }">
				<input type="submit" id="" value="조회">
			</form>
		</div>
		<div class="paymentdetails_container">
			<ul class="paymentdetails_table">
				<li class="paymentdetails_table-header">
					<div class="paymentdetails_col-1">주문코드</div>
					<div class="paymentdetails_col-2">상품명</div>
					<div class="paymentdetails_col-3">가격</div>
					<div class="paymentdetails_col-4">주문일</div>
					<div class="paymentdetails_col-5">상태</div>
				</li>
				<li class="paymentdetails_table-row">
					<div class="paymentdetails_col-1" data-label="주문코드">00001</div>
					<div class="paymentdetails_col-2" data-label="상품명">
						<a href="/launer/mypage/detailedPaymentHistory">신발외 5건</a>
					</div>
					<div class="paymentdetails_col-3" data-label="가격">5000원</div>
					<div class="paymentdetails_col-4" data-label="주문일">2022-06-18</div>
					<div class="paymentdetails_col-5" data-label="상태">배송중</div>
				</li>
				<li class="paymentdetails_table-row">
					<div class="paymentdetails_col-1" data-label="주문코드">00002</div>
					<div class="paymentdetails_col-2" data-label="상품명">청바지외 5건</div>
					<div class="paymentdetails_col-3" data-label="가격">15000원</div>
					<div class="paymentdetails_col-4" data-label="주문일">2022-06-18</div>
					<div class="paymentdetails_col-5" data-label="상태">배송완료</div>
				</li>
				<li class="paymentdetails_table-row">
					<div class="paymentdetails_col-1" data-label="주문코드">00003</div>
					<div class="paymentdetails_col-2" data-label="상품명">신발외 5건</div>
					<div class="paymentdetails_col-3" data-label="가격">5000원</div>
					<div class="paymentdetails_col-4" data-label="주문일">2022-06-18</div>
					<div class="paymentdetails_col-5" data-label="상태">배송중</div>
				</li>
				<li class="paymentdetails_table-row">
					<div class="paymentdetails_col-1" data-label="주문코드">00004</div>
					<div class="paymentdetails_col-2" data-label="상품명">신발외 5건</div>
					<div class="paymentdetails_col-3" data-label="가격">5000원</div>
					<div class="paymentdetails_col-4" data-label="주문일">2022-06-18</div>
					<div class="paymentdetails_col-5" data-label="상태">배송중</div>
				</li>
				<li class="paymentdetails_table-row">
					<div class="paymentdetails_col-1" data-label="주문코드">00005</div>
					<div class="paymentdetails_col-2" data-label="상품명">신발외 5건</div>
					<div class="paymentdetails_col-3" data-label="가격">45000원</div>
					<div class="paymentdetails_col-4" data-label="주문일">2022-06-18</div>
					<div class="paymentdetails_col-5" data-label="상태">결제완료</div>
				</li>

			</ul>
		</div>

		<div class="paymentdetails_amountPayment">
			<p>
				총 결제 금액 <span>1500</span>원
			</p>
		</div>
		<div class="paymentdetails_back">
			<button type="button" class="btn btn-dark"
				onclick="location.href='/launer/mypage/mypage'">이전</button>
		</div>
	</div>
</t:wrapper>