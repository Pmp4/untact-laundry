<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="top.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style type="text/css">
.sb-sidenav-footer {
	position: absolute;
	bottom: 0;
	width: 225px;
}

#orders th, #orders td {
	text-align: center;
}

        #detail {}
        /* #detail h2 span.name {font-weight: bold; color: #000;} */
        #detail table {margin: 10px 0 30px 0;}
        #detail table tr td {height: 20px; padding: 5px; border-bottom: 1px solid #e6e6e6; font-size: 15px;}
        /* #detail .h2_2 {font-size: 14px; font-weight: bold; color:#85b8cf; text-indent: 10px;} */
        #detail table.view_2 {border-top: 3px solid #85b8cf; border-bottom: 3px solid #e6e6e6; width: 80%; margin: auto;}
        #detail table.view_2 td.title {background: #f3fcff; text-align: center; font-weight: bold; font-size: 20px;}
        #detail span.close {display: block; background: #eaeaea; text-align: center; font-weight: bold; cursor: pointer; padding: 5px;}

#pickUp {
	margin-top: 10px;
	float: right;
}
div.pickUp{
	margin: auto;
	height: 45px;
	width: 80%;
}

</style>

<!--
수거전
수거완료
세탁중
픽업대기
배송중
배송완료 
-->

<link rel="stylesheet" href="http://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script> 
<script type="text/javascript">
	
</script>

<div id="layoutSidenav_content">
	<main>
		<div class="container-fluid px-4">
			<h1 class="mt-4">주문상세</h1>
		
			<div style="width: 100%; height: 30px;'"></div>
			<div class="card mb-4">
				<div class="card-header">
					<i class="fas fa-table me-1"></i> 주문 상세 내역표
					
				</div>
				<div class="card-body">
				<div id="detail">	
				        <table class="view_2">
				        	<colgroup>
								<col style="width: 17%">
								<col style="width: 25%">
								<col style="width: 18%">
								<col style="width: 50%">

							</colgroup>
							<c:set var="vo" value="${vo}"></c:set>
							<c:set var="map" value="${vo.adminOrderDetailVo}"></c:set>
				            <tr>	<!-- 총 4열 -->
				                <td class="title">주문번호</td>
				                <td>${map.orderNo}</td>
				                <td class="title">주문자 아이디</td>
				                <td>${map.userEmail}</td>
				            </tr>
				            <tr>
				                <td class="title">주문상태</td>
				                <td>${map.status}</td>
				                <td class="title">주문자 주소</td>
				                <td>${map.address}</td>

				            </tr>
				            <tr>
				                <td class="title">담당지점</td>
				                <td>${map.officeName}</td>
				                <td class="title">신청시간</td>
				                <td>
				                	<fmt:formatDate value='${map.regdate}' pattern="yyyy-MM-dd HH:mm"/>
				                </td>
				            </tr>
				            <tr>
				                <td class="title">수거자</td>
				                <td>${map.pickupDriver}</td>
				                <td class="title">배송자</td>
				                <td>${map.deliveryDriver}</td>
				            </tr>
				            <tr>
				                <td class="title">주문상세</td>
				                <td colspan="3">
				                	<!-- 주문상세 반복 시작-->
				                	<c:set var="count" value="0"/>
				                	<c:set var="sum" value="0"/>
				                	<c:forEach var="listMap" items="${vo.adminOrderDetailList}">
				                		<span>${listMap['CATEGORYNAME']}</span> 
				                		<span>/ ${listMap['QUAN']}개</span> 
				                		<span>/ ${listMap['EAPRICE']}원(단위 당)</span>
				                		<c:set var="sum" value="${sum + listMap['EAPRICE']}"/>
				                		<c:set var="count" value="${count+1}"/>
				                		<c:if test="${fn:length(item) != count}">
				                		<br>
				                		</c:if>
				                		<!-- &nbsp; 2개 &nbsp; 8,000(건 당) -->
				                	</c:forEach>
				                	<!-- 주문상세 반복 끝-->
				                </td>
				            </tr>
				            <tr>
				                <td class="title">총 합계</td>
				                <td colspan="3">
				                	<fmt:formatNumber value="${sum}" pattern="#,###"/>원
				                </td>
				            </tr>
				            <tr>
				                <td class="title">결제번호</td>
				                <td>${map.paymentNo}</td>
				                <td class="title">결제시간</td>
				                <td>
				                	<fmt:formatDate value='${map.paymentDate}' pattern="yyyy-MM-dd HH:mm"/>
				                </td>
				            </tr>
				            <tr>
				                <td class="title">최종금액<br>(합계 + 과세금액)</td>
				                <td colspan="3">
				                	<fmt:formatNumber value="${sum}" pattern="#,###"/>원
				                </td>
				            </tr>

				        </table>
					<div class="pickUp">
						<input type="button" value="픽업대기 처리" id="pickUp" name="pickUp"
							disabled="disabled">
						<input type="button" value="픽업대기 처리" id="pickUp" name="pickUp"
							onclick="location.href='<c:url value="/admin/ordersUpdate?orderNo=${map.orderNo}"/>';">
					</div>
				</div>
							
				</div>
				
				
				
			</div>
			
		</div>
	</main>

	<%@ include file="bottom.jsp"%>