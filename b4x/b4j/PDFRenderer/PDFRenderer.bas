B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.8
@EndOfDesignText@
Sub Class_Globals
	Private doc As JavaObject
	Private renderer As JavaObject
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(path As String)
	Dim PDDocument As JavaObject
	PDDocument.InitializeStatic("org.apache.pdfbox.pdmodel.PDDocument")
	Dim fileJO As JavaObject
	fileJO.InitializeNewInstance("java.io.File",Array(path))
	doc = PDDocument.RunMethod("load",Array(fileJO))
	renderer.InitializeNewInstance("org.apache.pdfbox.rendering.PDFRenderer",Array(doc))
End Sub

Public Sub Render(pageIndex As Int,scale As Float ,region As B4XRect) As ResumableSub
	Dim jo As JavaObject = Me
	Wait For (jo.RunMethod("loadPDFTileBitmap", Array(renderer,doc,pageIndex,scale,region))) pdfbitmap_loaded(Success As Boolean, Result As Object)
	Dim img As B4XBitmap = Result
	Return img
End Sub

Public Sub GetPageWidth(pageIndex As Int) As Int
	'document.getPage(pageNumber).getMediaBox().getHeight()
    Return GetMediaBox(pageIndex).RunMethod("getWidth",Null)	
End Sub

Public Sub GetPageHeight(pageIndex As Int) As Int
	'document.getPage(pageNumber).getMediaBox().getHeight()
    Return GetMediaBox(pageIndex).RunMethod("getHeight",Null)	
End Sub

Public Sub GetMediaBox(pageIndex As Int) As JavaObject
	Return doc.RunMethodJO("getPage",Array(pageIndex)).RunMethodJO("getMediaBox",Null)
End Sub

#if java
import anywheresoftware.b4a.objects.B4XViewWrapper;
import anywheresoftware.b4a.objects.B4XViewWrapper.*;
import javafx.scene.image.Image;
import anywheresoftware.b4a.objects.B4XCanvas.B4XRect;
import java.util.concurrent.Callable;
import javax.imageio.ImageIO;
import javax.imageio.ImageReadParam;
import javax.imageio.ImageReader;
import javax.imageio.stream.FileImageInputStream;
import java.awt.image.BufferedImage;
import java.io.File;
import javafx.scene.image.PixelWriter;
import javafx.scene.image.WritableImage;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.apache.pdfbox.util.Matrix;
import org.apache.pdfbox.rendering.ImageType;
import java.awt.*;

public Object loadPDFTileBitmap(PDFRenderer renderer, PDDocument document, int pageNumber, float scale, final B4XRect rect) {
	Object sender = new Object();
	BA.runAsync(getBA(), sender, "pdfbitmap_loaded", new Object[] {false, null}, 
		new Callable<Object[]>() {
			public Object[] call() throws Exception {
				// 设置要读取的区域
				// 定义要渲染的区域（PDF坐标，左下角为原点）
				float cropX = rect.getLeft();    // 左下角X
				float cropY = rect.getTop();    // 左下角Y
				float cropWidth = rect.getWidth();   // 区域宽度
				float cropHeight = rect.getHeight();  // 区域高度

				// 1. 创建目标图像（只创建需要的区域大小）
		        int regionWidth = (int) (cropWidth * scale);  // 裁剪区域宽度（像素）
		        int regionHeight = (int) (cropHeight * scale); // 裁剪区域高度（像素）
		        BufferedImage bufferedImage = new BufferedImage(
		            regionWidth, regionHeight, BufferedImage.TYPE_INT_ARGB
		        );
				
		        Graphics2D g2d = bufferedImage.createGraphics();
		        
		        
		        // 应用平移变换，使Graphics2D的原点对齐到裁剪区域
		        g2d.translate(-cropX * scale, -(document.getPage(pageNumber).getMediaBox().getHeight() - cropY - cropHeight) * scale);
		        //g2d.scale(scale, scale);
		        
		        // 4. 渲染页面到Graphics2D（只会绘制可见区域）
		        renderer.renderPageToGraphics(pageNumber, g2d, scale);
		        g2d.dispose();
				
				// 将BufferedImage转换为JavaFX的WritableImage
				WritableImage writableImage = new WritableImage(bufferedImage.getWidth(), bufferedImage.getHeight());
                javafx.embed.swing.SwingFXUtils.toFXImage(bufferedImage, writableImage);
				
				return new Object[] {true, writableImage};
			}
		}
	);
	return sender;
}

#End If