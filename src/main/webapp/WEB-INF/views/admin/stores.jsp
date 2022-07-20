<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags/layouts/admin" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2105ed82df9c00048785f53fbd42044d&libraries=services"></script>

<t:head>
</t:head>
<t:wrapper>
<script type="text/javascript">

$(function () {
    $('form[name=officeAdd]').submit(function () {
        if ($("#officeName").val().length < 1) {
            alert("지점명을 입력하세요");
            $("#officeName").focus();
            return false;
        } else if ($("#address").val().length < 1) {
            alert("지점주소를 입력하세요");
            $("#address").focus();
            return false;
        }
    });
});


	function deleteOffice(no){
		if (!confirm("지점을 삭제 하시겠습니까?")){
			return
		}
		var url ='/launer/admin/stores/'+no
		// alert(url)
		$.ajax({
			url:url,
			type:'delete',
			date: {},
			dataType    : "html",
			success:function(data) {
				alert("삭제 성공");
				location.reload();
			},
			error: function(error){
				alert("삭제 실패");
				location.reload();
			}
		});
	}
	
	
	function execZipcode() {
	    new daum.Postcode({
	        oncomplete: function (data) {
	            var addr = '';
				
	            console.log(data)
	            if (data.userSelectedType === 'R') { // 도로명 주소
	                addr = data.roadAddress;
	            } else { // 지번주소
	                addr = data.jibunAddress;
	            }

	            document.getElementById("address").value = addr;
	            document.getElementById("address").focus();

	            coorSet(addr);
	        }

	    }).open();
	}
	
	function coorSet(addr) {
	    // 주소-좌표 변환 객체를 생성합니다
	    var geocoder = new kakao.maps.services.Geocoder();
	    // 주소로 좌표를 검색합니다
	    geocoder.addressSearch(addr, function (result, status) {
	        // 정상적으로 검색이 완료됐으면
	        if (status === kakao.maps.services.Status.OK) {
	            //document.querySelector("input[name=lonX]").value = result[0].y;
	            //document.querySelector("input[name=latY]").value = result[0].x;
	            document.querySelector("input[name=latY]").value = result[0].y;
	            document.querySelector("input[name=lonX]").value = result[0].x;
	            
	            markerSet(result[0].y,result[0].x);
	        }
	    });
	}
	
    function showPopUp() {
    	
    	//창 크기 지정
    	var width = 500;
    	var height = 500;
    	
    	//pc화면기준 가운데 정렬
    	var left = (window.screen.width / 2) - (width/2);
    	var top = (window.screen.height / 4);
    	
        	//윈도우 속성 지정
    	var windowStatus = 'width='+width+', height='+height+', left='+left+', top='+top+', scrollbars=yes, status=yes, resizable=yes, titlebar=yes';
    	
        //연결하고싶은url
        const url = "/admin/storesDetail/storesNo=${map['NO']}";

    	//등록된 url 및 window 속성 기준으로 팝업창을 연다.
    	window.open(url, "hello popup", windowStatus);
    }

	
	
	
    function markerSet(x, y) {
        
        let mapContainer = document.getElementById("map"), // 지도를 표시할 div
            mapOption = {
                center: new kakao.maps.LatLng(x, y), // 지도의 중심좌표
                level: 3 // 지도의 확대 레벨
            };
        // 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
        let map = new kakao.maps.Map(mapContainer, mapOption);

        // 마커가 표시될 위치입니다
        let markerPosition = new kakao.maps.LatLng(x, y);

        // 마커를 생성합니다
        let marker = new kakao.maps.Marker({
            position: markerPosition
        });

        // 마커가 지도 위에 표시되도록 설정합니다
        marker.setMap(map);
    }
      
</script>
<style>
.officeName {
    display: flex;
    align-items: center;
}

.modal-body div {
    margin-bottom: 15px;
}

.button-area {
    margin: auto;
}

.button-area {text-align: center;}

.officeAddress {
    display: flex;
    align-items: center;
}

label {
    width: 75px;
}
</style>
	<main>
		<div class="container-fluid px-4">
			<h1 class="mt-4">지점관리</h1>
			<ol class="breadcrumb mb-4">
				<li class="breadcrumb-item active">지점 등록 현황 및 지점 등록 삭제</li>
			</ol>
			<%-- <div class="card mb-4">
				<div class="card-body ">
					<div class="d-grid gap-2 d-md-flex justify-content-md-end">
						<form name="frmSearch" method="GET" action='<c:url value="/admin/stores"/>'>
							<input type="text" name="officeSearchKeyword" title="검색어 입력" value="${officeSearchKeyword}">
							<input type="button" value="지점조회">
						</form>
					</div>
				</div>
			</div> --%>
			<div class="card mb-4">
				<div class="card-header">지점 현황</div>
				<div class="card-body">
					<table class="table table-striped" id="orders">
						<colgroup>
							<col style="width: 10%">
							<col style="width: 15%">
							<col style="width: 36%">
							<col style="width: 19%">
							<%-- <col style="width: 12%"> --%>
							<col style="width: 12%">

						</colgroup>
						<thead>
							<tr>
								<th>지점번호</th>
								<th>지점명</th>
								<th>지점주소</th>
								<th>지점관리자</th>
								<%-- <th>상세정보</th> --%>
								<th>비고</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="map" items="${selectOfficeInfo }">
								<tr>
									<td>${map['NO']}</td>
									<td>${map['OFFICE_NAME']}</td>
									<td>${map['ADDRESS']}</td>
									<td>${map['USER_NAME']}</td>
									<%-- <td><a href="<c:url value="/admin/storesDetail?storesNo=${map['NO']}"/>"
											 onclick="">지점정보</a>
									</td> --%>
									<td><input type="button" value="삭제"
										onclick="deleteOffice(${map['NO']})"></td>
								</tr>

							</c:forEach>
						</tbody>

					</table>
					<div>
						<!-- 관리자 추가 모달 -->
						<!-- Modal -->
						<div class="modal fade create-office-modal" id="officeAdd"
							tabindex="-1" aria-labelledby="officeAddModalLabel"
							aria-hidden="true">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<h5 class="modal-title" id="officeAddModalLabel">지점 등록</h5>
										<button type="button" class="btn-close"
											data-bs-dismiss="modal" aria-label="Close"></button>
									</div>
									<div class="modal-body">
										<form name="officeAdd" id="officeAdd"
											action="<c:url value='/admin/insertOffice'/>" method="POST">
											<div class="officeName">
												<label for="officeName">지점명</label> <input type="text"
													name="officeName" id="officeName" style="ime-mode: active">
											</div>
											<div class="officeAddress">
												<label for="address">지점주소</label> <input type="text"
													name="address" id="address" style="width: 80%"
													value="${address}" onclick="execZipcode()"
													readonly="readonly"> <input type="hidden"
													name="latY" value="${latY}"> <input type="hidden"
													name="lonX" value="${lonX}">
											</div>
											<div class="map">
												<div id="map" style="height:400px"></div>
											</div>

											<div class="button-area">
												<input type="button" data-bs-dismiss="modal"  class = "btn btn-secondary" value="닫기">
												<input type="submit" id="office_submit" class="btn btn-dark" value="추가">
											</div>
								
										</form>
									</div>
								</div>
							</div>
						</div>
						<!-- Modal 끝 -->

						<input type="button"
							onclick=" setTimeout(() => {markerSet(39.032, 125.75);}, 300);"
							data-bs-toggle="modal" data-bs-target="#officeAdd" id="officeAdd"
							value="지점등록" class="btn btn-dark">
						<!-- 끝 -->
					</div>
				</div>
			</div>
		</div>
	</main>

	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.5/dist/umd/popper.min.js"
		integrity="sha384-Xe+8cL9oJa6tN/veChSP7q+mnSPaj5Bcu9mPX5F5xIGE0DVittaqT5lorf0EI7Vk"
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.min.js"
		integrity="sha384-kjU+l4N0Yf4ZOJErLsIcvOU2qSb74wXpOhqTvwVx3OElZRweTnQ6d31fXEoRD1Jy"
		crossorigin="anonymous"></script>

</t:wrapper>