<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="basicFrame.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<style type="text/css">
    body {
        margin: 40px 10px;
        padding: 0;
        font-family: "Lucida Grande",Helvetica,Arial,Verdana,sans-serif;
        font-size: 14px;
    }

    #calendar {
        max-width: 900px;
         margin-right : 5%;
         height : 400px;
        width: 50%;
    }
    #friendCalendar{
       max-width: 900px;
       margin-left : 5%;
       width:50%;
    }
    .allCalendar{
    
   display: flex;
   
   }
     .mixCalendar {
        max-width: 900px;
        margin: 0 auto;
    }
    .content{
    background-color: white;
    }
    
    #Querie{
    background-color: #0d47a1;
    color: #ffffff;
    }
</style>

<!-- 캘린더 부분 -->
<link href='resources/calendar/fullcalendar.min.css' rel='stylesheet' />
<link href='resources/calendar/fullcalendar.print.min.css' rel='stylesheet' media='print' />
<script src='resources/lib/moment.min.js'></script>
<script src="resources/jquery-3.3.1.min.js"></script>
<script src='resources/calendar/fullcalendar.min.js'></script>

<!-- 각종 버튼들 -->
   <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
   <title>Components - Ready Bootstrap Dashboard</title>
   <meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0, shrink-to-fit=no' name='viewport' />
   <link rel="stylesheet" href="resources/assets/css/bootstrap.min.css">
   <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i">
   <link rel="stylesheet" href="resources/assets/css/ready.css">
   <link rel="stylesheet" href="resources/assets/css/demo.css">
   
   <script src="resources/assets/js/plugin/jquery-ui-1.12.1.custom/jquery-ui.min.js"></script>
   <script src="resources/assets/js/core/popper.min.js"></script>
   <script src="resources/assets/js/core/bootstrap.min.js"></script>
   <script src="resources/assets/js/plugin/chartist/chartist.min.js"></script>
   <script src="resources/assets/js/plugin/chartist/plugin/chartist-plugin-tooltip.min.js"></script>
   <script src="resources/assets/js/plugin/bootstrap-notify/bootstrap-notify.min.js"></script>
   <script src="resources/assets/js/plugin/bootstrap-toggle/bootstrap-toggle.min.js"></script>
   <script src="resources/assets/js/plugin/jquery-mapael/jquery.mapael.min.js"></script>
   <script src="resources/assets/js/plugin/jquery-mapael/maps/world_countries.min.js"></script>
   <script src="resources/assets/js/plugin/chart-circle/circles.min.js"></script>
   <script src="resources/assets/js/plugin/jquery-scrollbar/jquery.scrollbar.min.js"></script>
   <script src="resources/assets/js/ready.min.js"></script>
 <script type="text/javascript">
 
 $(document).ready(function() {
    
    
   $('#calendar').fullCalendar({
     header: {
       left: 'prev,next today',
       center: 'title',
       right: 'month,agendaWeek,agendaDay'
     },
     defaultDate: '2018-08-24',
     navLinks: true, // can click day/week names to navigate views
     selectable: true,
     selectHelper: true,
     select: function(start, end) {
       var title = prompt('스케줄 타이틀:');
       
        var content = prompt('스케줄 내용:'); 
       
       var eventData;
       if (title) {
         eventData = {
          
           title: title,
           content: content, 
           start: start,
           end: end
         };
         $('#calendar').fullCalendar('renderEvent', eventData, true); // stick? = true
       }
       $('#calendar').fullCalendar('unselect');
     },
     editable: true,
     eventLimit: true, // allow "more" link when too many events
     
     eventDragStop: function(event,jsEvent) {

          var trashEl = jQuery('#calendarTrash');
          var ofs = trashEl.offset();

          var x1 = ofs.left;
          var x2 = ofs.left + trashEl.outerWidth(true);
          var y1 = ofs.top;
          var y2 = ofs.top + trashEl.outerHeight(true);

          if (jsEvent.pageX >= x1 && jsEvent.pageX<= x2 &&
              jsEvent.pageY >= y1 && jsEvent.pageY <= y2) {
              var message = confirm("정말로 삭제하시겠습니까?");
              if(message == true){
                 
                 $('#calendar').fullCalendar('removeEvents', event._id);
              var el = $( "<div class='fc-event'>" ).appendTo( '#external-events-listing' ).text( event.title );
              
              el.draggable({
                 zIndex: 999,
                  revert: true,  
                  revertDuration: 0
                 
              });
              var a=$(this).attr('class');
              var b=parseInt(a.substring(57,a.length-13));
              var sendData={
                 'schNum':b   
              };
              //ajax 사용해서 db에서 지워주기
              $.ajax({
                 method:'post',
                 url:'deleteSchedule',
                 data:JSON.stringify(sendData),
                 dataType:'json',
                 contentType:'application/json; charset:utf-8',
                 suceess:function(r){
                    
                 }
              });
              /* code here */
              ///////////////////////
              
              alert('삭제성공!');
              }else
                 return false;
          }
         
      },
     
       
      //************************* 일정 입력란 *********************************
      //해당 스케줄을 모두 가져와서 for문으로 모두 입력시켜야 함  
  
     events: function(start, end ,timezone, callback) {
   $.ajax({
     method:'post',
     url: 'selectUserAllSchedule',
     
     success: function(doc) {
       var events = [];
       var resources=[];
       for ( var i in doc) {
          var update='';
        update=(doc[i].schEnddate).split('-');
        
        
        //31일 일때
        if(update[1]==1 && update[1]==3 && update[1]==5 && update[1]==7 && update[1]==8 && update[1]==10 && update[1]==12){
           if(parseInt(update[2])==31){
              update[1]=parseInt(update[1])+1;
              update[2]=1;
           }else{
              
           }
        }else{
           if(parseInt(update[0])%4==0 && update[0]==2){ //윤년
              if(parseInt(update[2]==29)){
                 update[1]=parseInt(update[1])+1;
                 update[2]=1;
              }else{
                 update[2]=parseInt(update[2])+1;
              }
           }else{
              if(update[2]==30){   //4,6,9,11 월
                 update[1]=parseInt(update[1])+1;
                 update[2]=1;
              }else{
                 update[2]=parseInt(update[2])+1;
              }
           }
        }
        doc[i].schEnddate=update[0]+'-'+update[1]+'-'+update[2];
        //중요도 색상 표시
        if(doc[i].importance==1){
           doc[i].importance='red';
        }else if(doc[i].importance==2){
           doc[i].importance='blue';
        }else if(doc[i].importance==3){
           doc[i].importance='green';
        }else if(doc[i].importance==4){
           doc[i].importance='yellow';
        }else if(doc[i].importance==5){
           doc[i].importance='black';
        }
     }
       
       $.each(doc,function() {
         events.push({
          
           title: $(this).attr('schTitle'),
           start: $(this).attr('schStartdate'), // will be parsed
           end:$(this).attr('schEnddate'),  
           
           color: $(this).attr('importance'),
          textColor: 'white' // an option!
          ,className : [$(this).attr('schNum')]      
         });        
       });        
       callback(events);      
     }
   });
 }        
      //****************************************************************
   });
 }); 
 
 </script>
<link rel="stylesheet" href="resources/jquery-ui.css">
<script src="resources/jquery-ui.js"></script>
<script src="resources/circle-progress.js"></script>
</head>
<body>
			<div class="main-panel">
				<div class="content">
					<div class="container-fluid">
						<div id="calendar">
						
						</div>
						</div>
						<div class="row row-card-no-pd">
							<div class="col-md-4">
								<div class="card">
									<div class="card-body">
										<p class="fw-bold mt-1">My Balance</p>
										<h4><b>$ 3,018</b></h4>
										<a href="#" class="btn btn-primary btn-full text-left mt-3 mb-3"><i class="la la-plus"></i> Add Balance</a>
						<div class="row">
							<div class="col-md-4">
								<div class="card">
									<div class="card-header todayDiv">
										<h4 class="card-title">오늘의 스케쥴</h4>
										<p class="card-category">소제목</p>
									</div>
									<div class="card-body today">
									</div>
									<div class="card-footer today">
									</div>
								</div>
							</div>
							<div class="col-md-4">
								<div class="card">
									<div class="card-header">
										<h4 class="card-title">내일의 스케쥴</h4>
										<p class="card-category">소제목</p>
									</div>
									<div class="card-body tomorrowList">
									</div>
									<div class="card-footer">
									</div>
								</div>
							</div>
								<div class="col-md-4" id="weatherDiv">  <!-- weather -->
							</div>
						</div>
						<br><br>
						</div> 
						<div class="row">
							<div class="col-md-10">
								<div class="card card-tasks">
									<div class="card-header ">
										<h4 class="card-title">プログレス</h4>
										<p class="card-category">スケジュール確認</p>
										<input id="relyInsert" type="button" value="検査">
									</div>
									<div class="card-body ">
									 <table class="table table-hover" border="1">
											<tr id="Querie">
												<th>完了チェック</th>
												<th>スケジュール名前</th>
												<th>ストーリー</th>
												<th>パーセント</th>
												<th>修整／削除</th>
											</tr>
											<c:if test="${empty replylist}">
											  <tbody id="result">
													<tr>
														<td colspan="5">-　検査をクリックしてください。<br>-　今日が含まれたスケジュールがありません。</td>
													</tr>
											</c:if>
									  </tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

<script>
 $(function(){
	geoFindMe();
}); 

!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src='https://weatherwidget.io/js/widget.min.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','weatherwidget-io-js');

/* geolocation api */
 function geoFindMe() {
	  if (!navigator.geolocation){
	    alert("<p>사용자의 브라우저는 지오로케이션을 지원하지 않습니다.</p>");
	    return;
	  }
	  
	  var options = {
		enableHighAccuracy : true
		, timeout : 5000
		, maximumAge : 0
	  };
	  
	  function success(position) {
 		var latitude  = position.coords.latitude;
	    var longitude = position.coords.longitude;

	    $.ajax({
	    	type : "GET"
	    	,url : "https://api2.sktelecom.com/weather/current/hourly?appKey=926493ca-9bd8-44c4-a253-2ffe309c014f&version=1&lat="+latitude+"&lon="+longitude
	    	,header:{
	    		"Accept" : "application/json"
	    		,"Content-Type": "application/json; charset=UTF-8"
	    	}
	    	,success:function(response){
	    		var city = response.weather.hourly[0].grid.city;
	    		var county = response.weather.hourly[0].grid.county;
	    		var village = response.weather.hourly[0].grid.village;
/*	    		var sky = response.weather.hourly[0].sky.code;
	    		var tc = response.weather.hourly[0].temperature.tc;
	    		var tmin = response.weather.hourly[0].temperature.tmin;
	    		var tmax = response.weather.hourly[0].temperature.tmax;
	    		var time = response.weather.hourly[0].timeRelease; */
	    		 
	    		console.log(city + " " + county + " " + village);
	    		$('#weatherDiv').html('<a class="weatherwidget-io" href="https://forecast7.com/ja/37d51127d06/samseong-dong/" data-label_1="サムソンドン" data-label_2="WEATHER" data-font="ヒラギノ角ゴ Pro W3" data-theme="pure">Locating…</a>');
	    		sessionUpload(response);
	    	}
	    })
	  };
	  
	  function sessionUpload(response){
		var city = response.weather.hourly[0].grid.city;
  		var county = response.weather.hourly[0].grid.county;
  		var village = response.weather.hourly[0].grid.village;
  		
  		var sendData = { "village" : village };
  		
  		$.ajax({
  			method : 'get'
  			, url  : 'villageUpload'
  			, data : sendData
  			, contentType : 'application/json; charset=UTF-8'
  			, success : function(response){
  				console.log('session등록완료');
  			}
  		})
	  }
			
	  function error() {
	    alert("사용자의 위치를 찾을 수 없습니다.");
	  };
	  
	  navigator.geolocation.getCurrentPosition(success, error, options);
	  
	  
} 

 $(function(){
		$("#relyInsert").on('click', replyInsert);
	});//버튼을 누르면

	function replyInsert(){ //컨트롤로 가게 하는 경로
		$.ajax({
			method  : 'post'
			, url   : 'selectAll'
			, success : output  //성공하면  output 실행
		});
	}
	                                  
	function output(resp){
		var result = "";
		
		$.each(resp.replylist, function(index, item) {
			
			result += '<tr class="index">';
			console.log(item.checked);
			if(item.checked == '1'){
				result += '<td><div class="selected"><input type="checkbox" data-cno="' + item.schNum + '" value="' + item.checked + ' "checked="checked""/></div></td>';//<사진> 
				console.log("체크인");
			}else{
				console.log("체크아웃");
				result += '<td><div class="selected"><input type="checkbox" data-cno="' + item.schNum + '" value="' + item.checked + '"/></div></td>';//<사진> 
			}
			result += '<td><div class="scetch">'+ item.schTitle +'</div></td>';
			result += '<td><div class="progressbar"><div class="progress-label" >'+ item.schStartdate + ' ~ ' + item.schEnddate +' "</div></div></td>';
			result += '<td><div class="num' + index + '"><div></div></div></td>';//<퍼센트>
			result += '<td>'
			result += '<input class="schUpdate" data-rno="'+ item.schNum+'" type="image" src="assets/img/crystal.PNG" alt="Submit" width="20" height="20" onclick="schUpdate()"/> ';
			result += '<input class="schDelete" data-rno="'+ item.schNum+'" type="image" src="assets/img/delete.PNG" alt="Submit" width="20" height="20" onclick="schDelete()"/> ';
			result += '<input value="'+ item.schNum+'" type="hidden" class="schNum" /> ';
			result += '</td>'
		    result += '</tr>';
		});
		
		$("#result").html(result);  
		
		$.each(resp.percentlist, function(index, item) {
			$( ".progressbar" ).children().eq(index).progressbar({
				value: resp.percentlist[index]
			})
			//막데 그레프
			
			$('.num' + index).circleProgress({      //들어갈 div class명을 넣어주세요
				value: item/100,    //진행된 수를 넣어주세요. 1이 100기준입니다.
				size: 80,//도넛의 크기를 결정해줍니다.
				fill: {
					gradient: ["red", "orange"]    //도넛의 색을 결정해줍니다.
				}
			
				}).on('circle-animation-progress', function(event, progress) {    //라벨을 넣어줍니다.
				 	$(this).children().html(parseInt(item) + '<i>%</i>');
			});
		});
		$(".schDelete").click(schDelete);
		$(".schUpdate").click(schUpdate);
	}

	 function schDelete(){ // 데이터 삭제
		var schNum = $(this).attr("data-rno"); 
		 $.ajax({
			method : 'post'
			, url  : 'schDelete'
			, data : 'schNum=' + schNum
			, success : function(resp){
			}
		}); 
		$(this).parents().parents().remove(".index"); //parents()=바로 위 부모 나타냄!!
	} 
	function schUpdate(){
		 var schNum = $(this).attr("data-rno");  
		 location.href="http://localhost:8888/www/scheduleUpdate?schNum=" + schNum; 
	 }// 수정 할때 사용!!!
	 
	 
	 $(document).ready(function(){  // 체크체크
		 
		 $(document).on('click',".check",function(){
			 var index=$(this).parents().parents().parents().attr("class");
			 var checked = 0;
			  if($(this).prop('checked')){
				 console.log("선 긋기");
				 $(this).parents().children('.test').hide();
				 $(this).parents().parents().parents("."+index).addClass("selected");
				 checked = 1;
			 }else{
				 console.log("선 지우기");
				 $(this).parents().removeClass("selected"); 
				 checked = 0;
			 }
			 var schNum = $(this).attr("data-cno");
			 console.log("스케줄넘버"+JSON.stringify(schNum));
			  $.ajax({
				method : 'get'
			    , url  : 'schUpdate'
				, data : {'checked' : checked,
					      'schNum' :  schNum}
			    , success : function(checked){
					}
			});  
		 });
	 });
</script>
</body>
</html>