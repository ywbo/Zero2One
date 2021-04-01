package com.agu.component.excel;

import java.beans.BeanInfo;
import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import com.agu.common.utils.EhcacheUtil;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.openxml4j.util.ZipSecureFile;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.util.StringUtils;

import com.agu.common.utils.HttpServletUtil;
import com.agu.component.excel.annotation.Excel;
import com.agu.component.excel.enums.ExcelType;

import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.lang.Assert;
import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;

/**
 *  Excel 工具类
 *
 * @author yuwenbo
 * @since 2021-03-17
 */
public class ExcelUtil {

    private static int dataRow = 2;
    private static Cache dictCache = EhcacheUtil.getDictCache();

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
         OutputStream opt = null;
        try {
            opt = response.getOutputStream();
            workbook.write(opt);
            opt.flush();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (opt != null){
                try {
                    opt.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (workbook != null){
                try {
                    workbook.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * 获取 Excel 模板
     * @param entity 实体类 class
     */
    public static void getTemplete(Class<?> entity){
        Excel excel = entity.getAnnotation(Excel.class);
        if (excel != null) {
            getTemplete(entity, excel.value());
        } else {
            getTemplete(entity, entity.getSimpleName());
        }
    }

    /**
     * 获取 Excel 模板
     * @param entity 实体类 class
     * @param sheetTitle 工作组标题（文件名称）
     */
    public static void getTemplete(Class<?> entity, String sheetTitle){
        XSSFWorkbook workbook = getCommon(sheetTitle, getExcelList(entity, ExcelType.IMPORT));
        download(workbook, sheetTitle + "模板");
    }

    /**
     * 导出 Excel
     * @param entity 实体类 class
     * @param list 导出的数据列表
     * @param <T>
     */
    public static<T> void exportExcel(Class<?> entity, List<T> list){
        Excel excel = entity.getAnnotation(Excel.class);
        if (excel != null){
            exportExcel(entity, list, excel.value());
        } else {
            exportExcel(entity, list, entity.getSimpleName());
        }
    }


    /**
     * 导出 Excel
     * @param entity
     * @param list
     * @param sheetTitle
     */
    public static<T> void exportExcel(Class<?> entity, List<T> list, String sheetTitle){
        List<Field> fields = getExcelList(entity, ExcelType.EXPORT);
        List<String> fileNames = getFieldName(fields);

        XSSFWorkbook workbook = getCommon(sheetTitle, fields);
        XSSFSheet sheet = workbook.getSheet(sheetTitle);
        XSSFCellStyle cellStyle = getCellStyle(workbook);

        // 时间样式
        XSSFCellStyle dateStyle = workbook.createCellStyle();
        dateStyle.cloneStyleFrom(cellStyle);
        XSSFDataFormat format = workbook.createDataFormat();
        dateStyle.setDataFormat(format.getFormat("yyyy-MM-dd HH:mm:ss"));

        for (int i = 0; i < list.size(); i++){
            XSSFRow row = sheet.getRow(i + dataRow);
            T item = list.get(i);

            // 通过反射机制获取实体对象
            try {
                final BeanInfo bi = Introspector.getBeanInfo(item.getClass());
                for (final PropertyDescriptor pd : bi.getPropertyDescriptors()){
                    if (fileNames.contains(pd.getName())){
                        Object value =  pd.getReadMethod().invoke(item, (Object[]) null);
                        int index = fileNames.indexOf(pd.getName());
                        XSSFCell cell = row.createCell(index);
                        if (value != null){
                            Excel excel = fields.get(index).getAnnotation(Excel.class);
                            // 字典值转换
                            String dict = excel.dict();
                            if (!dict.isEmpty()){
                                Element dictEle = dictCache.get(dict);
                                if (dictEle != null){
                                    Map<String, String> dictValue = (Map<String, String>) dictEle.getObjectValue();
                                    value = dictValue.get(String.valueOf(value));
                                }
                            }

                            //获取关联对象指定的值
                            String joinField = excel.joinField();
                            if (!joinField.isEmpty()){
                                PropertyDescriptor sourcePd = BeanUtil.getPropertyDescriptor(value.getClass(), joinField);
                                value = sourcePd.getReadMethod().invoke(value, (Object[]) null);
                            }

                            // 给单元格赋值
                            if (value instanceof Number){
                                // 如果是 number
                                cell.setCellValue(Double.valueOf(String.valueOf(value)));
                            } else if (value instanceof Date){
                                // 如果是 Date
                                cell.setCellValue((Date) value);
                                cell.setCellStyle(dateStyle);
                                continue;
                            } else {
                                // 如果是其他
                                cell.setCellValue((String) value);
                            }
                        }
                        cell.setCellStyle(cellStyle);
                    }
                }
            } catch (IntrospectionException | IllegalAccessException | InvocationTargetException e) {
                String message = "导入失败：字段名称匹配失败！";
                throw new IllegalArgumentException(message, e);
            }
        }
        // 格式化日期
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        download(workbook, sheetTitle + dateFormat.format(new Date()));
    }


    /**
     * 读取 Excel 文件数据
     * @param entity 实体类
     * @param inputStream Excel文件输入流
     * @param <T>
     * @return 返回数据集合
     */
    public static  <T> List<T> inportExcel(Class<T> entity, InputStream inputStream){
        List<T> list = new ArrayList<>();
        List<String> fieldNames = getFieldName(getExcelList(entity, ExcelType.IMPORT));

        // 读取 Excel 文件
        XSSFWorkbook workbook = null;
        try {
            ZipSecureFile.setMinInflateRatio(-1.0d);
            workbook = new XSSFWorkbook(inputStream);
        } catch (IOException e) {
            e.printStackTrace();
        }
        Assert.notNull(workbook, "读取Excel文件失败，请检查文件！");
        XSSFSheet sheet = workbook.getSheetAt(0);
        Assert.notNull(sheet, "该Excel文件没有工作区，无法读取数据！");
        int count = 0;
        for (Row row : sheet) {
            // 通过非数据行
            if (count < dataRow) {
                count++;
                continue;
            }

            //读取当前数据行
            int end = row.getLastCellNum();
            String[] rowData = new String[end];
            for (int i = 0; i < end; i++) {
                Cell cell = row.getCell(i);
                if (cell != null) {
                    if (cell.getCellType() == CellType.NUMERIC && HSSFDateUtil.isCellDateFormatted(cell)) {
                        Date date = cell.getDateCellValue();
                        rowData[i] = String.valueOf(date.getTime());
                    } else {
                        // 强制其他类型为String字符串类型
                        cell.setCellType(CellType.STRING);
                        rowData[i] = cell.getStringCellValue();
                    }
                } else {
                    rowData[i] = null;
                }
            }

            // 将数据加载到数据列表中
            try {
                T newInstance = entity.newInstance();
                final BeanInfo bi = Introspector.getBeanInfo(entity);
                for (final PropertyDescriptor pd : bi.getPropertyDescriptors()) {
                    if (fieldNames.contains(pd.getName())) {
                        Method writeMethod = pd.getWriteMethod();
                        if (writeMethod != null) {
                            if (!Modifier.isPublic(writeMethod.getDeclaringClass().getModifiers())) {
                                writeMethod.setAccessible(true);
                            }
                            String value = rowData[fieldNames.indexOf(pd.getName())];
                            if(!StringUtils.isEmpty(value)){
                                Class<?> propertyType = pd.getPropertyType();
                                if (String.class == propertyType){
                                    writeMethod.invoke(newInstance, value);
                                }else if(Integer.class == propertyType){
                                    writeMethod.invoke(newInstance, Integer.valueOf(value));
                                }else if(Long.class == propertyType){
                                    writeMethod.invoke(newInstance, Double.valueOf(value).longValue());
                                }else if(Float.class == propertyType){
                                    writeMethod.invoke(newInstance, Float.valueOf(value));
                                }else if(Short.class == propertyType){
                                    writeMethod.invoke(newInstance, Short.valueOf(value));
                                }else if(Double.class == propertyType){
                                    writeMethod.invoke(newInstance, Double.valueOf(value));
                                }else if(Character.class == propertyType){
                                    if ((value != null) && (value.length() > 0)){
                                        writeMethod.invoke(newInstance, Character.valueOf(value.charAt(0)));
                                    }
                                }else if(Date.class == propertyType){
                                    writeMethod.invoke(newInstance, new Date(Long.parseLong(value)));
                                }else if(BigDecimal.class == propertyType){
                                    writeMethod.invoke(newInstance, new BigDecimal(value));
                                }
                            }

                        }
                    }
                }
                list.add(newInstance);
            } catch (InvocationTargetException | IntrospectionException | IllegalAccessException e) {
                String message = "导入失败：字段名称匹配失败！";
                throw new IllegalArgumentException(message, e);
            } catch (InstantiationException e) {
                e.printStackTrace();
            }
        }

        return list;
    }
}
