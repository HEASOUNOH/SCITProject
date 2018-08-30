<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="resources/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
$(function(){
	$(".title").on('click',function(){
		var plaNum=$(this).attr('data-rno');
		location.href="scheduleList?plaNum="+plaNum;
	});
	
});

</script>
<title>Insert title here</title>
</head>
<body>
	<table>
		<tr>
			<th>planners</th>
		</tr>
			<c:forEach var="planner" items="${plannerList }">
			
			<tr>
			<td><input type="button" value="${planner.plaTitle}" data-rno="${planner.plaNum}" class="title"/></td>
			</tr>
			</c:forEach>
	</table>
	<div>
		
		<a href="insertPlanner">플래너 생성</a>
	
	</div>
</body>
</html>