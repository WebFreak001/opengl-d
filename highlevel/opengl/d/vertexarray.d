module opengl.d.vertexarray;

import opengl.gl4;

///
enum VertexAttribType
{
	byte_ = GL_BYTE,
	unsignedByte = GL_UNSIGNED_BYTE,
	short_ = GL_SHORT,
	unsigned_short = GL_UNSIGNED_SHORT,
	fixed = GL_FIXED,
	float_ = GL_FLOAT
}

///
struct VertexArray
{
	/// Empty constructor that needs to be called explicitly
	static VertexArray opCall()
	{
		VertexArray ret;
		glGenVertexArrays(1, &ret.id);
		return ret;
	}

	~this()
	{
		if (id)
		{
			glDeleteVertexArrays(1, &id);
		}
	}

	///
	void bind()
	{
		if (boundVAO == id)
			return;
		glBindVertexArray(id);
		boundVAO = id;
	}

	///
	void enable(uint index)
	{
		bind();
		glEnableVertexAttribArray(index);
	}

	///
	void disable(uint index)
	{
		bind();
		glDisableVertexAttribArray(index);
	}

	///
	void draw(PrimitiveType mode, int first, uint count)
	{
		bind();
		glDrawArrays(mode, first, count);
	}

	///
	void drawIndexed(PrimitiveType mode, ubyte[] indices)
	{
		bind();
		glDrawElements(mode, cast(GLsizei) indices.length, GL_UNSIGNED_BYTE, indices.ptr);
	}

	///
	void drawIndexed(PrimitiveType mode, uint count, ubyte[] indices)
	{
		bind();
		glDrawElements(mode, count, GL_UNSIGNED_BYTE, indices.ptr);
	}

	///
	void drawIndexed(PrimitiveType mode, ushort[] indices)
	{
		bind();
		glDrawElements(mode, cast(GLsizei) indices.length, GL_UNSIGNED_SHORT, indices.ptr);
	}

	///
	void drawIndexed(PrimitiveType mode, uint count, ushort[] indices)
	{
		bind();
		glDrawElements(mode, count, GL_UNSIGNED_SHORT, indices.ptr);
	}

	///
	void drawIndexed(PrimitiveType mode, uint[] indices)
	{
		bind();
		glDrawElements(mode, cast(GLsizei) indices.length, GL_UNSIGNED_INT, indices.ptr);
	}

	///
	void drawIndexed(PrimitiveType mode, uint count, uint[] indices)
	{
		bind();
		glDrawElements(mode, count, GL_UNSIGNED_INT, indices.ptr);
	}

	///
	void pointer(uint index, int size = 4, VertexAttribType type = VertexAttribType.float_,
			bool normalized = false, uint stride = 0, void* pointer = null)
	{
		glVertexAttribPointer(index, size, type, normalized, stride, pointer);
	}

	///
	uint id;
}

private __gshared uint boundVAO;
