/// High level OpenGL D wrapper
module opengl.d;

public
{
	import opengl.d.buffer;
	import opengl.d.program;
	import opengl.d.shader;
	import opengl.d.vertexarray;
}

import opengl.gl4;

/// Generates a static OpenGL boolean property (glEnable/glDisable)
mixin template glBoolProperty(GLenum value, string name)
{
	static bool enabled()
	{
		return glIsEnabled(value);
	}

	static bool enabled(bool val)
	{
		if (val)
			glEnable(value);
		else
			glDisable(value);
		return val;
	}
}

/// Wrapper "namespace" containing properties and stateless functions
struct GL
{
	@disable this();

@nogc @system:

	@property nothrow
	{
		mixin glBoolProperty!(GL_BLEND, "Blend") blend;
		alias enableBlend = blend.enabled; ///
		mixin glBoolProperty!(GL_COLOR_LOGIC_OP, "ColorLogicOperation") colorLogicOperation;
		alias enableColorLogicOperation = colorLogicOperation.enabled; ///
		mixin glBoolProperty!(GL_CULL_FACE, "CullFace") cullFace;
		alias enableCullFace = cullFace.enabled; ///
		mixin glBoolProperty!(GL_DEBUG_OUTPUT, "DebugOutput") debugOutput;
		alias enableDebugOutput = debugOutput.enabled; ///
		mixin glBoolProperty!(GL_DEBUG_OUTPUT_SYNCHRONOUS, "DebugOutputSync") debugOutputSync;
		alias enableDebugOutputSync = debugOutputSync.enabled; ///
		mixin glBoolProperty!(GL_DEPTH_CLAMP, "DepthClamp") depthClamp;
		alias enableDepthClamp = depthClamp.enabled; ///
		mixin glBoolProperty!(GL_DEPTH_TEST, "DepthTest") depthTest;
		alias enableDepthTest = depthTest.enabled; ///
		mixin glBoolProperty!(GL_DITHER, "Dither") dither;
		alias enableDither = dither.enabled; ///
		mixin glBoolProperty!(GL_FRAMEBUFFER_SRGB, "FramebufferSRGB") framebufferSRGB;
		alias enableFramebufferSRGB = framebufferSRGB.enabled; ///
		mixin glBoolProperty!(GL_LINE_SMOOTH, "LineSmooth") lineSmooth;
		alias enableLineSmooth = lineSmooth.enabled; ///
		mixin glBoolProperty!(GL_MULTISAMPLE, "Multisample") multisample;
		alias enableMultisample = multisample.enabled; ///
		mixin glBoolProperty!(GL_POLYGON_OFFSET_FILL, "PolygonOffsetFill") polygonOffsetFill;
		alias enablePolygonOffsetFill = polygonOffsetFill.enabled; ///
		mixin glBoolProperty!(GL_POLYGON_OFFSET_LINE, "PolygonOffsetLine") polygonOffsetLine;
		alias enablePolygonOffsetLine = polygonOffsetLine.enabled; ///
		mixin glBoolProperty!(GL_POLYGON_OFFSET_POINT, "PolygonOffsetPoint") polygonOffsetPoint;
		alias enablePolygonOffsetPoint = polygonOffsetPoint.enabled; ///
		mixin glBoolProperty!(GL_POLYGON_SMOOTH, "PolygonSmooth") polygonSmooth;
		alias enablePolygonSmooth = polygonSmooth.enabled; ///
		mixin glBoolProperty!(GL_PRIMITIVE_RESTART, "PrimitiveRestart") primitiveRestart;
		alias enablePrimitiveRestart = primitiveRestart.enabled; ///
		mixin glBoolProperty!(GL_PRIMITIVE_RESTART_FIXED_INDEX, "PrimitiveRestartFixedIndex") primitiveRestartFixedIndex;
		alias enablePrimitiveRestartFixedIndex = primitiveRestartFixedIndex.enabled; ///
		mixin glBoolProperty!(GL_RASTERIZER_DISCARD, "RasterizerDiscard") rasterizerDiscard;
		alias enableRasterizerDiscard = rasterizerDiscard.enabled; ///
		mixin glBoolProperty!(GL_SAMPLE_ALPHA_TO_COVERAGE, "SampleAlphaToCoverage") sampleAlphaToCoverage;
		alias enableSampleAlphaToCoverage = sampleAlphaToCoverage.enabled; ///
		mixin glBoolProperty!(GL_SAMPLE_ALPHA_TO_ONE, "SampleAlphaToOne") sampleAlphaToOne;
		alias enableSampleAlphaToOne = sampleAlphaToOne.enabled; ///
		mixin glBoolProperty!(GL_SAMPLE_COVERAGE, "SampleCoverage") bSampleCoverage;
		alias enableSampleCoverage = bSampleCoverage.enabled; ///
		mixin glBoolProperty!(GL_SAMPLE_SHADING, "SampleShading") sampleShading;
		alias enableSampleShading = sampleShading.enabled; ///
		mixin glBoolProperty!(GL_SCISSOR_TEST, "ScissorTest") scissorTest;
		alias enableScissorTest = scissorTest.enabled; ///
		mixin glBoolProperty!(GL_STENCIL_TEST, "StencilTest") stencilTest;
		alias enableStencilTest = stencilTest.enabled; ///
		mixin glBoolProperty!(GL_TEXTURE_CUBE_MAP_SEAMLESS, "TextureCubeMapSeamless") textureCubeMapSeamless;
		alias enableTextureCubeMapSeamless = textureCubeMapSeamless.enabled; ///
		mixin glBoolProperty!(GL_PROGRAM_POINT_SIZE, "ProgramPointSize") programPointSize;
		alias enableProgramPointSize = programPointSize.enabled; ///

		/// Returns the current cull face mode.
		static CullFaceMode cullFaceMode()
		{
			int mode;
			glGetIntegerv(GL_CULL_FACE_MODE, &mode);
			return cast(CullFaceMode) mode;
		}
		/// Sets the current cull face mode.
		static CullFaceMode cullFaceMode(CullFaceMode val)
		{
			glCullFace(val);
			return val;
		}

		/// Returns the direction of front faces.
		static FrontFaceDirection frontFace()
		{
			int dir;
			glGetIntegerv(GL_FRONT_FACE, &dir);
			return cast(FrontFaceDirection) dir;
		}
		/// Changes the front face direction.
		static FrontFaceDirection frontFace(FrontFaceDirection val)
		{
			glFrontFace(val);
			return val;
		}

		/// Sets a callback for debug messages
		static DebugMessageCallback debugMessageCallback(DebugMessageCallback cb)
		{
			void* param = wrapDebugCallback(cb);
			glDebugMessageCallback(&debugMessageCallbackWrapper, param);
			return cb;
		}

		/// Returns the current depth function.
		static DepthFunction depthFunc()
		{
			int func;
			glGetIntegerv(GL_DEPTH_FUNC, &func);
			return cast(DepthFunction) func;
		}
		/// Changes the current depth function.
		static DepthFunction depthFunc(DepthFunction val)
		{
			glDepthFunc(val);
			return val;
		}

		/// Returns the current line width.
		static float lineWidth()
		{
			float width;
			glGetFloatv(GL_LINE_WIDTH, &width);
			return width;
		}
		/// Changes the current line width.
		static float lineWidth(float val)
		{
			glLineWidth(val);
			return val;
		}

		/// Returns the primitive restart index.
		static uint primitiveRestartIndex()
		{
			int index;
			glGetIntegerv(GL_PRIMITIVE_RESTART_INDEX, &index);
			return cast(uint) index;
		}
		/// Changes the primitive restart index.
		static uint primitiveRestartIndex(uint val)
		{
			glPrimitiveRestartIndex(val);
			return val;
		}

		/// Returns the minimum rate at which sample shading takes place.
		static float minSampleShading()
		{
			float width;
			glGetFloatv(GL_MIN_SAMPLE_SHADING_VALUE, &width);
			return width;
		}
		/// Changes the minimum rate at which sample shading takes place.
		static float minSampleShading(float val)
		{
			glMinSampleShading(val);
			return val;
		}

		/// Returns the current point size.
		static float pointSize()
		{
			float size;
			glGetFloatv(GL_POINT_SIZE, &size);
			return size;
		}
		/// Changes the current point size.
		static float pointSize(float val)
		{
			glPointSize(val);
			return val;
		}

		/// Returns the logical pixel operation for rendering.
		static LogicOp logicOp()
		{
			int op;
			glGetIntegerv(GL_LOGIC_OP_MODE, &op);
			return cast(LogicOp) op;
		}
		/// Changes the logical pixel operation for rendering.
		static LogicOp logicOp(LogicOp val)
		{
			glLogicOp(val);
			return val;
		}
	}

	nothrow
	{
		///
		static void blendFunc(BlendingFactor sfactor, BlendingFactor dfactor)
		{
			glBlendFunc(sfactor, dfactor);
		}
		///
		static void blendFunc(uint buf, BlendingFactor sfactor, BlendingFactor dfactor)
		{
			glBlendFunci(buf, sfactor, dfactor);
		}
		///
		static void blendFunc(BlendingFactor srcRGB, BlendingFactor dstRGB,
				BlendingFactor srcAlpha, BlendingFactor dstAlpha)
		{
			glBlendFuncSeparate(srcRGB, dstRGB, srcAlpha, dstAlpha);
		}
		///
		static void blendFunc(uint buf, BlendingFactor srcRGB, BlendingFactor dstRGB,
				BlendingFactor srcAlpha, BlendingFactor dstAlpha)
		{
			glBlendFuncSeparatei(buf, srcRGB, dstRGB, srcAlpha, dstAlpha);
		}

		///
		static void depthRange(float nearVal, float farVal)
		{
			glDepthRangef(nearVal, farVal);
		}
		///
		static void depthRange(double nearVal, double farVal)
		{
			glDepthRange(nearVal, farVal);
		}

		///
		static void sampleCoverage(float value, bool invert)
		{
			glSampleCoverage(value, invert);
		}

		///
		static void polygonOffset(float factor, float units)
		{
			glPolygonOffset(factor, units);
		}

		///
		static void scissor(int x, int y, uint width, uint height)
		{
			glScissor(x, y, width, height);
		}
		///
		static void scissorIndexed(uint index, int left, int bottom, uint width, uint height)
		{
			glScissorIndexed(index, left, bottom, width, height);
		}
		///
		static void scissorIndexed(uint index, int[4] v)
		{
			glScissorIndexedv(index, v.ptr);
		}
		///
		static void scissorArray(uint index, int[4][] v)
		{
			glScissorArrayv(index, cast(GLsizei) v.length, cast(int*) v.ptr);
		}

		///
		static void polygonMode(MaterialFace face, PolygonMode mode)
		{
			glPolygonMode(face, mode);
		}

		///
		static void stencilFunc(StencilFunction func, int ref_, uint mask)
		{
			glStencilFunc(func, ref_, mask);
		}

		///
		static void stencilOp(StencilOp sfail, StencilOp dpfail, StencilOp dppass)
		{
			glStencilOp(sfail, dpfail, dppass);
		}

		///
		static void clear(ClearBufferMask mask)
		{
			glClear(mask);
		}

		///
		static void debugMessageInsert(DebugSource source, DebugType type, uint id,
				DebugSeverity severity, string msg)
		{
			glDebugMessageInsert(source, type, id, severity,
					cast(GLsizei) msg.length, cast(char*) msg.ptr);
		}
	}
}

alias BlendingFactor = BlendingFactorDest;

///
enum DebugSeverity
{
	/// for any GL error, dangerous undefined behaviour, or any shader compiler and linker errors
	high = GL_DEBUG_SEVERITY_HIGH,
	/// for severe performance warnings, GLSL or other shader compiler and linker warnings, and use of currently deprecated behaviour
	medium = GL_DEBUG_SEVERITY_MEDIUM,
	/// for performance warnings from redundant state changes and trivial undefined behaviour
	low = GL_DEBUG_SEVERITY_LOW,
	/// for any message which is not an error or performance concern
	notification = GL_DEBUG_SEVERITY_NOTIFICATION
}

///
enum DebugType
{
	/// for events that generated an error
	error = GL_DEBUG_TYPE_ERROR,
	/// for behaviour that has been marked for deprecation
	deprecatedBehavior = GL_DEBUG_TYPE_DEPRECATED_BEHAVIOR,
	/// for behaviour that is undefined according to the specification
	undefinedBehavior = GL_DEBUG_TYPE_UNDEFINED_BEHAVIOR,
	/// for implementation-dependent performance warnings
	performance = GL_DEBUG_TYPE_PERFORMANCE,
	/// for the use of extensions or shaders in a way that is highly vendor-specific
	portability = GL_DEBUG_TYPE_PORTABILITY,
	/// for annotation of the command stream
	marker = GL_DEBUG_TYPE_MARKER,
	/// for entering a debug group with glPushDebugGroup
	pushGroup = GL_DEBUG_TYPE_PUSH_GROUP,
	/// for leaving a debug group with glPopDebugGroup
	popGroup = GL_DEBUG_TYPE_POP_GROUP,
	/// for events that don't fit any of the ones listed above
	other = GL_DEBUG_TYPE_OTHER
}

///
enum DebugSource
{
	/// for messages generated by the GL
	api = GL_DEBUG_SOURCE_API,
	/// for messages generated by the GLSL shader compiler of compilers for other extension-provided languages
	compiler = GL_DEBUG_SOURCE_SHADER_COMPILER,
	/// for messages generated by the window system, such as WGL or GLX
	windowSystem = GL_DEBUG_SOURCE_WINDOW_SYSTEM,
	/// for messages generated by external debuggers or third-party middle-ware libraries
	thirdParty = GL_DEBUG_SOURCE_THIRD_PARTY,
	/// for messages generated by the application, such as through glDebugMessageInsert
	application = GL_DEBUG_SOURCE_APPLICATION,
	/// for messages that do not fit to any of the other sources
	other = GL_DEBUG_SOURCE_OTHER
}

alias DebugMessageCallback = void delegate(DebugSource source, DebugType type,
		GLuint id, DebugSeverity severity, string message);

private extern (C) void debugMessageCallbackWrapper(GLenum source, GLenum type,
		GLuint id, GLenum severity, GLsizei length, const(GLchar)* message, void* userParam)
{
	DebugMessageCallback cb = unwrapDebugCallback(userParam);
	string msg = message[0 .. length].idup;
	cb(cast(DebugSource) source, cast(DebugType) type, id, cast(DebugSeverity) severity, msg);
}

private struct CallbackWrapper
{
	void* ctx;
	void* fn;
}

private __gshared CallbackWrapper debugCallback;

private void* wrapDebugCallback(DebugMessageCallback cb) @nogc @system nothrow
{
	debugCallback = CallbackWrapper(cb.ptr, cast(void*) cb.funcptr);
	return cast(void*)&debugCallback;
}

private DebugMessageCallback unwrapDebugCallback(void* data) @nogc @system nothrow
{
	CallbackWrapper wrap = *(cast(CallbackWrapper*) data);
	DebugMessageCallback ret;
	ret.ptr = wrap.ctx;
	ret.funcptr = cast(typeof(ret.funcptr)) wrap.fn;
	return ret;
}
