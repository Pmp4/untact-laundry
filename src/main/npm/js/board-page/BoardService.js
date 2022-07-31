import httpCommon from "./http-common";
import httpFileCommon from "./http-file-common";

const boardNoView = (no) => {
    return httpCommon.get(`/board/${no}`);
}

const boardDeleteNo = (no) => {
    return httpCommon.delete(`/board/${no}`)
}

const boardFileDelete = (no) => {
	return httpCommon.delete(`/fileDelete/${no}`);
}

/*const fileDownload = (data) => {
    return httpCommon.get("/board/file/download", data);
}*/

const boardUpdate = (fileChk, boardVo) => {
    return httpFileCommon.post(`/board/${fileChk}`, boardVo);
}



















/* 댓글 관련 */
const commentsSelectByBoardNo = (boardNo) => {
	return httpCommon.get(`/comments/${boardNo}`);
}

/*const commentsInsert = (boardNo, usersNo, content, groupNo) => {
	return httpCommon.get(`/comments/${boardNo}/${usersNo}/${content}/${groupNo}`);
}*/

const commentsInsert = (commentsVO) => {
	return httpCommon.post(`/comments`, commentsVO);
}


const commentsDeleteByCommentsNo = (commentsNo) => {
	return httpCommon.delete(`/comments/${commentsNo}`);
}







export default {boardNoView, boardDeleteNo, boardFileDelete, boardUpdate,
				commentsSelectByBoardNo, commentsInsert, commentsDeleteByCommentsNo};
