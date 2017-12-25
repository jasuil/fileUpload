package net.my.files;

import java.io.File;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@RestController
public class restcontrollMain {
	
	private static final Logger logger = LoggerFactory.getLogger(restcontrollMain.class);
	
	@ResponseBody
	@RequestMapping(value = "/up/thumb", method = RequestMethod.POST,produces = "text/plain;charset=UTF-8")
	public ResponseEntity<String> thumb(MultipartFile file) {
		logger.info("" + file.getOriginalFilename());
		logger.info("" + file.getSize());
		logger.info("" + file.getContentType());
		
		return new ResponseEntity<>(file.getOriginalFilename(), HttpStatus.CREATED);
	}
	

	@ResponseBody
	@RequestMapping(value = "/up/thumb", method = RequestMethod.GET,produces = "text/plain;charset=UTF-8")
	public ResponseEntity<String> thumbs(MultipartFile file) {
		return new ResponseEntity<>("ST", HttpStatus.CREATED);
	}
	
	@ResponseBody
	@RequestMapping(value = "/delete/thumb", method = RequestMethod.POST,produces = "text/plain;charset=UTF-8")
	public ResponseEntity<String> delThumb(@RequestParam("fileName") String file) {
		logger.info("{}", file);
		return new ResponseEntity<>(file, HttpStatus.CREATED);
	}
	
	@ResponseBody
	@RequestMapping(value = "/upload/files", method = RequestMethod.POST,produces = "text/plain;charset=UTF-8")
	public ResponseEntity<String> upoladFiles( MultipartHttpServletRequest files, HttpServletRequest  request ) {

		Map<String,MultipartFile> getData = files.getFileMap();
	
			logger.info("{}", getData.get("file0"));
			logger.info("{}", getData.get("file1"));
		
		
			// 저장 경로 설정, 현재 웹어플리케이션이 서버에 저장된 경로를 찾아준다.
	        String root = files.getSession().getServletContext().getRealPath("/");
	        //아래 문장도 가능하다.
//	        String root = request.getSession().getServletContext().getRealPath("/");

	        String path = root + "/resources/upload/";
	         
	        String newFileName = ""; // 업로드 되는 파일명
	         
	        File dir = new File(path);
	        if(!dir.isDirectory()){
	            dir.mkdir();
	        }
	         
	        Iterator<String> file = files.getFileNames();
	        while(file.hasNext()){
	            String uploadFile = file.next();
	                         
	            MultipartFile mFile = files.getFile(uploadFile);
	            String fileName = mFile.getOriginalFilename();
	            
	            logger.info("실제 파일 이름 : " + fileName);
	            
	            newFileName = System.currentTimeMillis() + fileName +"."
	                    + fileName.substring(fileName.lastIndexOf(".")+1);
	             
	            try {
	                mFile.transferTo(new File(path + newFileName));
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }

		
		return new ResponseEntity<>(newFileName , HttpStatus.CREATED);
	}
}
