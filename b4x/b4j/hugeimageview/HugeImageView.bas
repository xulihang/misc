B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.45
@EndOfDesignText@
'Version 1.05 - 使用ImageReader优化内存
#Event: Click
Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Public mBase As B4XView
	Private xui As XUI 'ignore
	Public Tag As Object
	Public ZoomOutImageView As B4XView
	Private pnl As B4XView
	Public pnlBackground As B4XView
	Private IVOffsetX, IVOffsetY As Float
	Private ImageRatio As Float
	Private FullImage As B4XBitmap
	Private TilesCache As Map
	
	Private TouchDown As Boolean
	Private StartLeft, StartTop, StartX, StartY As Int
	Public ClickThreshold As Int = 200
	Private ClickStart As Long
	Private DisableClickEvent As Boolean 'ignore
	Type HugeTile (SrcRect As B4XRect, Image As B4XBitmap, ImageView As B4XView, Description As String, RSIndex As Int, Loading As Boolean)
	Private EmptyImage As B4XBitmap 'ignore
	Private Tiles As List
	Public ImageWidth, ImageHeight As Int
	Private TileSize = 500 As Int
	Private Const ZoomOutSize As Int = 1000dip
	Private DisplayScale As Float
	Private TilesThatNeedToBeFilled As List
	Private ImagePath As String '存储图片路径
	Private ImageFilename As String '存储图片文件名
	Private ImageReader As JavaObject 'ImageReader对象
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
	TilesThatNeedToBeFilled.Initialize
	Tiles.Initialize
	#if B4J
	TileSize = 2000
	#End If
	FillImages
	
End Sub

'Base type must be Object
Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	Tag = mBase.Tag
	mBase.Tag = Me
	pnlBackground = xui.CreatePanel("")
	mBase.SetColorAndBorder(mBase.Color, 0, 0, 0)
	Dim IV As ImageView
	IV.Initialize("")
	ZoomOutImageView = IV
	pnl = xui.CreatePanel("pnl")
	mBase.AddView(pnl, 0, 0, mBase.Width, mBase.Height)
	pnl.AddView(pnlBackground, 0, 0, mBase.Width, mBase.Height)
	pnlBackground.AddView(ZoomOutImageView, 0, 0, mBase.Width, mBase.Height)

	Dim jo As JavaObject = pnl
	Dim ScrollEvent As JavaObject = jo.CreateEventFromUI("javafx.event.EventHandler", "ScrollChanged", Null)
	jo.RunMethod("setOnScroll", Array(ScrollEvent))
	
End Sub


Private Sub ScrollChanged_Event (MethodName As String, Args() As Object) As Object
	If MethodName = "handle" Then
		Dim ev As JavaObject = Args(0)
		Dim delta As Float = ev.RunMethod("getDeltaY", Null)
		Dim Zoom As Float
		If delta > 0 Then
			Zoom = 1.1
		Else
			Zoom = 0.9
		End If
		ZoomChanged(ev.RunMethod("getX", Null), ev.RunMethod("getY", Null), Zoom)
	End If
	Return Null
End Sub

Public Sub SetSize(width As Double,height As Double)
	Log("set size")
	Log(width)
	Log(height)
	mBase.SetLayoutAnimated(0,mBase.Left,mBase.Top,width,height)
	pnl.SetLayoutAnimated(0,0,0,width,height)
	ZoomOutImageView.SetLayoutAnimated(0,0,0,width,height)
End Sub

Public Sub getWidth As Int
	Return mBase.Width
End Sub

Public Sub getHeight As Int
	Return mBase.Height
End Sub


Public Sub SetBitmap(Dir As String, Filename As String)
	'存储图片路径和文件名
	ImagePath = Dir
	ImageFilename = Filename
	
	'清理之前的资源
	If ImageReader.IsInitialized Then
		Try
			ImageReader.RunMethod("close", Null)
		Catch
			Log("关闭ImageReader时出错")
		End Try
	End If
	
	TilesThatNeedToBeFilled.Clear
	For Each Tile As HugeTile In Tiles
		Tile.ImageView.RemoveViewFromParent
		If Tile.Image.IsInitialized Then ClearImage(Tile)
	Next
	
	'使用ImageReader读取图片信息
	Try
		Dim f As JavaObject
		f.InitializeNewInstance("java.io.File", Array(Dir, Filename))
		
		'创建ImageReader
		Dim readers As JavaObject
		readers.InitializeStatic("javax.imageio.ImageIO")
		Dim suffix As String
		If Filename.EndsWith(".png") Then
			suffix = "png"
		Else
			suffix = "jpg"
		End If
		Dim iter As JavaObject = readers.RunMethodJO("getImageReadersBySuffix", Array(suffix))
		If iter.IsInitialized Then
			ImageReader = iter.RunMethod("next", Null)
			
			'设置输入源
			Dim input As JavaObject
			input.InitializeNewInstance("javax.imageio.stream.FileImageInputStream", Array(f))
			ImageReader.RunMethod("setInput", Array(input, True, True))
			
			'获取图片尺寸
			ImageWidth = ImageReader.RunMethod("getWidth", Array(0))
			ImageHeight = ImageReader.RunMethod("getHeight", Array(0))
			
			Log($"Image size: ${ImageWidth}x${ImageHeight}"$)
		Else
			'如果ImageReader失败，回退到原来的方法
			Log("无法创建ImageReader，使用传统方法")
			FullImage = xui.LoadBitmap(Dir, Filename)
			ImageWidth = FullImage.Width
			ImageHeight = FullImage.Height
		End If
	Catch
		Log($"Error setting up ImageReader: ${LastException}"$)
		'出错时回退到传统方法
		FullImage = xui.LoadBitmap(Dir, Filename)
		ImageWidth = FullImage.Width
		ImageHeight = FullImage.Height
	End Try
	
	ImageRatio = ImageWidth / ImageHeight
	TilesCache.Initialize
	
	'加载缩略图
	Dim thumb As B4XBitmap
	If FullImage.IsInitialized Then
		'thumb = xui.LoadBitmapResize(Dir, Filename, ZoomOutSize, ZoomOutSize, True)
		thumb = ResizeImageWithOpenCV(File.Combine(Dir,Filename))
	Else
		'如果FullImage不存在，单独加载缩略图
		'thumb = xui.LoadBitmapResize(Dir, Filename, ZoomOutSize, ZoomOutSize, True)
		thumb = ResizeImageWithOpenCV(File.Combine(Dir,Filename))
	End If
	XUIViewsUtils.SetBitmapAndFill(ZoomOutImageView, thumb)
	
	Tiles.Initialize
	CreateTiles
	
	Reset
	ZoomChanged(0, 0, 0)
End Sub

Private Sub ResizeImageWithOpenCV(path As String) As Image
	'Dim m As cvMat = cv2.imread(path)
	Dim width As Int = ZoomOutSize
	Dim height As Int = width/(ImageWidth/ImageHeight)
	Dim bytes() As Byte
	bytes=File.ReadBytes(path,"")
	Dim m As cvMat=cv2.bytesToMat2(bytes,"IMREAD_UNCHANGED")
	cv2.resize(m,m,cv2.size(width,height))
	Return BytesToImage(m.mat2bytesPNG)
End Sub


Public Sub BytesToImage(bytes() As Byte) As Image
	Dim In As InputStream
	In.InitializeFromBytesArray(bytes, 0, bytes.Length)
	Dim bmp As Image
	bmp.Initialize2(In)
	In.Close
	Return bmp
End Sub


Private Sub CreateTiles
	For x = 0 To ImageWidth - 1 Step TileSize
		For y = 0 To ImageHeight - 1 Step TileSize
			Dim tile As HugeTile
			tile.Initialize
			tile.SrcRect.Initialize(x, y, Min(ImageWidth, x + TileSize), Min(ImageHeight, y + TileSize))
			Dim iv As ImageView
			iv.Initialize("")
			tile.ImageView = iv
			tile.Description = $"(${x},${y})"$
			Tiles.Add(tile)
			pnlBackground.AddView(iv, 0, 0, 0, 0)
		Next
	Next
End Sub

Private Sub ZoomChanged (x As Int, y As Int, ZoomDelta As Float)
	Dim ivx As Float = x - pnlBackground.Left
	Dim ivy As Float = y - pnlBackground.Top
	ZoomDelta = Max(ZoomDelta, mBase.Width / pnlBackground.Width)
	Dim NewWidth As Int = Round(pnlBackground.Width * ZoomDelta)
	Dim NewHeight As Int = Round(pnlBackground.Height * ZoomDelta)
	DisplayScale = Max(ImageWidth / NewWidth, ImageHeight / NewHeight)
	pnlBackground.SetLayoutAnimated(0, x - Round(ivx * ZoomDelta), y - Round(ivy * ZoomDelta), NewWidth, NewHeight)
	SetImageViewLayout
End Sub

Private Sub SetImageViewLayout
	Dim ivleft As Int = pnlBackground.Width * IVOffsetX
	Dim ivtop As Int = pnlBackground.Height * IVOffsetY
	ZoomOutImageView.SetLayoutAnimated(0, ivleft, ivtop, pnlBackground.Width - 2 * ivleft, pnlBackground.Height - 2 * ivtop)
	Dim VisibleRect As B4XRect
	VisibleRect.Initialize((-pnlBackground.Left - ivleft) * DisplayScale, (-pnlBackground.Top - ivtop) * DisplayScale, 0, 0)
	VisibleRect.Width = mBase.Width * DisplayScale
	VisibleRect.Height = mBase.Height * DisplayScale
	Dim ShouldShowSmallTiles As Boolean = ZoomOutImageView.Width > ZoomOutSize * 2
	Dim CurrentTileSize As Int = Round(TileSize / DisplayScale)
	For Each Tile As HugeTile In Tiles
		If ShouldShowSmallTiles And IsIntersect(Tile.SrcRect, VisibleRect) Then
			Tile.ImageView.SetLayoutAnimated(0, ivleft + Tile.SrcRect.Left / TileSize * CurrentTileSize, ivtop + Tile.SrcRect.Top / TileSize * CurrentTileSize, _
				Tile.SrcRect.Width / TileSize * CurrentTileSize, Tile.SrcRect.Height / TileSize * CurrentTileSize)
			If Tile.Image.IsInitialized = False And Tile.Loading = False Then
				TilesThatNeedToBeFilled.Add(Tile)
				Tile.Loading = True
			End If
		Else
			Tile.RSIndex = Tile.RSIndex + 1
			Tile.ImageView.Visible = False
			Tile.Loading = False
			If Tile.Image.IsInitialized Then ClearImage(Tile)
		End If
	Next
End Sub

Private Sub ClearImage(Tile As HugeTile)
	Tile.ImageView.SetBitmap(Null)
	Tile.Image = EmptyImage
End Sub

Private Sub FillImages
	Do While True
		If TilesThatNeedToBeFilled.Size > 0 Then
			Dim Tile As HugeTile = TilesThatNeedToBeFilled.Get(0)
			TilesThatNeedToBeFilled.RemoveAt(0)
			If Tile.Loading = False Then Continue
			Dim r As B4XRect
			r.Initialize(Tile.SrcRect.Left, Tile.SrcRect.Top, Tile.SrcRect.Right, Tile.SrcRect.Bottom)
			Tile.RSIndex = Tile.RSIndex + 1
			Dim index As Int = Tile.RSIndex 'ignore
			
			If TilesCache.ContainsKey(Tile) = False Then
				'使用ImageReader加载图块
				Wait For (Me.As(JavaObject).RunMethod("loadTileBitmap", Array(ImagePath, ImageFilename, r))) bitmap_loaded(Success As Boolean, Result As Object)
				If Success = True Then
					TilesCache.Put(Tile, Result)
				End If
			Else
				Success = True
				Result = TilesCache.Get(Tile)
			End If

			If Tile.RSIndex = index Then
				Tile.Loading = False
				If Success Then
					'Log(Result)
					'writeimage(Result)
					Tile.Image = Result
					XUIViewsUtils.SetBitmapAndFill(Tile.ImageView, Tile.Image)
					Tile.ImageView.Visible = True
				End If
			End If
			
		End If
		Sleep(IIf(TilesThatNeedToBeFilled.Size > 0, 10, 100))
	Loop
End Sub

Private Sub writeimage(img As B4XBitmap)
	Dim out As OutputStream
	out = File.OpenOutput(File.DirApp,DateTime.Now&".jpg",False)
	img.WriteToStream(out,100,"JPEG")
	out.Close
End Sub

Private Sub IsIntersect(Rect1 As B4XRect, Rect2 As B4XRect) As Boolean
	If Rect1.Right < Rect2.Left Or Rect1.Left > Rect2.Right Or Rect1.Bottom < Rect2.Top Or Rect1.Top > Rect2.Bottom Then
		Return False
	Else
		Return True
	End If
End Sub

Private Sub Base_Resize (Width As Double, Height As Double)
	pnl.SetLayoutAnimated(0, 0, 0, Width, Height)
	Reset
End Sub

Private Sub Reset
	pnlBackground.SetLayoutAnimated(0, 0, 0, mBase.Width, mBase.Height)
	If ZoomOutImageView.GetBitmap.IsInitialized Then
		Dim ContainerWidth As Int = mBase.Width
		Dim ContainerHeight As Int = mBase.Height
		Dim ivr As Float = ContainerWidth / ContainerHeight
		If ImageRatio > ivr Then
			IVOffsetX = 0
			IVOffsetY = (ContainerHeight - 1 / ImageRatio * ContainerWidth) / 2 / ContainerHeight
		Else
			IVOffsetY = 0
			IVOffsetX = (ContainerWidth - ImageRatio * ContainerHeight) / 2 / ContainerWidth
		End If
		Dim left As Int = pnlBackground.Width * IVOffsetX
		Dim top As Int = pnlBackground.Height * IVOffsetY
		ZoomOutImageView.SetLayoutAnimated(0, left, top, pnlBackground.Width - 2 * left, pnlBackground.Height - 2 * top)
	Else
		ZoomOutImageView.SetLayoutAnimated(0, 0, 0, mBase.Width, mBase.Width)
	End If
End Sub

Private Sub pnl_Touch (Action As Int, X1 As Float, Y1 As Float)
	If Action = pnl.TOUCH_ACTION_DOWN Or TouchDown = False Then
		StartLeft = pnlBackground.Left
		StartTop = pnlBackground.Top
		StartX = X1
		StartY = Y1
		TouchDown = True
		If xui.IsB4A = False Then ClickStart = DateTime.Now
	Else If Action = pnl.TOUCH_ACTION_MOVE And TouchDown Then
		pnlBackground.Left = Min(0.5 * mBase.Width, StartLeft + 1.2 * (X1 - StartX))
		pnlBackground.Left = Max(-(pnlBackground.Width - 0.5 * mBase.Width), pnlBackground.Left)
		pnlBackground.Top = Min(0.5 * mBase.Height, StartTop + 1.2 * (Y1 - StartY))
		pnlBackground.Top = Max(-(pnlBackground.Height - 0.5 * mBase.Height), pnlBackground.Top)
		SetImageViewLayout
	Else if Action = pnl.TOUCH_ACTION_UP Then
		TouchDown = False
		If DateTime.Now - ClickStart < ClickThreshold And DisableClickEvent = False Then
			If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
				CallSub(mCallBack, mEventName & "_Click")
			End If
		End If
	Else
		'Log("touch cancelled")
	End If
End Sub

Public Sub Close
	'清理资源
	If ImageReader.IsInitialized Then
		Try
			ImageReader.RunMethod("close", Null)
		Catch
			Log("关闭ImageReader时出错")
		End Try
	End If
End Sub

#if Java
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

public Object loadTileBitmap(final String dir, final String filename, final B4XRect rect) {
	Object sender = new Object();
	BA.runAsync(getBA(), sender, "bitmap_loaded", new Object[] {false, null}, 
		new Callable<Object[]>() {
			public Object[] call() throws Exception {
				try {
					// 使用ImageReader读取图片的指定区域
					File file = new File(dir, filename);
					ImageReader reader = null;
					FileImageInputStream input = null;
					
					try {
						// 获取适合该文件的ImageReader
						// 根据文件扩展名判断文件类型
						String extension = "";
						if (filename.toLowerCase().endsWith(".jpg") || filename.toLowerCase().endsWith(".jpeg")) {
							extension = "jpg";
						} else if (filename.toLowerCase().endsWith(".png")) {
							extension = "png";
						} else if (filename.toLowerCase().endsWith(".gif")) {
							extension = "gif";
						} else if (filename.toLowerCase().endsWith(".bmp")) {
							extension = "bmp";
						} else if (filename.toLowerCase().endsWith(".tif") || filename.toLowerCase().endsWith(".tiff")) {
							extension = "tiff";
						}
						extension = "jpg";
						java.util.Iterator<ImageReader> iter = ImageIO.getImageReadersBySuffix(extension);
						if (!iter.hasNext()) {
							iter = ImageIO.getImageReadersBySuffix("jpeg");
						}
						if (!iter.hasNext()) {
							iter = ImageIO.getImageReadersBySuffix("png");
						}
						if (!iter.hasNext()) {
							iter = ImageIO.getImageReaders(file);
						}
						
						if (iter.hasNext()) {
							reader = iter.next();
							input = new FileImageInputStream(file);
							reader.setInput(input, true, true);
							
							// 设置要读取的区域
							ImageReadParam param = reader.getDefaultReadParam();
							java.awt.Rectangle sourceRegion = new java.awt.Rectangle(
								(int)rect.getLeft(), 
								(int)rect.getTop(), 
								(int)rect.getWidth(), 
								(int)rect.getHeight()
							);
							param.setSourceRegion(sourceRegion);
							
							// 读取指定区域
							BufferedImage bufferedImage = reader.read(0, param);
							
							// 将BufferedImage转换为JavaFX的WritableImage
							WritableImage writableImage = new WritableImage(bufferedImage.getWidth(), bufferedImage.getHeight());
							PixelWriter pixelWriter = writableImage.getPixelWriter();
							
							for (int y = 0; y < bufferedImage.getHeight(); y++) {
								for (int x = 0; x < bufferedImage.getWidth(); x++) {
									int argb = bufferedImage.getRGB(x, y);
									int a = (argb >> 24) & 0xFF;
									int r = (argb >> 16) & 0xFF;
									int g = (argb >> 8) & 0xFF;
									int b = argb & 0xFF;
									javafx.scene.paint.Color color = javafx.scene.paint.Color.rgb(r, g, b, a / 255.0);
									pixelWriter.setColor(x, y, color);
								}
							}
							
							// 转换为B4XBitmapWrapper
							//B4XBitmapWrapper bw = new B4XBitmapWrapper();
							//bw.setObject(writableImage);
							
							return new Object[] {true, writableImage};
						} else {
							// 如果没有找到合适的ImageReader，回退到传统方法
							throw new Exception("No suitable ImageReader found");
						}
					} finally {
						// 清理资源
						if (reader != null) {
							try {
								reader.dispose();
							} catch (Exception e) {}
						}
						if (input != null) {
							try {
								input.close();
							} catch (Exception e) {}
						}
					}
				} catch (Exception e) {
					// 如果ImageReader失败，回退到传统方法
					try {
						// 回退方法：加载完整图片然后裁剪
						B4XBitmapWrapper bw = new B4XBitmapWrapper();
						Image fullImage = new Image("file:" + dir + "/" + filename);
						bw.setObject(fullImage);
						return new Object[] {true, bw.Crop((int)rect.getLeft(), (int)rect.getTop(), (int)rect.getWidth(), (int)rect.getHeight()).getObject()};
					} catch (Exception e2) {
						BA.Log("Error loading tile: " + e2.getMessage());
						throw e2;
					}
				}
			}
		}
	);
	return sender;
}

#End If