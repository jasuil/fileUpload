<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@ page language="java" 
	pageEncoding="UTF-8"%>
<html>
<head>
	<title>Home</title>
	<meta charset="UTF-8">
	<script src="/resources/js/vendor/jquery-3.2.1.min.js"></script>
	<script src="/resources/js/popper.min.js" ></script>
	<link rel="stylesheet" href="/resources/css/bootstrap.css">
	<script src="/resources/js/bootstrap.js" ></script>

	<style>
	.fileDrop{
	width:100%;
	height:200px;
	border:1px dotted blue;
	}
	</style>

</head>
<body>

	<div class="filebox" style="width:700px;" id="commFileDiv0">
	<input class='upload-name' name='commFilename0' id='commFilename0' disabled="disabled" value='' >
	
	 <input type='file'  name='ex_commFilename0' id='ex_commFilename0' class='upload-hidden' />	
	  <input type='file'  name='ex_commFilename1' id='ex_commFilename1' class='upload-hidden' />		 
	  <input type='button' id='submitt' />
		<div class="selectedFile">
		</div>
		<div class="fileDrop">
		</div>
	</div>
	
	<P>  The time on the server is ${serverTime}. </P>
	<script>
	var fileCount = 0;
	var entireFormData = new FormData();
	
	$(document).ready(function() {
		//파일 업로드
		var fileTarget = $('.upload-hidden');
		
		
		fileTarget.on('change', function(){  // 값이 변경되면
			if(window.FileReader){  // modern browser
				var filename = $(this)[0].files[0].name;
				var size = $(this)[0].files[0].size;
			}
			else {  // old IE
				var filename = $(this).val().split('/').pop().split('\\').pop();  // 파일명만 추출
			}
		
			// 추출한 파일명 삽입
			$(this).siblings('.upload-name').val(filename);
			
			file = $(this)[0].files[0];
			var formData = new FormData();
			formData.append('file', file);
			entireFormData.append('file' + (++fileCount) , file);
			thumbnail(formData);
		});
		
		//파일 끌어놓기
		$('.fileDrop').on('dragenter dragover', function(event){
			event.preventDefault();
		});
		$('.fileDrop').on('drop' , function(event){
			event.preventDefault();
			var files = event.originalEvent.dataTransfer.files;
			var file = files[0];
			
			var formData = new FormData();
			formData.append('file', file);
			entireFormData.append('file' + (++fileCount) , file);
			thumbnail(formData);
			
		});
		
		$('.filebox .selectedFile').on('click', 'small', function(event){
			var that = $(this);
			var fileid = that.attr('file-id');
			entireFormData.delete(that.attr('file-id'));
			
			
			$.ajax({
				url:'/delete/thumb',
				data:{fileName:that.attr('data-src')},
				dataType:'text',
				type:'POST',
				success: function(getData){
					alert(getData);
					that.remove();
					var t= $("#pre" + getData).text();
					$("#div" + fileid).remove();
				}
			});
			
		});
		
		$('#submitt').on('click', function(){
			
			var files = new Array();
//			var formData = new FormData();
//			var type = $('.upload-hidden');
			
//			for(i=0;i<type.length;i++){
				
//				formData.append('file' + i, type[i].files[0]);
//			}
			

			$.ajax({
				url:'/upload/files',
				data:entireFormData,
				dataType:'text',
				processData:false,
				contentType:false,
				type:'POST',
				success: function(getData){
					alert(getData);
				}
			});
		});
		
		function thumbnail(dataT){
			if(fileCount<5){
			$.ajax({
				url:'/up/thumb',
				data:dataT,
				dataType:'text',
				processData:false,
				contentType:false,
				type:'POST',
				success: function(getData){
					alert(getData);
					$('.selectedFile').append('<div id="divfile' + fileCount + '"><pre>' + getData + '</pre><small data-src="' + getData + '" file-id="file' + fileCount + '">x</small></div>');
				
				}
			});
			}else{
				//$('.selectedFile').remove();
			}
		}
		
		
	});
	</script>

</body>
</html>

