
package b4j.example;

import anywheresoftware.b4a.pc.PCBA;
import anywheresoftware.b4a.pc.RemoteObject;

public class map2xml {
    public static RemoteObject myClass;
	public map2xml() {
	}
    public static PCBA staticBA = new PCBA(null, map2xml.class);

public static RemoteObject __c = RemoteObject.declareNull("anywheresoftware.b4a.keywords.Common");
public static RemoteObject _builder = RemoteObject.declareNull("com.jamesmurty.utils.XMLBuilder");
public static b4j.example.main _main = null;
public static b4j.example.srx _srx = null;
public static b4j.example.utils _utils = null;
public static Object[] GetGlobals(RemoteObject _ref) throws Exception {
		return new Object[] {"builder",_ref.getField(false, "_builder")};
}
}