<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
 <link rel="stylesheet", href="https://use.fontawesome.com/releases/v5.5.0/css/all.css" integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU", crossorigin="anonymous"/>
<style>
#map{
position: absolute;
z-index:1;
}

#searchbox{
position:absolute;
top:120px;
left:50px;
z-index:2;
} 
#search{
position:absolute;
top:128px;
left:380px;
z-index:3;
}
#circle{
position:absolute;
top:128px;
left:355px;
z-index:3;
}
</style>
<meta charset="utf-8" />
<title>Kakao 지도 시작하기</title>
</head>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<body>
	<h2>MAP</h2>
	<p>
		<em>지도를 클릭해주세요!</em>
	</p>
	<p id="result"></p>
	<p id="click"></p>
	<div id="searchbox"><input type="text" id="text"  placeholder=" search..." size="50" required="required" style="border: 3px solid; height:30px;"></div>
	<div id=search><i class="fas fa-search" onclick="test()" ></i></div><!-- 돋보기 -->
	<div id=circle><i class="far fa-times-circle" onclick="document.getElementById('text').value=''"></i></div>
	<div id="map" style="width: 500px; height: 400px;">	
	</div>
	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c86e6ba80ec76ab2d813f67a8ba4ffc2"></script>
	<script>
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		mapOption = {
			center : new kakao.maps.LatLng(37.5662952, 126.97794509999994), // 지도의 중심좌표
			level : 3
		// 지도의 확대 레벨
		};
		var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
	/* 	// 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성합니다
		var mapTypeControl = new kakao.maps.MapTypeControl();
		// 지도에 컨트롤을 추가해야 지도위에 표시됩니다
		// kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOPRIGHT는 오른쪽 위를 의미합니다
		map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
		// 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
		var zoomControl = new kakao.maps.ZoomControl();
		map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT); */
		
		// 마커가 표시될 위치입니다 
		var markerPosition  = new kakao.maps.LatLng(37.5662952, 126.97794509999994); 
		// 마커를 생성합니다
		var marker = new kakao.maps.Marker({
		    position: markerPosition
		});
		// 마커가 지도 위에 표시되도록 설정합니다
		marker.setMap(map);
		
		// 마우스 드래그로 지도 이동이 완료되었을 때 마지막 파라미터로 넘어온 함수를 호출하도록 이벤트를 등록합니다
		kakao.maps.event.addListener(map, 'dragend', function() {        
		    
		    // 지도 중심좌표를 얻어옵니다 
		    var latlng = {
				    _x: map.getCenter().getLat(),
				    _y: map.getCenter().getLng()
				};
			 
		    var message = '변경된 지도 중심좌표는 ' + latlng._x + ' 이고, ';
		    message += '경도는 ' + latlng._y + ' 입니다';
		    
		    var resultDiv = document.getElementById('result');  
		    //resultDiv.innerHTML = message;
		    
		    $.ajax({
		        url : "center",
		        type : "GET",
		        dataType: "json",
		        data: latlng,
		        success : function(data){
		        	 console.log(latlng._x, latlng._y);
			        	}
		        });
		    
		});
		// 지도에 클릭 이벤트를 등록합니다
		// 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
		 var markers=[];
		kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
			removeMarker();
			// 클릭한 위도, 경도 정보를 가져옵니다 
			var latlng = {
				    x: mouseEvent.latLng.getLat(),
				    y: mouseEvent.latLng.getLng()
				};
			
			var message = '클릭한 위치의 위도는 ' + latlng.x + ' 이고, ';
			message += '경도는 ' + latlng.y + ' 입니다';
			var resultDiv = document.getElementById('click');
			//resultDiv.innerHTML = message;
			var x = 0;
			var y = 0;
			var count = 0;
			   $.ajax({
			        url : "radius",
			        type : "GET",
			        //dataType: "json",
			        data: latlng,
			        success : function(data){
			        	
				        	// 마커 이미지의 이미지 주소입니다
				        	var imageSrc = "http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png"; 
				        	count = data.length;
				        	for (var i = 0; i < data.length; i++) {
				        		  var coords =new kakao.maps.LatLng(data[i].location[1],data[i].location[0]);
				        		 x +=data[i].location[1];
				        		 y +=data[i].location[0];
				        		  console.log(data[i].location[1],data[i].location[0])
				        		  // 마커 이미지의 이미지 크기 입니다
				        		    var imageSize = new kakao.maps.Size(24, 35); 
				        		    
				        		    // 마커 이미지를 생성합니다    
				        		    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); 
				        		   
				        		    // 마커를 생성합니다
				        		    var marker = new kakao.maps.Marker({
				        		        map: map, // 마커를 표시할 지도
				        		        position: coords, // 마커를 표시할 위치
				        		        image : markerImage // 마커 이미지 
				        		    });
				        		   
				     
				        		    markers.push(marker);
				
					        	}
				        	}
			        });
		});

		 function test(){ 
				
				var search = document.getElementById("text").value;
				 
				removeMarker();
				// 클릭한 위도, 경도 정보를 가져옵니다 
				var keyword = {
					    name: search
					};
				var x = 0;
				var y = 0;
				var count = 0;
				
				   $.ajax({
				        url : "search",
				        type : "GET",
				        //dataType: "json",
				        data: keyword,
				        success : function(data){
				        	
					        	// 마커 이미지의 이미지 주소입니다
					        	var imageSrc = "http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png"; 
					        	count = data.length;
					        	for (var i = 0; i < data.length; i++) {
					        		  var coords =new kakao.maps.LatLng(data[i].location[1],data[i].location[0]);
					        		  x +=data[i].location[1];
						        	y +=data[i].location[0];
						        	
					        		  console.log(data[i].location[1],data[i].location[0])
					        		  // 마커 이미지의 이미지 크기 입니다
					        		    var imageSize = new kakao.maps.Size(24, 35); 
					        		    
					        		    // 마커 이미지를 생성합니다    
					        		    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); 
					        		   
					        		    // 마커를 생성합니다
					        		    var marker = new kakao.maps.Marker({
					        		        map: map, // 마커를 표시할 지도
					        		        position: coords, // 마커를 표시할 위치
					        		        image : markerImage // 마커 이미지 
					        		    });
					        		    markers.push(marker);
					
						        	}
					        	x=x/count;
					        	y=y/count;
					        	var moveLatLng = new kakao.maps.LatLng(x, y);   
					        	map.panTo(moveLatLng);
					        	}
				        });

			        
		 }

			document.getElementById("text").addEventListener("keypress",function(e){
					if(e.keyCode===13)
					
					
						test();
				})
		// 지도 위에 표시되고 있는 마커를 모두 제거합니다
		function removeMarker() {
		for (var i = 0; i < markers.length; i++)
				markers[i].setMap(null);
		markers = [];
		}
		/*
		  $(document).ready(function() {
			   $.ajax({
			        url : "all",
			        type : "POST",
			        dataType: "json",
			        success : function(data){
			        	// 마커 이미지의 이미지 주소입니다
			        	var imageSrc = "http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png"; 
			        	for (var i = 0; i < data.length; i++) {
			        		  var coords =new kakao.maps.LatLng(data[i].location[1],data[i].location[0]);
			        		 
			        		  console.log(data[i].location[1],data[i].location[0])
			        		  // 마커 이미지의 이미지 크기 입니다
			        		    var imageSize = new kakao.maps.Size(24, 35); 
			        		    
			        		    // 마커 이미지를 생성합니다    
			        		    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); 
			        		    
			        		    // 마커를 생성합니다
			        		    var marker = new kakao.maps.Marker({
			        		        map: map, // 마커를 표시할 지도
			        		        position: coords, // 마커를 표시할 위치
			        		        image : markerImage // 마커 이미지 
			        		    });
				        	}
			        	}
			        });
		  });  
		 */
		/*  kakao.maps.event.addListener(map, 'dragend',  function test(){ 
		var search = document.getElementById("text").value;
		removeMarker();
		// 클릭한 위도, 경도 정보를 가져옵니다 
		var keyword = {
			    name: search
			};

		
		   $.ajax({
		        url : "search",
		        type : "GET",
		        //dataType: "json",
		        data: keyword,
		        success : function(data){
		        	
			        	// 마커 이미지의 이미지 주소입니다
			        	var imageSrc = "http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png"; 
			        	for (var i = 0; i < data.length; i++) {
			        		  var coords =new kakao.maps.LatLng(data[i].location[1],data[i].location[0]);
			        		 
			        		  console.log(data[i].location[1],data[i].location[0])
			        		  // 마커 이미지의 이미지 크기 입니다
			        		    var imageSize = new kakao.maps.Size(24, 35); 
			        		    
			        		    // 마커 이미지를 생성합니다    
			        		    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); 
			        		   
			        		    // 마커를 생성합니다
			        		    var marker = new kakao.maps.Marker({
			        		        map: map, // 마커를 표시할 지도
			        		        position: coords, // 마커를 표시할 위치
			        		        image : markerImage // 마커 이미지 
			        		    });
			        		    markers.push(marker);
			
				        	}
			        	}
		        });
	
			 }); */

		
			 
		 	</script>
</body>
</html>
