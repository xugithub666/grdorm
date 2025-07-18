package cn.xxh.poi;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.HSSFColor;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Description:通用Excel输入流
 *
 */
public class WriteExcel {
    //下载表的列名
    private String[] rowName;
    //每行作为一个Object对象
    private List<Object[]>  dataList = new ArrayList<Object[]>();

    //构造方法，传入要下载的数据:第一个参数传入一个列名数组，第二个参数传入一个list集合（Object对象数组）
    public WriteExcel(String[] rowName,List<Object[]>  dataList){
        this.dataList = dataList;
        this.rowName = rowName;
    }

    /*
     * 下载数据
     * */
    public InputStream export() throws Exception{
        HSSFWorkbook workbook = new HSSFWorkbook();						// 创建工作簿对象
        HSSFSheet sheet = workbook.createSheet("sheet1");		// 创建工作表

        // 设置sheet表样式
        HSSFCellStyle columnTopStyle = this.getColumnTopStyle(workbook);//获取列头样式对象
        HSSFCellStyle style = this.getColumnStyle(workbook);			//单元格样式对象

        // 定义所需列数
        int columnNum = rowName.length;
        HSSFRow rowRowName = sheet.createRow(0);				// 在索引2的位置创建行(最顶端的行开始的第二行)

        // 将列头设置到sheet的单元格中
        for(int n=0;n<columnNum;n++){
            HSSFCell cellRowName = rowRowName.createCell(n);				//创建列头对应个数的单元格
            cellRowName.setCellType(HSSFCell.CELL_TYPE_STRING);				//设置列头单元格的数据类型
            HSSFRichTextString text = new HSSFRichTextString(rowName[n]);
            cellRowName.setCellValue(text);									//设置列头单元格的值
            cellRowName.setCellStyle(columnTopStyle);						//设置列头单元格样式
        }

        //将查询出的数据设置到sheet对应的单元格中
        for(int i=0;i<dataList.size();i++){

            Object[] obj = dataList.get(i);                                 //遍历每个对象
            HSSFRow row = sheet.createRow(i+1);                     //创建所需的行数
            for(int j=0; j<obj.length; j++){
                HSSFCell  cell = null;   //设置单元格的数据类型
                cell = row.createCell(j,HSSFCell.CELL_TYPE_STRING);
                // 处理 null 和空字符串
                if (obj[j] != null && !"".equals(obj[j].toString().trim())) {
                    cell.setCellValue(obj[j].toString());					//设置单元格的值
                } else {
                    cell.setCellValue(""); // 如果为 null 或空字符串，设置为空值
                }
                cell.setCellStyle(style);									//设置单元格样式
            }
        }
        //让列宽随着下载的列长自动适应
        for (int colNum = 0; colNum < columnNum; colNum++) {
            int columnWidth = sheet.getColumnWidth(colNum) / 256;
            for (int rowNum = 0; rowNum < sheet.getLastRowNum(); rowNum++) {
                HSSFRow currentRow;
                //如若当前行未被使用过，则新建一行
                if (sheet.getRow(rowNum) == null) {
                    currentRow = sheet.createRow(rowNum);
                } else {
                    currentRow = sheet.getRow(rowNum);
                }
                if (currentRow.getCell(colNum) != null) {
                    HSSFCell currentCell = currentRow.getCell(colNum);
                    if (currentCell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
                        int length = currentCell.getStringCellValue().getBytes().length;
                        if (columnWidth < length) {
                            columnWidth = length;
                        }
                    }
                }
            }
            if(colNum == 0){
                sheet.setColumnWidth(colNum, (columnWidth-2) * 256);
            }else{
                sheet.setColumnWidth(colNum, (columnWidth+4) * 256);
            }
        }

        String fileName = "Excel-" + String.valueOf(System.currentTimeMillis()).substring(4, 13) + ".xls";
        String headStr = "attachment; filename=\"" + fileName + "\"";
        ByteArrayOutputStream os=new ByteArrayOutputStream();
        try {
            workbook.write(os);
        } catch (IOException e) {
            e.printStackTrace();
        }

        byte[] content=os.toByteArray();
        InputStream is=new ByteArrayInputStream(content);
        return is;
    }

    /*
     * 列头单元格样式
     */
    public HSSFCellStyle getColumnTopStyle(HSSFWorkbook workbook) {

        // 设置字体
        HSSFFont font = workbook.createFont();
        //设置字体大小
        font.setFontHeightInPoints((short)11);
        //字体加粗
        font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        //设置字体名字
        font.setFontName("Courier New");
        //设置样式;
        HSSFCellStyle style = workbook.createCellStyle();
        //设置底边框;
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        //设置底边框颜色;
        style.setBottomBorderColor(HSSFColor.BLACK.index);
        //设置左边框;
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        //设置左边框颜色;
        style.setLeftBorderColor(HSSFColor.BLACK.index);
        //设置右边框;
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        //设置右边框颜色;
        style.setRightBorderColor(HSSFColor.BLACK.index);
        //设置顶边框;
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        //设置顶边框颜色;
        style.setTopBorderColor(HSSFColor.BLACK.index);
        //在样式用应用设置的字体;
        style.setFont(font);
        //设置自动换行;
        style.setWrapText(false);
        //设置水平对齐的样式为居中对齐;
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        //设置垂直对齐的样式为居中对齐;
        style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

        return style;

    }

    /*
     * 列信息单元格样式
     */
    public HSSFCellStyle getColumnStyle(HSSFWorkbook workbook) {
        // 设置字体
        HSSFFont font = workbook.createFont();
        //设置字体名字
        font.setFontName("Courier New");
        //设置样式;
        HSSFCellStyle style = workbook.createCellStyle();
        //设置底边框;
        style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
        //设置底边框颜色;
        style.setBottomBorderColor(HSSFColor.BLACK.index);
        //设置左边框;
        style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
        //设置左边框颜色;
        style.setLeftBorderColor(HSSFColor.BLACK.index);
        //设置右边框;
        style.setBorderRight(HSSFCellStyle.BORDER_THIN);
        //设置右边框颜色;
        style.setRightBorderColor(HSSFColor.BLACK.index);
        //设置顶边框;
        style.setBorderTop(HSSFCellStyle.BORDER_THIN);
        //设置顶边框颜色;
        style.setTopBorderColor(HSSFColor.BLACK.index);
        //在样式用应用设置的字体;
        style.setFont(font);
        //设置自动换行;
        style.setWrapText(false);
        //设置水平对齐的样式为居中对齐;
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
        //设置垂直对齐的样式为居中对齐;
        style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);

        return style;
    }
}    