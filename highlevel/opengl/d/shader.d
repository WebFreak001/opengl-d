module opengl.d.shader;

import opengl.gl4;

///
enum ShaderType
{
	/// Vertex shader
	vertex = GL_VERTEX_SHADER,
	/// Tesselation control shader 
	tessControl = GL_TESS_CONTROL_SHADER,
	/// Tesselation evauluation shader
	tessEvaluation = GL_TESS_EVALUATION_SHADER,
	/// Geometry shader
	geometry = GL_GEOMETRY_SHADER,
	/// Fragment shader
	fragment = GL_FRAGMENT_SHADER,
	/// Compute shader
	compute = GL_COMPUTE_SHADER
}

///
struct Shader
{
	///
	this(ShaderType type)
	{
		id = glCreateShader(type);
	}

	~this()
	{
		if (id)
		{
			glDeleteShader(id);
		}
	}

	///
	nothrow @nogc void shaderSource(string str)
	{
		int len = cast(int) str.length;
		char* ptr = cast(char*) str.ptr;
		glShaderSource(id, 1, &ptr, &len);
	}

	///
	nothrow void shaderSource(string[] strs)
	{
		int[] lens = new int[strs.length];
		char*[] ptrs = new char*[strs.length];
		foreach (i, ref str; strs)
		{
			lens[i] = cast(int) str.length;
			ptrs[i] = cast(char*) str.ptr;
		}
		glShaderSource(id, cast(GLsizei) strs.length, ptrs.ptr, lens.ptr);
	}

	///
	void compile()
	{
		glCompileShader(id);
		int compiled;
		glGetShaderiv(id, GL_COMPILE_STATUS, &compiled);
		if (!compiled)
		{
			char[4 * 1024] buffer;
			GLsizei len;
			glGetShaderInfoLog(id, buffer.length, &len, buffer.ptr);
			throw new Exception(source ~ ':' ~ buffer[0 .. len].idup);
		}
	}

	///
	uint id;
	/// Human readable name of the source
	string source;
}
