module opengl.loader;

private alias Identity(T...) = T;

// XXX: Just copied instead of using actual import
private enum OGLIntroducedIn : ushort {
	Unknown,
	V1P0 = 10,
	V1P1 = 11,
	V1P2 = 12,
	V1P3 = 13,
	V1P4 = 14,
	V1P5 = 15,
	V2P0 = 25,
	V2P1 = 21,
	V2P2 = 22,
	V3P0 = 30,
	V3P1 = 31,
	V3P2 = 32,
	V3P3 = 33,
	V4P0 = 40,
	V4P1 = 41,
	V4P2 = 42,
	V4P3 = 43,
	V4P4 = 44,
	V4P5 = 45,
}

version (Windows)
{
	extern(Windows) private void* wglGetProcAddress(const(char)*) @system @nogc nothrow;
	private alias getProcAddress = wglGetProcAddress;
}
else version (OSX)
	static assert(false, "Use static bindings instead of dynamic ones on OSX (opengl:gl4-static)");
else
{
	extern(C) private void* glXGetProcAddressARB(const(char)*) @system @nogc nothrow;
	private alias getProcAddress = glXGetProcAddressARB;
}

private bool needsProcAddress(alias T)()
{
	import std.traits : isFunctionPointer;
	return isFunctionPointer!T;
}

void loadGL(alias module_, ushort upTo = OGLIntroducedIn.V4P5, alias missingFunctionCallback = null)() @system @nogc nothrow
{
	foreach (memberName; __traits(allMembers, module_))
	{
		alias member = Identity!(__traits(getMember, module_, memberName));
		static if (is(typeof(member)) && needsProcAddress!member && __traits(compiles, __traits(getAttributes, member)))
		{
			alias UDAs = Identity!(__traits(getAttributes, member));
			static if (UDAs.length >= 1 && typeof(UDAs[0]).stringof == "OpenGL_Version" && cast(ushort)UDAs[0].from <= upTo
				|| UDAs.length >= 2 && typeof(UDAs[1]).stringof == "OpenGL_Version" && cast(ushort)UDAs[1].from <= upTo)
			{
				member[0] = cast(typeof(member[0])) getProcAddress((memberName ~ 0).ptr);
			}
		}
	}
}