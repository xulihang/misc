B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=6.51
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private frm As Form
	Private WebView1 As WebView
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	frm.Initialize("frm",600,300)
	frm.RootPane.LoadLayout("dictWebview")
	frm.AlwaysOnTop=True
End Sub

Public Sub show
	frm.Show
End Sub

Public Sub loadUrl(url As String)
	WebView1.LoadUrl(url)
End Sub


Sub WebView1_PageFinished (Url As String)
	Dim we As JavaObject
	we = asJO(WebView1).RunMethod("getEngine",Null)
	asJO(Me).RunMethod("setBridge",Array(we))
	
	Dim jscode As String
	jscode=$"document.onselectionchange=function(){
	b4j.link2("test",getSelection(document.getSelection()+""));}"$
	we.RunMethod("executeScript",Array As String(jscode))
	
End Sub

Sub WebView1_LocationChanged (Location As String)
	Log(Location)
End Sub

Sub asJO(o As JavaObject) As JavaObject
	Return o
End Sub




#if java
import netscape.javascript.JSObject;
import javafx.scene.web.WebEngine;
import java.lang.RuntimeException;
import java.lang.IllegalAccessException;
import java.lang.reflect.InvocationTargetException;

import java.lang.Enum;
import java.lang.reflect.Method;
import javafx.application.Platform;
 
 
public static class Bridge{
    
    public void link2(String sub,String arg) { // for call with  1 param
		boolean isInt = false;
		int ti = 0;
		try{
			Class<?> c = Class.forName("b4j.example.dictwebview");
			final Method m = c.getDeclaredMethod("_" + sub.toLowerCase(),String.class);
			final Object dummy = null;
			final Object xarg = arg;
			Platform.runLater(new Runnable(){
				public void run(){
					try{
						m.invoke(dummy,xarg);
					}catch (IllegalAccessException e){
						System.out.println(e);
				    }catch (InvocationTargetException ite){
					}
				}
			});
		} catch (Exception e){
			System.out.println(e);
	    }
	}

}
public static void setBridge(WebEngine we){
	JSObject jsobj = (JSObject) we.executeScript("window");
	Bridge b = new Bridge();
	jsobj.setMember("b4j", b);
}
#end if