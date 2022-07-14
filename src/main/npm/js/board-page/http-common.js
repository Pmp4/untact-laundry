import axios from "axios";
export default axios.create({
    baseURL : "http://localhost:9095/launer/api",
    headers:{
        "Content-type":"application/json",
        'Access-Control-Allow-Origin': 'http://localhost:9095' // 서버 domain
    },
    withCredentials: true
});

// "Content-Type": "multipart/form-data",