package com.ez.launer.board.controller;

import com.ez.launer.board.model.*;
import com.ez.launer.common.ConstUtil;
import com.ez.launer.common.FileUploadUtil;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.*;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class BoardAPIController {
    private static final Logger logger = LoggerFactory.getLogger(BoardAPIController.class);

    private final BoardService boardService;
    private final FileUploadUtil fileUploadUtil;

    @GetMapping("/board/{no}")
    public BoardDetailDownVO boardDetail (@PathVariable int no,
                                          HttpServletRequest request,
                                          HttpServletResponse response) {
        logger.info("글 상세보기 api, no={}", no);

        //쿠키 체크(view count 관련)
        int ckChk = 0;
        String tempCookieValue = "";
        Cookie[] cookies = request.getCookies();
        for(Cookie cookie : cookies) {
            if(cookie.getName().equals("board_view")) {
                ckChk++;
                tempCookieValue = cookie.getValue();
            }
        }

        Cookie cookie = null;
        int chk = 0;
        if(ckChk > 0) { //쿠키가 있으면 기존 거 덮어!!
            String[] text = tempCookieValue.split("/");
            for(String num : text)  //기존 쿠키에서 해당 게시글 번호가 있는지 확인
                if(num.equals(String.valueOf(no))) chk++;

            if(chk == 0) tempCookieValue += "/" + no;
        }else { //새로 만듬
            tempCookieValue = String.valueOf(no);
        }

        if(chk == 0) {
            cookie = new Cookie("board_view", tempCookieValue);
            cookie.setMaxAge(24*60*60); //24시간
            cookie.setPath("/");

            response.addCookie(cookie);

            int updateChk = boardService.updateBoardViewCount(no);
            logger.info("조회수 증가 결과 updateChk={}", updateChk);
        }

        BoardDetailDownVO boardDetailDownVO = boardService.selectBoardByNo(no);
        logger.info("조회 결과 boardDetailDownVO={}", boardDetailDownVO);

        return boardDetailDownVO;
    }

    @DeleteMapping("/board/{no}")
    @ResponseBody
    public Map<String, Object> boardDelete(@PathVariable int no,
                                           HttpServletRequest request) {
        logger.info("글 삭제 no={}", no);

        List<BoardFileVO> fileList = boardService.selectFileByNo(no);

        Map<String, Object> resMap = new HashMap<>();
        resMap.put("no", no);

        int cnt = boardService.deleteBoard(resMap);
        logger.info("글 삭제 결과 cnt={}", cnt);

        boolean bool = false;
        String msg = "삭제 실패";
        if(cnt > 0) {
            bool = true;
            msg = "삭제 성공";


            String uploadPath = fileUploadUtil.getUploadPath(request, ConstUtil.UPLOAD_FILE_FLAG);
            for(BoardFileVO boardFileVO : fileList) {
                File delFile = new File(uploadPath, boardFileVO.getFileName());
                if(delFile.exists()) {
                    boolean fileBool = delFile.delete();
                    logger.info("파일 삭제 여부: {}", fileBool);
                }
            }
        }

        resMap.clear();
        resMap.put("SUCCESS", bool);
        resMap.put("message", msg);

        return resMap;
    }

    @PostMapping("/board/{fileChk}")
    @ResponseBody
    public String updateBoard(@PathVariable boolean fileChk, @RequestPart(value = "key") BoardVO boardVO,
                              HttpServletRequest request) {
        logger.info("파일수정 API / fileChk={}, boardVO={}", fileChk, boardVO);
        Map<String, Object> serviceMap = new HashMap<>();

        List<BoardFileVO> oldFileList = boardService.selectFileByNo(boardVO.getNo());

        //파일 업로드 처리
        String fileName = "", originFileName = "";
        long fileSize = 0;
        List<UploadFileVO> fileListVo = new ArrayList<>();

        try {
            List<Map<String, Object>> fileList = fileUploadUtil.mulitiFileUpload(request, ConstUtil.UPLOAD_FILE_FLAG);
            for(Map<String, Object> fileMap : fileList) {
                UploadFileVO uploadFileVO = new UploadFileVO();

                originFileName = (String)fileMap.get("originalFileName");
                fileName = (String)fileMap.get("fileName");
                fileSize = (long)fileMap.get("fileSize");

                uploadFileVO.setBoardNo(boardVO.getNo());
                uploadFileVO.setOriginalFileName(originFileName);
                uploadFileVO.setFileName(fileName);
                uploadFileVO.setFileSize(fileSize);

                fileListVo.add(uploadFileVO);
            }//for

            logger.info("파일 업로드 성공 fileListVo.size={}, originFileName={}, fileName={}, fileSize={}",
                    fileListVo.size(), originFileName, fileName, fileSize);
        } catch (IllegalStateException | IOException e) {
            e.printStackTrace();
        }

        serviceMap.put("fileListVo", fileListVo);
        serviceMap.put("fileChk", fileChk);
        serviceMap.put("boardVO", boardVO);

        int cnt = boardService.updateBoard(serviceMap);
        logger.info("게시판 수정 로직 결과 cnt={}", cnt);

        if(cnt > 0) {
            String uploadPath = fileUploadUtil.getUploadPath(request, ConstUtil.UPLOAD_FILE_FLAG);
            for(BoardFileVO boardFileVO : oldFileList) {
                File delFile = new File(uploadPath, boardFileVO.getFileName());
                if(delFile.exists()) {
                    boolean fileBool = delFile.delete();
                    logger.info("파일 삭제 여부: {}", fileBool);
                }
            }
        }

        String msg = "수정 실패";
        if(cnt > 0) msg = "수정 성공";

        return msg;
    }



    @DeleteMapping("/fileDelete/{fileNo}")
    @ResponseBody
    public Map<String, Object> fileDelete(@PathVariable int fileNo, HttpServletRequest request) {
        logger.info("파일 삭제, fileNo={}", fileNo);

        BoardFileVO boardFileVO = boardService.selectBoardFileByNo(fileNo);
        logger.info("파일 정보 boardFileVO={}", boardFileVO);

        int result = boardService.deleteFile(fileNo);
        logger.info("DB 파일정보 삭제 result={}", result);

        boolean resBool = result > 0;

        //파일삭제
        if(resBool) {
            String uploadPath = fileUploadUtil.getUploadPath(request, ConstUtil.UPLOAD_FILE_FLAG);
            File delFile = new File(uploadPath, boardFileVO.getFileName());
            if(delFile.exists()) {
                boolean fileBool = delFile.delete();
                logger.info("파일 삭제 여부: {}", fileBool);
            }
        }

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("SUCCESS", resBool);

        return resultMap;
    }























}
