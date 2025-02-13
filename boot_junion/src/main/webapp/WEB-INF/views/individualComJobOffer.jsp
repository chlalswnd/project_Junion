<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title> 공고관리 지원자 목록페이지 </title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/default.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/jobpostingSupport2.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/line-awesome/1.3.0/line-awesome/css/line-awesome.min.css">
<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.8/dist/web/variable/pretendardvariable.css"/>
<script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"></script>
<style>
    /* 드롭다운 메뉴 */
    .dorpdowmMain {
        display: flex;
    }
    .dropdown {
        display: flex;
        align-items: center;
    }
    .dropdownSub {
        display: flex;
    }
    .dropdownContent {
        position: absolute;
        display: none;
        text-align: center;
        margin-top: 20px;
        width: 160px;
        background-color: var(--color-white);
        border-radius: 5px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        right: 11px;
    }
    .dropdownContent a {
        color: var(--color-black);
        padding: 12px;
        text-decoration: none;
        display: block;
        font-size: var(--color-black);
    }
    /* 필터 박스 스타일 */


    /* 데이터 없음 스타일 */
    .notfound {
        text-align: center;
        margin-top: 20px;
    }
    .notfoundhh {
        font-size: 16px;
        color: #888;
    }
</style>
<script>
    function fn_submit(){
        // form 요소 자체
        var formData = $("#frm").serialize();

        $.ajax({
            type: "post",
            data: formData,
            url: "jobpostingOffer",
            success: function(data){
                alert("저장완료");
                location.href = "jobpostingSupport";
            },
            error: function(){
                alert("오류발생");
            }
        });
    }

    function updateStatus(resumeNum) {
        var status = $("#statusFilter_" + resumeNum).val();

        $.ajax({
            type: 'POST',
            url: 'updateStatus', // 서버에서 상태를 업데이트할 URL
            data: {
                resume_num: resumeNum,
                status: status
            },
            success: function(response) {
                console.log('상태 업데이트 완료');
            },
            error: function() {
                alert('오류 발생');
            }
        });
    }

    $(document).ready(function() {
        $('.navMenu ul li').click(function(){
            $(this).addClass('active');
            $('.navMenu ul li').not(this).removeClass('active');
        });

        $('.cardConBottom > .title').each(function() {
            var length = 21; // 표시할 글자 수 정하기
            $(this).each(function() {
                if ($(this).text().length >= length) {
                    $(this).text($(this).text().substr(0, length) + '...'); // 지정한 글자수 이후 표시할 텍스트 '...'
                }
            });
        });

        $('.tabCon.All').click(function(){
            $('.cardConWrap').css({"display":"none"});
            $('.cardConWrap.All').css({"display":"flex"});
        });

        $('.tabCon.proposal').click(function(){
            $('.cardConWrap').css({"display":"none"});
            $('.cardConWrap.proposal').css({"display":"flex"});
        });

        $('.tabCon.post').click(function(){
            $('.cardConWrap').css({"display":"none"});
            $('.cardConWrap.post').css({"display":"flex"});
        });

        $(".right .btn").on("click",function(e){
            $(this).parents().siblings(".popUp").css({"display":"flex"});
        });     

        $(".popUp .icon.cancel").click(function(){
            console.log("click");
            $(this).parents(".popUp").css({"display":"none"}); 
        });
    });

    function dropdown() {
        let click = document.getElementById("dropdownContent");
        let iconDown = document.getElementById("iconDown");
        let iconUp = document.getElementById("iconUp");

        if (click.style.display === "none" || click.style.display === "") {
            click.style.display = "block";
            iconDown.style.display = "none";
            iconUp.style.display = "block";
        } else {
            click.style.display = "none";
            iconDown.style.display = "block";
            iconUp.style.display = "none";
        }
    }
    document.getElementById("dropdownSub").addEventListener("click", dropdown); // 드롭다운 메뉴 끝
</script>
</head>
<body>
<div class="container">
    <%@ include file="nav_company.jsp" %>
    <%@ include file="quickMenu.jsp" %>
    <div class="mainContent">
        <header>
            <div class="userWrapper">
                <img src="images/people.svg" alt="">
                <div class="dorpdowmMain">
                    <div class="dropdown">
                        <div class="dropdownSub" id="dropdownSub">
                            <h4 class="name" name="com_name" style="cursor: pointer;">${login_name}</h4>
                            <div class="dropdownContent" id="dropdownContent">
                                <a href="#"><div>기업 정보 관리</div></a>
                                <a href="logout"><div>로그아웃</div></a>
                            </div> <!-- dropdownContent 끝-->
                            <span class="icon">
                                <i id="iconDown" class="fa-solid fa-caret-down" style="display: block; cursor: pointer;"></i>
                                <i id="iconUp" class="fa-solid fa-caret-up" style="display: none; cursor: pointer;"></i>
                            </span>
                        </div> <!-- dropdownSub 끝-->
                    </div> <!-- dropdown 끝-->
                </div><!-- dropdownMain 끝-->
             </div>
        </header>    
        <!-- ============ 본문 시작 =============-->
        <main>
            <div class="containe">
                <div class="toptitle">
                    <!-- 쿼리 파라미터로 받은 notice_title 표시하기 -->
					<c:if test="${not empty jobpostingSupport}">

					    <h3 class="toptitlehh">인재풀 제안 관리</h3>
					</c:if>
                    <!-- 반복문 시작 -->
                    <c:choose>
                        <c:when test="${not empty jobpostingSupport}">
                            <c:forEach items="${jobpostingSupport}" var="sup">
                                <div class="box" data-birth="${sup.calculated_age}" data-resume-num="${sup.resume_num}">
                                    <div class="left">
										<div class="le">

											<div class="uploadResult">
	                                            <ul>

	                                            </ul>
	                                        </div>
	                                        <div id="pfname_${sup.resume_num}" class="pfname" onclick="handleClick(${sup.resume_num}, ${sup.notice_num})">${sup.user_name}</div>
	                                        <div class="pfage">${sup.user_gender}</div>
	                                        <div class="pfage">${sup.calculated_age}세</div>
	                                        <div class="ppfage">${sup.notice_career}</div>
										</div>
                                        <div class="pfEntry">${sup.career_month}</div>
                                        <div class="pfEntry">${sup.notice_title}</div>

                                    </div>
									<!-- 필터 박스 추가 -->
									<div class="filterBox">
										<h5 class="ofof">${sup.offer_date}</h5>
										<h5 class="ofofof">${sup.offer_agree}</h5>
									</div>
                                    <div class=pname>
                                        ${sup.submit_check}
                                    </div>
                                   
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="notfound">
                                <h5 class="notfoundhh">
                                    제안이 아직 없습니다.${individualCom}
                                </h5>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <!-- 반복문 끝 -->
                </div> <!-- contain끝 -->
            </div>
        </main>
        <!-- ============ 본문 끝 =============-->
    </div> <!-- //main-content -->
</div>    
<footer>
    <div class="footerInner">
        <div class="left_conWrap f_conWrap">
            <h5 class="logo">
                <a href="#">
                    <img src="images/logo.svg" alt="#">
                </a>
            </h5>
            <p class="textWrap">
                부산광역시 부산진구 중앙대로 688 한준빌딩 2층<br>
                대표이사 : 주니온<br>
                사업자등록번호 : 123-45-67890 / 통신판매업신고 : 9999-12345호<br>
                이메일 : abcde@naver.com
            </p>
        </div>
        <div class="right_conWrap f_conWrap">
            <h3>1234-5678</h3>
            <p class="textWrap">                        
                오전 9시 ~ 오후 6시(토요일, 공휴일 휴무)<br>
                Copyright ⓒ JUNION ALL RIGHTS RESERVED.
            </p>
        </div>
    </div>
</footer>
</body>
</html>


<!-- ------------------------------------------- 스크립트 시작 ------------------------------->
<script>
	
	
	function handleClick(resumeNum, noticeNum) {
	    const pfnameDiv = document.getElementById('pfname_' + resumeNum);

	    // 상태를 '열람'으로 업데이트
	    $.ajax({
	        type: 'POST',
	        url: '${pageContext.request.contextPath}/updateSubmitCheck', // 서버에서 상태를 업데이트할 URL
	        data: {
	            resume_num: resumeNum,
	            notice_num: noticeNum,
	            status: '열람'
	        },
	        success: function(response) {
	            if (response === '상태 업데이트 성공') {
	                pfnameDiv.classList.add('clicked'); // 클릭 상태 기록
	                location.href = 'resumeInfo2?resumeNum=' + resumeNum; // 페이지 이동
	            } else {
	                console.error('상태 업데이트 실패');
	            }
	        },
	        error: function(xhr, status, error) {
	            console.error('상태 업데이트 오류:', error);
	        }
	    });
	}
	
	
	function updateStatus(resumeNum, noticeNum) {
	    var updateStatus = $('#statusFilter_' + resumeNum).val();

	    $.ajax({
	        type: 'POST',
	        url: '${pageContext.request.contextPath}/updateStatus',
	        data: {
	            resume_num: resumeNum,
	            notice_num: noticeNum,
	            updateStatus: updateStatus
	        },
	        success: function(response) {
	            alert('변경되었습니다'); // 변경 메시지 팝업
	        },
	        error: function(xhr, updateStatus, error) {
	            console.error('상태 업데이트 오류:', error);
	        }
	    });
	}

	
	
	
	$(document).ready(function()
	{
	    /*
	        2024-06-25 이재원 
	        메뉴 눌렀을 때 메뉴 활성화 : active
	    */
	    $('.navMenu ul li').click(function(){
	        $(this).addClass('active');
	        $('.navMenu ul li').not(this).removeClass('active');
	    });

	    
	    /*
	        2024-06-25 이재원 
	        글자수 제한 + 넘는건 ...처리
	    */
	    $('.cardConBottom > .title').each(function()
	    {
	        var length = 21; //표시할 글자 수 정하기
	    
	        $(this).each(function()
	        {

	            if($(this).text().length >= length)
	            {
	                $(this).text($(this).text().substr(0, length) + '...');	//지정한 글자수 이후 표시할 텍스트 '...'
	            }
	        });

	    });

	    /*
	        2024-06-25 이재원 
	        탭 메뉴 : 전체 , 포지션 제안, 관심기업
	    */

	    $('.tabCon.All').click(function(){
	        $('.cardConWrap').css({"display":"none"});
	        $('.cardConWrap.All').css({"display":"flex"});
	    });

	    $('.tabCon.proposal').click(function(){
	        $('.cardConWrap').css({"display":"none"});
	        $('.cardConWrap.proposal').css({"display":"flex"});
	    });

	    $('.tabCon.post').click(function(){
	        $('.cardConWrap').css({"display":"none"});
	        $('.cardConWrap.post').css({"display":"flex"});
	    });



	    // popup 
	    $(".right .btn").on("click",function(e){
	        $(this).parents().siblings(".popUp").css({"display":"flex"});
	    });     

	    $(".popUp .icon.cancel").click(function(){
	        console.log("click");
	        $(this).parents(".popUp").css({"display":"none"}); 
	    }); 


		//파일 가져오기
		// box클래스 반복하면서 데이터 가져옴
		    $('.box').each(function () {
		        // con클래스 data-notice-num 속성에서 값을 가져옴
		        var resumeNum = $(this).data('resume-num');
		        
		        // 현재 con클래스 .uploadResult 요소를 선택
		        var uploadResultContainer = $(this).find('.uploadResult ul');

		        if (resumeNum) {
		            $.ajax({
		                url: '/resumeGetFileList',
		                type: 'GET',
		                data: { resume_num: resumeNum },
		                dataType: 'json',
		                success: function(data) {
		                    showUploadResult(data, uploadResultContainer);
		                },
		                error: function(xhr, status, error) {
		                    console.error('Error fetching file list for notice_num ' + noticeNum + ':', error);
		                }
		            });
		        } 
		    });
	});
	    
	function showUploadResult(uploadResultArr, uploadResultContainer){
	    if (!uploadResultArr || uploadResultArr.length == 0) {
	        return;
	    }

	    var str = "";

	    $(uploadResultArr).each(function (i, obj) {
	        var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);

	        str += "<li data-path='" + obj.uploadPath + "'";
	        str += " data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'>";
	        str += "<div>";
	        str += "<span style='display:none;'>" + obj.fileName + "</span>";
	        str += "<img src='/resumeDisplay?fileName=" + fileCallPath + "' alt='" + obj.fileName + "'>"; 
	        str += "</div></li>";
	    });

	    uploadResultContainer.empty().append(str);
	}    
	    


	
</script>
<script>
    // 드롭다운 메뉴 (하지수)

    function dropdown() {
        let click = document.getElementById("dropdownContent");
        let iconDown = document.getElementById("iconDown");
        let iconUp = document.getElementById("iconUp");

        if (click.style.display === "none" || click.style.display === "") {
            click.style.display = "block";
            iconDown.style.display = "none";
            iconUp.style.display = "block";
        } else {
            click.style.display = "none";
            iconDown.style.display = "block";
            iconUp.style.display = "none";
        }
    }
    document.getElementById("dropdownSub").addEventListener("click", dropdown); // 드롭다운 메뉴 끝
</script>