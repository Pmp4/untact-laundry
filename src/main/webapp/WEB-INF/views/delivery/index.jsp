<%--
  Created by IntelliJ IDEA.
  User: p__mp4
  Date: 2022/06/13
  Time: 10:01 PMs| Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags/layouts/delivery" %>
<t:wrapper>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <div id="delivery-main" class="main-width">
        <script src="<c:url value="/delivery/js/main.js"/>"></script>
        <div id="map"></div>
        <script>
            //지도 관련
            //지도 관련
            //지도 관련
            //지도 관련
            //지도 관련
            //지도 관련
            const defaultY = ${officeVO.latY};
            const defaultX = ${officeVO.lonX};

            const defaultPoint = new kakao.maps.LatLng(defaultY, defaultX);

            let map;


            //map 생성
            //map 생성
            //map 생성
            //map 생성
            function createMap() {
                let mapContainer = document.getElementById('map'), // 지도를 표시할 div
                    mapOption = {
                        center: defaultPoint, // 지도의 중심좌표
                        level: 5 // 지도의 확대 레벨
                    };
                // 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
                map = new kakao.maps.Map(mapContainer, mapOption);


                const polygonPath = [
                    <c:set var = "c" value="0"/>
                    <c:forEach var="i" items="${polygon}">
                    <c:set var = "c" value="${c + 1}"/>
                    new kakao.maps.LatLng(${i[0]}, ${i[1]})
                    <c:if test="${fn:length(polygon) != c}">, </c:if>
                    </c:forEach>
                ];

                // 지도에 표시할 다각형을 생성합니다
                const polygon = new kakao.maps.Polygon({
                    path: polygonPath, // 그려질 다각형의 좌표 배열입니다
                    strokeWeight: 3, // 선의 두께입니다
                    strokeColor: '#39DE2A', // 선의 색깔입니다
                    strokeOpacity: 0.8, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
                    strokeStyle: 'solid', // 선의 스타일입니다
                    fillColor: '#A2FF99', // 채우기 색깔입니다
                    fillOpacity: 0.2 // 채우기 불투명도 입니다
                });
                console.log(polygon.strokeStyle);

                // 지도에 다각형을 표시합니다
                polygon.setMap(map);
            }


            window.onload = function () {
                curUpdate();
                createMap();
                listEvent();
                slideTog();
            }

            //위치 초기화
            //위치 초기화
            //위치 초기화
            //위치 초기화
            function panTo(dP) {
                map.panTo(dP);
            }

            //지도 관련
            //지도 관련
            //지도 관련
            //지도 관련
            //지도 관련


            //지도 마커 관련
            //지도 마커 관련
            //지도 마커 관련
            //지도 마커 관련
            const basicImageSrc = 'http://localhost:9095/launer/images/basic_marker.png'; // 마커이미지의 주소입니다
            const clickImageSrc = 'http://localhost:9095/launer/images/click_marker.png';
            const imageSize = new kakao.maps.Size(40, 40);     // 마커이미지의 크기입니다.


            const markerImage = new kakao.maps.MarkerImage(basicImageSrc, imageSize);
            const clickImage = new kakao.maps.MarkerImage(clickImageSrc, imageSize);

            function markerFor(positions) {      //이게 맞나?
                // 지도 위에 마커를 표시합니다
                for (let i = 0, len = positions.length; i < len; i++) {
                    addMarker(positions[i], i);
                }
            }

            function addMarker(position, index) {
                var marker = new kakao.maps.Marker({
                    map: map,
                    position: position,
                    image: markerImage
                });

                // 마커에 click 이벤트를 등록합니다
                kakao.maps.event.addListener(marker, 'click', function () {
                    if (!selectedMarker || selectedMarker !== marker) {
                        // 클릭된 마커 객체가 null이 아니면
                        // 클릭된 마커의 이미지를 기본 이미지로 변경하고
                        !!selectedMarker && selectedMarker.setImage(markerImage);
                        // 현재 클릭된 마커의 이미지는 클릭 이미지로 변경합니다
                        marker.setImage(clickImage);

                        let orderData = positionDataNo[index].orderNo;
                        console.log(orderData);

                        //orderList에서 orderNo를 찾음
                        let inputFind = $("#order-scroll-box input[value=" + orderData + "]").parent().parent().parent();
                        // let paddT = (inputFind.innerHeight() - inputFind.height()) / 2;
                        console.log(inputFind);


                        const $listPart = $("#list-part");
                        const $mapPart = $("#map");

                        if (!$listPart.hasClass("active")) {
                            $listPart.removeClass("non-active");
                            $listPart.addClass("active");
                            resizeMap("active");
                        }


                        $("#orders-list").animate({
                            scrollTop: inputFind.position().top
                        }, 300, () => {
                            let i = 0;
                            inputFind.toggleClass("marker-focus");
                            const markerListEvent = setInterval(() => {
                                if (i < 3) {
                                    inputFind.toggleClass("marker-focus");
                                    i++;
                                } else {
                                    clearInterval(markerListEvent);
                                }
                            }, 280);
                        });
                        // $findList.css("background", "red");
                    }

                    panTo(position);
                    // 클릭된 마커를 현재 클릭된 마커 객체로 설정합니다
                    selectedMarker = marker;
                });
            }

            // MakrerImage 객체를 생성하여 반환하는 함수입니다
            function createMarkerImage(markerSize, offset, spriteOrigin) {
                var markerImage = new kakao.maps.MarkerImage(
                    SPRITE_MARKER_URL, // 스프라이트 마커 이미지 URL
                    markerSize, // 마커의 크기
                    {
                        offset: offset, // 마커 이미지에서의 기준 좌표
                        spriteOrigin: spriteOrigin, // 스트라이프 이미지 중 사용할 영역의 좌상단 좌표
                        spriteSize: spriteImageSize // 스프라이트 이미지의 크기
                    }
                );

                return markerImage;
            }

            let positions = []; // 마커의 위치
            let positionDataNo = [];    //마커에 대한 orderNO (객체로 넣으면 고쳐야할 부분이 많아져 변수로 따로 지정)
            let selectedMarker = null; // 클릭한 마커를 담을 변수
            let bounds;

            function setBounds() {
                map.setBounds(bounds);
            }

            //지도 마커 관련
            //지도 마커 관련
            //지도 마커 관련


            //전부 초기화하는 함수
            function cleanList() {
                $("#order-scroll-box").html("");
                positions = [];
                positionDataNo = [];
                totalPage = 0;
                currentPage = 0;
                dbCur = 0;

                createMap();
                curUpdate();
                // slideTog();
                // listEvent();
            }


            let currentPage = 0;
            let dbCur = 0;
            let totalPage = 0;   //마지막 페이지
            let groupNo = 1;    //수거 : 1, 배송 : 2
            let totalRecord = 0;

            //currentPage 변수와 input value 업데이트 해주는 함수
            function curUpdate() {
                currentPage++;
                $("#paging-form input[name=currentPage]").val(currentPage);
                console.log("현재페이지 증감 : currentPage++ = " + currentPage);
                viewList(groupNo);
                // scCnt = 0;
            }

            function viewList(group) {
                const formSet = $("#paging-form");
                if (group === 1) {
                    formSet.find("input[name=orderStatusNo]").val(1);
                    formSet.find("input[name=listType]").val("PICKUP_DRIVER");
                } else if (group === 2) {
                    formSet.find("input[name=orderStatusNo]").val(4);
                    formSet.find("input[name=listType]").val("DELIVERY_DRIVER");
                }

                let listData = formSet.serialize();
                $.ajax({
                    url: "<c:url value='/delivery/list'/>",
                    method: "POST",
                    data: listData,
                    dataType: "JSON",
                    success: (res) => {
                        let listElement = "";

                        dbCur = res.dbCur;
                        totalPage = res.totalPage;
                        totalRecord = res.totalRecord;

                        console.log("dbCur = " + dbCur);
                        console.log("currentPage = " + currentPage);
                        console.log("totalPage = " + totalPage);
                        console.log("totalRecord = " + totalRecord);

                        $(".total-recode strong").text(totalRecord);

                        if (Array.isArray(res.listMap) && res.listMap.length === 0) {
                            panTo(defaultPoint);
                            listElement += "<h1 style='text-align: center; padding: 20px 0;'>리스트가 없습니다.</h1>";
                        } else {
                            $.each(res.listMap, (idx, item) => {
                                console.log(item);
                                let titleStr = "";
                                for (let i = 0; i < item.orderDetails.length; i++) {
                                    titleStr += item.orderDetails[i].CATEGORY_NAME;
                                    if (i !== item.orderDetails.length - 1) titleStr += ", ";
                                }
                                let pay = (item.orderOfficeView.TOTAL_PRICE / 100) * 10;

                                const textType = groupNo === 1 ? "수거하기" : "배송하기";

                                listElement +=
                                    "<div class='order-box' onclick='markerPositon(" + item.orderOfficeView.LON_X + ", " + item.orderOfficeView.LAT_Y + ")'>" +
                                    "<div class='timer-box'></div>" +
                                    "<h3>" + (titleStr.length > 25 ? titleStr.substring(0, 27) + "..." : titleStr) + "</h3>" +
                                    "<div class='order-text-box clearfix'>" +
                                    "<div class='left'>" +
                                    "<div class='order-text-list'>" +
                                    "<p>신청자 <strong>" +
                                    (item.orderOfficeView.NAME.length > 7 ?
                                        (item.orderOfficeView.NAME).substring(0, 7) + "..." :
                                        item.orderOfficeView.NAME) +
                                    "</strong></p>" +
                                    "<p>수량 <strong>" + item.orderOfficeView.SUM + "</strong></p>" +
                                    "<p>수당 <strong>" + pay.toLocaleString('ko-KR') + " 원</strong></p>" +
                                    "</div>" +
                                    "<div class='order-text-list'>" +
                                    "<p>위치 <strong>" + item.orderOfficeView.ADDRESS + "</strong></p>" +
                                    "</div>" +
                                    "</div>" +
                                    "<div class='right'>" +
                                    "<button onclick='addList(1," + item.orderOfficeView.NO + ", this)'>" + textType + "</button>" +
                                    "<input type='hidden' value='" + item.orderOfficeView.NO + "'/>" +
                                    "</div>" +
                                    "</div>" +
                                    "</div>";

                                /*let testEle = [
                                    new kakao.maps.LatLng(item.orderOfficeView.LON_X, item.orderOfficeView.LAT_Y),
                                    {orderNo : item.orderOfficeView.NO}
                                ];*/
                                // console.log(testEle);
                                positions.push(new kakao.maps.LatLng(item.orderOfficeView.LON_X, item.orderOfficeView.LAT_Y));
                                positionDataNo.push({orderNo: item.orderOfficeView.NO});
                            });
                            console.log(positions);
                            markerFor(positions);
                            bounds = new kakao.maps.LatLngBounds();
                            for (let i = 0; i < positions.length; i++) bounds.extend(positions[i]);
                            panTo(bounds);
                        }

                        $("#order-scroll-box").append(listElement);
                        scCnt = 0;
                    },
                    error: (xhr, status, error) => {
                        alert("error : " + error);
                    }
                });
            }

            let scCnt = 0;

            //탭, 리스트 관련 함수
            function listEvent() {
                //스크롤 끝일 때 이벤트 호출
                //스크롤 끝일 때 이벤트 호출
                //스크롤 끝일 때 이벤트 호출
                //스크롤 끝일 때 이벤트 호출
                document.getElementById("orders-list").addEventListener("wheel", () => {
                    let scrollBody = $("#orders-list");
                    //console.log(Math.floor(scrollBody[0].scrollHeight - scrollBody.scrollTop()) +", " + scrollBody.outerHeight());

                    if (Math.floor(scrollBody[0].scrollHeight - scrollBody.scrollTop()) <= scrollBody.outerHeight()) {
                        if (scCnt === 0) {
                            console.log(++scCnt);
                            /*console.log(Math.floor(scrollBody[0].scrollHeight - scrollBody.scrollTop()));
                            console.log(scrollBody.outerHeight());*/
                            if (currentPage <= totalPage && totalPage !== 0) {
                                console.log("리스트 업데이트, totalPage= " + totalPage + ", currentPage=" + currentPage);
                                curUpdate();
                            }
                        }
                    }
                })
                /*$("#orders-list").scroll(() => {
                    let scrollBody = $("#orders-list");
                    //console.log(Math.floor(scrollBody[0].scrollHeight - scrollBody.scrollTop()) +", " + scrollBody.outerHeight());
                    if(Math.floor(scrollBody[0].scrollHeight - scrollBody.scrollTop()) <= scrollBody.outerHeight()) {
                        if(currentPage <= totalPage && totalPage !== 0) {
                            console.log("리스트 업데이트, totalPage= "+ totalPage + ", currentPage=" + currentPage);
                            curUpdate();
                        }
                    }
                });*/

                //탭 클릭 시 리스트 전환
                //탭 클릭 시 리스트 전환
                //탭 클릭 시 리스트 전환
                //탭 클릭 시 리스트 전환
                $("#order-tab-box div").click((e) => {
                    let $tabElement = $(e.target);
                    let $groupText = $tabElement.text();
                    console.log($groupText);
                    //수거 : 1, 배송 : 2

                    if ($tabElement.hasClass("on")) {
                        $("#orders-list").animate({
                            scrollTop: 0
                        }, 200, "swing");
                    } else {
                        $("#order-tab-box div").removeClass("on");
                        $tabElement.addClass("on");
                        groupNo = $groupText === '수거' ? 1 : '배송' ? 2 : 0;
                        console.log("탭 타입 : " + groupNo);
                        cleanList();
                        // viewList(groupNo);
                    }
                });
            }

            function slideTog() {
                const $listPart = $("#list-part");
                const $mapPart = $("#map");

                $("#list-box").click(() => {
                    if ($listPart.hasClass("active")) {
                        $listPart.removeClass("active");
                        $listPart.addClass("non-active");
                        resizeMap("non-active");
                    } else {
                        $listPart.removeClass("non-active");
                        $listPart.addClass("active");
                        resizeMap("active");
                    }
                });
            }

            function resizeMap(chk) {
                var mapContainer = document.getElementById('map');

                if (chk === "active") {
                    mapContainer.style.height = '60%';
                } else {
                    mapContainer.style.height = '90%';
                }
                setTimeout(() => {
                    map.relayout();
                }, 600);
            }


            //리스트 클릭 시 해당 리스트의 마커로 모션이동
            function markerPositon(LAT_Y, LON_X) {
                let thisPoint = new kakao.maps.LatLng(LAT_Y, LON_X);
                panTo(thisPoint);
            }


            let countAdd = 0;

            function addList(chk, orderNo, element) {
                let thisElement = $(element);
                let thisParentElement = $(element).parent().parent().parent();
                let addListAttr;

                if (chk === 0) {
                    addListAttr = "addList(1, " + orderNo + ", this)";
                    thisElement.attr("onclick", addListAttr).toggleClass("on").text("수거하기");
                    thisParentElement.toggleClass("timer");
                    countAdd = 0;
                    clearTimeout(addSetTime);
                } else {
                    if (countAdd === 0) {
                        addListAttr = "addList(0, " + orderNo + ", this)";
                        thisElement.attr("onclick", addListAttr).toggleClass("on").text("취소");
                        thisParentElement.toggleClass("timer");
                        countAdd++;
                        setTimeAddList(orderNo, thisParentElement);
                    } else {
                        alert("진행중인 항목이 있습니다.");
                    }
                }
            }

            let addSetTime;

            function setTimeAddList(orderNo, element) {
                let thisGroupNo = groupNo;
                addSetTime = setTimeout(() => {
                    console.log(thisGroupNo);
                    $.ajax({
                        url: "<c:url value="/delivery/addList"/>",
                        data: {
                            groupNo: thisGroupNo,
                            orderNo: orderNo
                        },
                        type: "POST",
                        success: (res) => {
                            if (res === "추가 성공") {
                                element.animate({
                                    left: "200%"
                                }, 100, () => {
                                    setTimeout(() => {
                                        $(element).remove();
                                    }, 400);
                                });
                            } else {
                                alert(res);
                            }
                            countAdd = 0;
                        },
                        error: (xhr, status, error) => {
                            alert("error : " + error);
                        }
                    });
                }, 4000);
            }
        </script>
        <div class="zone-box">
            <h3><strong>${deliveryName}</strong> 기사님</h3>
            <p>
                <button onclick="panTo(defaultPoint)"><strong>${officeVO.officeName}</strong></button>
                <a href="<c:url value="/delivery/useredit"/>"><i class="fa-solid fa-gear"></i></a>
            </p>
        </div>
        <div class="total-recode">
            전체 <strong></strong> 건
        </div>
        <div id="list-part" class="main-width">
            <form id="paging-form">
                <input type="hidden" name="currentPage" value=""/>
                <input type="hidden" name="orderStatusNo" value=""/> <%--배송상태 : 수거전 1, 배송대기 4--%>
                <input type="hidden" name="listType" value=""/> <%--리스트 유형 : 픽업 PICKUP_DRIVER, 배송 DELIVERY_DRIVER--%>
            </form>
            <div id="list-box">
                <div class="line"></div>
            </div>
            <div id="order-tab-box">
                <div class="pickup-tab on">수거</div>
                <div class="delivery-tab">배송</div>
            </div>
            <div id="orders-list">
                <div id="order-scroll-box">
                        <%--<div class="order-box">
                            <h3>상품명</h3>
                            <div class="order-text-box">
                                <div class="left">
                                    <div class="order-text-list">
                                        <p>신청자 <strong>홍길동</strong></p>
                                        <p>위치 <strong>지역주소</strong></p>
                                    </div>
                                    <div class="order-text-list">
                                        <p>위치 <strong>서울시 금천구 시흥대로213길 123</strong></p>
                                    </div>
                                </div>
                                <div class="right">
                                    <button>수거하기</button>
                                </div>
                            </div>
                        </div>--%>
                </div>
            </div>
        </div>
    </div>
</t:wrapper>