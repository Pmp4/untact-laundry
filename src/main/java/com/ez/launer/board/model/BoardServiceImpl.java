package com.ez.launer.board.model;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService{
    private static final Logger logger = LoggerFactory.getLogger(BoardServiceImpl.class);
    private final BoardDAO boardDAO;

    @Override
    @Transactional
    public int insertUploadFileBoard(BoardVO boardVO, List<UploadFileVO> fileList) {
        //1. 글 먼저 등록
        //2. 파일 업로드(반복문)
        int result = 0;

        try {
            result = boardDAO.insertBoard(boardVO);

            if(result > 0) {
                for(UploadFileVO uploadFileVO : fileList) {
                    uploadFileVO.setBoardNo(boardVO.getNo());
                    result = boardDAO.insertUploadFile(uploadFileVO);
                }
            }
        } catch(RuntimeException e) {
            e.printStackTrace();
            result = -1;
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }

        return result;
    }

    @Override
    public List<Map<String, Object>> selectByCategoryNo(Map<String, Object> map) {
        return boardDAO.selectByCategoryNo(map);
    }

    @Override
    public int countBoardList(Map<String, Object> map) {
        return boardDAO.countBoardList(map);
    }

    @Override
    public BoardDetailDownVO selectBoardByNo(int no) {
        return boardDAO.selectBoardByNo(no);
    }

    @Override
    @Transactional
    public int deleteBoard(Map<String, Object> map) {
        int result = 0;

        try {
            boardDAO.deleteBoardFile((Integer) map.get("no"));
            result = boardDAO.deleteBoard(map);

        } catch(RuntimeException e) {
            e.printStackTrace();
            result = -1;
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }

        return result;
    }

    @Override
    public int downloadCount(int no) {
        return boardDAO.downloadCount(no);
    }

    @Override
    public int updateBoardViewCount(int no) {
        return boardDAO.updateBoardViewCount(no);
    }

    @Override
    public List<BoardFileVO> selectFileByNo(int no) {
        return boardDAO.selectFileByNo(no);
    }

    @Override
    @Transactional
    public int updateBoard(Map<String, Object> map) {
        int result = 0;
        //[1] 게시판 수정
        //--fileChk
        //[3] 기존 파일 삭제
        //[2] 파일 테이블 insert

        BoardVO boardVo = (BoardVO) map.get("boardVO");
        int no = boardVo.getNo();
        boolean bool = (boolean) map.get("fileChk");
        List<UploadFileVO> uploadFileVOList = (List<UploadFileVO>) map.get("fileListVo");

        logger.info("변환 결과 boardVo={}, bool={}, uploadFileVoList.size={}", boardVo, bool, uploadFileVOList.size());

        try {
            result = boardDAO.updateBoard(boardVo);
            logger.info("[1] 게시판 업데이트 result={}", result);

            //기존파일 삭제하는 로직
            //기존파일 삭제하는 로직
            //기존파일 삭제하는 로직
            /*if(result > 0 && bool) {
                int cnt = 0;
                cnt = boardDAO.deleteBoardFile(no);
                logger.info("[2] 기존파일 삭제 cnt={}", cnt);

                for (UploadFileVO uploadFileVO : uploadFileVOList) {
                    logger.info("파일 정보 : {}", uploadFileVO);
                    cnt = boardDAO.insertUploadFile(uploadFileVO);
                }
                logger.info("[3] 파일 dataInsert result={}", cnt);
            }*/

            //새롭게 짠 로직
            //새롭게 짠 로직
            //새롭게 짠 로직
            int cnt = 0;
            for (UploadFileVO uploadFileVO : uploadFileVOList) {
                logger.info("파일 정보 : {}", uploadFileVO);
                result = boardDAO.insertUploadFile(uploadFileVO);
            }
        } catch(RuntimeException e) {
            e.printStackTrace();
            result = -1;
            TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        }

        return result;
    }

    @Override
    public BoardCategoryVO selectBoardCategoryByNo(String categoryNo) {
        return boardDAO.selectBoardCategoryByNo(categoryNo);
    }

    @Override
    public int deleteFile(int no) {
        return boardDAO.deleteBoardFileByNo(no);
    }

    @Override
    public BoardFileVO selectBoardFileByNo(int no) {
        return boardDAO.selectBoardFileByNo(no);
    }
}
