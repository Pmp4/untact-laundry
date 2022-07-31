import React, {useCallback, useEffect, useRef, useState} from 'react';
import BoardService from "../BoardService";
import BoardComment from "./BoardComment";
import EditorComponent from "./Editor/EditorComponent";


const BoardDetail = ({detailNo, userInfo, contentList, deleteModalOut}) => {
    const initialData = {
        no: 0,
        usersNo: "",
        title: "제목입니다.",
        content: "",
        regdate: "",
        categoryNo: "",
        name: "",
        viewCount: 0
    }

    const [data, setData] = useState(initialData);
    const [files, setFiles] = useState([]);
    const [fileChk, setFileChk] = useState(false);
    const [editMode, setEditMode] = useState(false);

    const [title, setTitle] = useState("");
    const [value, setValue] = useState("");

    const refKey = useRef([]);


    let [editFileChk, setEditFileChk] = useState(false);

    /*const fileSet = files.map(item => (
        <div key={item.no} className="file-down" onClick={() => {fileDownload({
            no: item.no,
            boardNo: item.boardNo,
            fileName: item.fileName,
            originalFileName: item.originalFileName,
            fileSize: item.fileSize,
            downCount: item.downCount,
        })}}>
            <h3>{item.originalFileName}</h3>
            <p>{Math.round((item.fileSize/1024.0) * 10) / 10}kb &nbsp;<span><i className="fa-solid fa-download"></i> {item.downCount}</span></p>
        </div>
    ));*/
    const fileSet = files.map((item, index) => (
        /*<div key={item.no} className="file-down" onClick={() => {
            window.open(
                `http://localhost:9095/launer/board/file/download?fileName=${item.fileName}&no=${item.no}`,
                '_blank'
            );
        }}>*/
        <div key={item.no} className={editMode ? "file-down" : "file-down mode"} onClick={editMode ? () => {} :
            () => {
                window.open(
                    `http://localhost:9095/launer/board/file/download?fileName=${item.fileName}&no=${item.no}`
                );
            }
        }>
            <h3>{item.originalFileName}</h3>
            <p>{Math.round((item.fileSize / 1024.0) * 10) / 10}kb &nbsp;<span><i
                className="fa-solid fa-download"></i> {item.downCount}</span>
            </p>
            {editMode ?
                <div className="file-del-btn" onClick={() => {deleteFile(item.no)}}>
                    <i className="fa-solid fa-minus"></i>
                </div>
                : ""}
        </div>


        /*<form key={item.no} action="/board/file/download">
            <div key={item.no} className="file-down" onClick={() => {fileDownload(index)}}>
                <h3>{item.originalFileName}</h3>
                <p>{Math.round((item.fileSize/1024.0) * 10) / 10}kb &nbsp;<span><i className="fa-solid fa-download"></i> {item.downCount}</span></p>
            </div>
        </form>*/
    ));
    /*boardNo: 5
    downCount: 0
    fileName: "Muli-Black_20220705231856223.ttf"
    fileSize: 91724
    no: 4
    originalFileName: "Muli-Black.ttf"*/

    useEffect(() => {
        apiBoard();
    }, [detailNo]);

    const apiBoard = () => {
        BoardService.boardNoView(parseInt(detailNo))
            .then((response) => {
                console.log(response.data);
                setData(response.data.boardVO);
                setTitle(response.data.boardVO.title);
                setValue(response.data.boardVO.content);
                if (response.data.files.length > 0) {
                    setFiles(response.data.files);
                    setFileChk(true);
                }
            })
        // .catch((e) => console.log(e))
    }


    const deleteBoard = useCallback(() => {
        BoardService.boardDeleteNo(detailNo, data.usersNo)
            .then((response) => {
                console.log(response.data);
                alert(response.data.message);
                if (response.data.SUCCESS) {
                    contentList();
                    deleteModalOut();
                } else {
                    window.location.reload();
                }
            })
        // .catch((e) => console.log(e))
    });


    const updateBoard = useCallback(() => {
        const formData = new FormData();

        const fileData = refKey.current.file;

        for(let i = 0; i < fileData.files.length; i++)
            formData.append("file", fileData.files[i]);

        const data = {
            no: detailNo,
            title,
            content : value
        }

        formData.append("key", new Blob([JSON.stringify(data)], {type: "application/json"}));

        BoardService.boardUpdate(editFileChk, formData)
            .then((response) => {
                alert(response.data);
                setEditMode(false);
                apiBoard();
            })
    });


    /*const fileDownload = useCallback((index) => {
        const formData = new FormData();
        const data = {...files[index]}

        formData.append('key', new Blob([JSON.stringify(data)], {type: "application/json"}));
        console.log(formData);

        const xhr = new XMLHttpRequest();
        xhr.open("POST", "/launer/board/file/download");
        xhr.send(formData);
    })*/

    const deleteFile = useCallback((fileNo) => {
        console.log(fileNo);

        BoardService.boardFileDelete(fileNo)
            .then((response) => {
                console.log(response.data.SUCCESS);
                if(response.data.SUCCESS) {
                    apiBoard();
                }
            })
    });


    const dateReturn = useCallback((date) => {
        return `${date.getFullYear()}-${(date.getMonth() + 1) >= 10 ?
            (date.getMonth() + 1) : ("0" + (date.getMonth() + 1))}-${date.getDate() >= 10 ?
            date.getDate() : ("0" + date.getDate())}  ${date.getHours() >= 10 ?
            date.getHours() : ("0" + date.getHours())}:${date.getMinutes() >= 10 ?
            date.getMinutes() : ("0" + date.getMinutes())}`
    });

    const controllerBtn = (
        <div className="board-controll-btn">
            {parseInt(userInfo.no) === data.usersNo && (<button onClick={() => setEditMode(!editMode)}>{editMode ? "취소" : "수정"}</button>)}
            {editMode ? (
                <button className="update-btn" onClick={updateBoard}>수정</button>) :
                (<button className="delete-btn" onClick={deleteBoard}>삭제</button>)}
        </div>
    );

    const fileChange = useCallback(() => setEditFileChk(true));


    const onChange = useCallback((value) => {
        console.log(value);
        setValue(value);
    });

    return (
        <div id="board-detail-wrap">
            <div className="title-line">
                <h2 className="title">{editMode ? (
                    <input type="text" value={title} onChange={(e) => setTitle(e.target.value)}/>) : data.title}</h2>
                <div className="title-sub">
                    <div className="user-info">
                        <p id="name">{data.name}</p>
                        <span id="regdate">{dateReturn(new Date(data.regdate))}</span>
                        &nbsp;&nbsp; 조회<span id="viewCount">{data.viewCount}</span>
                    </div>
                    {(parseInt(userInfo.no) === data.usersNo || parseInt(userInfo.userCode) === 4 || parseInt(userInfo.userCode) === 3) && controllerBtn}
                </div>
                {fileChk &&
                    <div className="file-down-part">
                        {fileSet}
                    </div>
                }
                {editMode ? (<input onChange={fileChange} ref={e => refKey.current["file"] = e} className="upload-name"  type="file" placeholder="첨부파일" multiple/>) : ""}
            </div>
            {/*<input type="text" value={content} onChange={(e) => setContent(e.target.value)}/>*/}
            <div className="content-wrap" style={!editMode ? {} : {
                marginBottom : "60px"
            }}>
                {editMode ? (<EditorComponent value={value} onChange={onChange}/>) :
                    (<div dangerouslySetInnerHTML={{__html: (data.content)}}></div>)
                }
            </div>
            {categoryNo.includes("A") || !editMode ? <BoardComment dateReturn={dateReturn} detailNo={detailNo} userInfo={userInfo} apiBoard={apiBoard}/> : ""}
        </div>
    );
};

export default BoardDetail;