import React, {useCallback, useEffect, useState} from 'react';
import BoardList from "./components/BoardList";
import BoardTitle from "./components/BoardTitle";

const BoardPage = () => {
    const initialData = {
        email: "",
        hp: "",
        name: "",
        no: 0,
        point: 0,
        userCode: 0,
    }


    const [userInfo, setUserInfo] = useState(initialData);   //유저 정보
    const [contentData, setContentData] = useState(""); //게시글 관련 Json객체를 넣어줌
    const [page, setPage] = useState([]);
    const [currentPage, setCurrentPage] = useState(1);
    const [pagingInfo, setPagingInfo] = useState("");
    const [searchCondition, setSearchCondition] = useState("title");
    const [searchKeyword, setSearchKeyword] = useState("");
    const blockSize = 5;

    /*console.log(boardClass);
    console.log(categoryNo);*/

    useEffect(() => {
        //유저 정보 받아오기
        $.ajax({
            url: "/launer/board/userInfo",
            type: "JSON",
            method: "GET",
            data: `categoryNo=${categoryNo}&`,
            success: (res) => {
                // setUserInfo(res);
                userInfoClassSet(res);
                console.log(res);
            },
            error: (xhr, status, error) => alert(`error : ${error}`)
        });

        contentList();
    }, []);

    useEffect(() => {
        contentList();
    }, [currentPage, searchKeyword, searchCondition]);

    const userInfoClassSet = useCallback((res) => {
        const tempUserCode = res.usersClassNo ? true : false;
        console.log(tempUserCode);

        const tempUserInfo = tempUserCode ? {...res, userCode : res.usersClassNo} : {...res};
        console.log(tempUserInfo);

        setUserInfo(tempUserInfo);
    })

    const contentList = useCallback(() => {
        const data = {
            "categoryNo": categoryNo,
            "currentPage": currentPage,
            "searchCondition" : searchCondition,
            "searchKeyword" : searchKeyword
        }

        $.ajax({
           url: "/launer/board/searchList",
           method: "GET",
           data: data,
           success: (res) => {
               if(res.SUCCESS) {
                   console.log(res);
                   setContentData(res.jsonData);
                   setPagingInfo(res.pagingInfo);
                   pagingSet(res.pagingInfo);
               }
           },
           error: (xhr, status, error) => console.log(`error : ${error}`)
        });
    });

    const currentPageEvent = useCallback((e) => {
        console.log(`받아온 e=${e}`);
        console.log(`pagingInfo.firstPage=${pagingInfo.firstPage-1}`);
        console.log(`pagingInfo.totalPage=${pagingInfo.totalPage+1}`);
        if(0 < e && e < pagingInfo.totalPage+1) setCurrentPage(e);
    });

    const pagingSet = useCallback((jSonpagingInfo) => {
        let tempPage = [];
        for(let i = jSonpagingInfo.firstPage; i < (jSonpagingInfo.firstPage + jSonpagingInfo.blockSize); i++) {
            if(i > jSonpagingInfo.lastPage) {
                tempPage.push(0);
            }else {
                tempPage.push(i);
            }
        }
        setPage(tempPage);
    });

    const searchProccess = useCallback((keyword, condition) => {
        setSearchKeyword(keyword);
        setSearchCondition(condition);
        setCurrentPage(1);
    });

    return (
        <div className="board-wrap">
            <BoardTitle userInfo={userInfo} boardClass={boardClass} page={page} currentPage={currentPage} currentPageEvent={currentPageEvent} contentList={contentList}></BoardTitle>
            <BoardList searchProccess={searchProccess} userInfo={userInfo} contentData={contentData} contentList={contentList}></BoardList>
        </div>
    );
};

export default BoardPage;