package com.ez.launer.common;


public class MapPolygon {
    private double[][] jongroPolygon() {
        double[][] doubles = new double[][]{
                {37.5656050694, 126.9666206456},
                {37.5784129951, 126.9540488296},
                {37.5914498326, 126.9895037779},
                {37.5923783172, 127.0009624487},
                {37.5861793134, 127.0065101425},
                {37.5803046849, 127.0088417770},
                {37.5815472062, 127.0166988960},
                {37.5773303163, 127.0183054861},
                {37.5787533323, 127.0215888846},
                {37.5779781813, 127.0231509236},
                {37.5716891899, 127.0233980122},
                {37.5697803242, 127.0159265424},
                {37.5697183118, 127.0020035505},
                {37.5678796424, 126.9875601809},
                {37.5697510659, 126.9720747942},
                {37.5684529233, 126.9692228145}
        };

        return doubles;
    }


    //지점번호를 통하여 알맞는 다각형 좌표를 리턴
    public double[][] filterPolygon(int no) {
        double[][] result = null;

        if(no == 1) {
            result = jongroPolygon();
        }

        return result;
    }
}
