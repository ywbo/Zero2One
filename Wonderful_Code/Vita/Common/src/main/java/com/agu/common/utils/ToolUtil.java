package com.agu.common.utils;

import java.util.Random;

/**
 * @ClassName ToolUtil
 * @Description 通用方法工具类
 * @Author yuwenbo
 * @Date 2021-03-16 22:17
 **/
public class ToolUtil {
    public static String getRandomString(int length){
        Random random = new Random();
        StringBuilder sb = new StringBuilder();
        for(int i = 0; i < length; i++){
            int range = random.nextInt(75) + 48;
            range = range < 97 ? (range > 57 ? 114-range : range) : range;
            sb.append((char) range);
        }
        return sb.toString();
    }
}
