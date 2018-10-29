
package b4j.example;

import anywheresoftware.b4a.pc.PCBA;
import anywheresoftware.b4a.pc.RemoteObject;

public class xml2map {
    public static RemoteObject myClass;
	public xml2map() {
	}
    public static PCBA staticBA = new PCBA(null, xml2map.class);

public static RemoteObject __c = RemoteObject.declareNull("anywheresoftware.b4a.keywords.Common");
public static RemoteObject _parser = RemoteObject.declareNull("anywheresoftware.b4a.objects.SaxParser");
public static RemoteObject _elements = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
public static b4j.example.main _main = null;
public static b4j.example.srx _srx = null;
public static b4j.example.utils _utils = null;
public static Object[] GetGlobals(RemoteObject _ref) throws Exception {
		return new Object[] {"elements",_ref.getField(false, "_elements"),"parser",_ref.getField(false, "_parser")};
}
}