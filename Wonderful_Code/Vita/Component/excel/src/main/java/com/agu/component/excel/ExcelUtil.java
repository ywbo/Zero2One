package com.agu.component.excel;

import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.agu.common.utils.HttpServletUtil;
import com.agu.component.excel.annotation.Excel;
import com.agu.component.excel.enums.ExcelType;

import cn.hutool.http.server.HttpServerResponse;
import net.sf.ehcache.Cache;

/**
 *  Excel 工具类
 *
 * @author yuwenbo
 * @since 2021-03-17
 */
public class ExcelUtil {

    private static int dataRow = 2;
    private static Cache dictCache = EhcacheeUtil.getDictCache();

    /**
     * 获取通用样式
     * @param workbook
     * @return
     */
    private static XSSFCellStyle getCellStyle(XSSFWorkbook workbook){
        // 创建单元格样式
        XSSFCellStyle cellStyle = workbook.createCellStyle();
        // 设置单元格上边框类型
        cellStyle.setBorderTop(BorderStyle.THIN);
        // 设置单元格左边框类型
        cellStyle.setBorderLeft(BorderStyle.THIN);
        // 设置单元格右边框类型
        cellStyle.setBorderRight(BorderStyle.THIN);
        // 设置单元格底边框类型
        cellStyle.setBorderBottom(BorderStyle.THIN);
        // 设置单元格对齐方式为左对齐
        cellStyle.setAlignment(HorizontalAlignment.LEFT);
        // 设置字体
        XSSFFont font = workbook.createFont();
        font.setFontName("Microsoft YaHei UI");
        cellStyle.setFont(font);
        return cellStyle;
    }

    /**
     * 功能模板（标题及表头）
     * @param sheetTitle
     * @param fields
     * @return
     */
    private static XSSFWorkbook getCommon(String sheetTitle, List<Field> fields){
        XSSFWorkbook workbook = new XSSFWorkbook();
        XSSFSheet sheet = workbook.createSheet(sheetTitle);
        // 设置列宽
        for (int i = 0; i < fields.size(); i++){
            sheet.setColumnWidth(i, 16 * 256);
        }

        // 通用样式
        XSSFCellStyle cellStyle = getCellStyle(workbook);

        /** 标题样式 */
        XSSFCellStyle titleStyle = workbook.createCellStyle();
        titleStyle.cloneStyleFrom(cellStyle);
        titleStyle.setAlignment(HorizontalAlignment.CENTER);
        titleStyle.setVerticalAlignment(VerticalAlignment.CENTER);
        // 设置字体
        XSSFFont titleFont = workbook.createFont();
        titleFont.setFontName(cellStyle.getFont().getFontName());
        titleFont.setFontHeight(16);
        // 标题设置为粗体
        titleFont.setBold(true);
        titleStyle.setFont(titleFont);

        /** 表头样式 */
        XSSFCellStyle headerStyle = workbook.createCellStyle();
        headerStyle.cloneStyleFrom(titleStyle);
        // 填充类型
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        // 设置填充前景色
        headerStyle.setFillForegroundColor(IndexedColors.GREY_50_PERCENT.getIndex());
        // 设置表头字体
        XSSFFont headerFont = workbook.createFont();
        headerFont.setFontName(cellStyle.getFont().getFontName());
        headerFont.setBold(titleFont.getBold());
        headerFont.setColor(IndexedColors.WHITE.getIndex());
        headerStyle.setFont(headerFont);

        /** 创建标题样式、表格表头 */
        XSSFRow titleRow = sheet.createRow(0);
        XSSFRow headerRow = sheet.createRow(1);
        // 循环创建表头并赋值
        for (int i = 0; i < fields.size(); i++){
            Excel excel = fields.get(i).getAnnotation(Excel.class);
            XSSFCell cell = headerRow.createCell(i);
            cell.setCellValue(excel.value());
            cell.setCellStyle(headerStyle);
        }

        /** 绘制标题 */
        titleRow.setHeight((short) (26 * 20));
        XSSFCell titleCell = titleRow.createCell(0);
        titleCell.setCellValue(sheetTitle);
        titleCell.setCellStyle(titleStyle);

        // 添加合并区域
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, fields.size() - 1));
        return workbook;
    }


    /**
     * 获取实体类带有 @Excel 的属性
     * @param entity
     * @param type
     * @return
     */
    private static List<Field> getExcelList(Class<?> entity, ExcelType type){
        List<Field> list = new ArrayList<>();
        Field[] fields = entity.getDeclaredFields();
        for (Field field : fields){
            if (field.isAnnotationPresent(Excel.class)){
                ExcelType fieldType = field.getAnnotation(Excel.class).type();
                if (fieldType.equals(ExcelType.ALL) || field.equals(type)){
                    list.add(field);
                }
            }
        }
        return list;
    }

    /**
     * 获取实体类带有 @Excel 注解的字段名
     * @param fields
     * @return
     */
    private static List<String> getFieldName(List<Field> fields){
        List<String> list = new ArrayList<>();
        for (Field field :fields){
            list.add(field.getName());
        }
        return list;
    }

    /**
     * 下载操作
     * @param workbook
     * @param fileName
     */
    private static void download(XSSFWorkbook workbook, String fileName){
        try {
            fileName = URLEncoder.encode(fileName + ".xlsx", "utf-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        HttpServletResponse response = HttpServletUtil.getResponse();
        response.setCharacterEncoding("utf-8");
        response.setContentType("multipart/form-data");
        response.setHeader("Content-Disposition", "attachment;fileName=" + fileName);
        // OutputStream
    }
}
