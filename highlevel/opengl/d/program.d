module opengl.d.program;

import opengl.gl4;

import opengl.d.shader;

///
struct Program
{
	~this()
	{
		if (id)
		{
			foreach (shader; attached)
				glDetachShader(id, shader.id);
			glDeleteProgram(id);
		}
	}

	/// Empty constructor that needs to be called explicitly
	static Program opCall()
	{
		Program ret;
		ret.id = glCreateProgram();
		return ret;
	}

	///
	void attach(ref in Shader shader)
	{
		glAttachShader(id, shader.id);
		attached ~= shader;
	}

	///
	void link()
	{
		glLinkProgram(id);
		int linked;
		glGetProgramiv(id, GL_LINK_STATUS, &linked);
		if (!linked)
		{
			char[4 * 1024] buffer;
			GLsizei len;
			glGetProgramInfoLog(id, buffer.length, &len, buffer.ptr);
			string source = "[";
			foreach (shader; attached)
				source ~= shader.source ~ ", ";
			if (attached.length)
				source.length -= 2;
			throw new Exception(source ~ "]: " ~ buffer[0 .. len].idup);
		}
	}

	///
	void use()
	{
		glUseProgram(id);
	}

	///
	uint id;
	Shader[] attached;
}
