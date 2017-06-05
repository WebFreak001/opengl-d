module opengl.d.buffer;

import opengl.gl4;

///
enum BufferTarget
{
	arrayBuffer = GL_ARRAY_BUFFER,
	atomicCounterBuffer = GL_ATOMIC_COUNTER_BUFFER,
	copyReadBuffer = GL_COPY_READ_BUFFER,
	copyWriteBuffer = GL_COPY_WRITE_BUFFER,
	drawIndirectBuffer = GL_DRAW_INDIRECT_BUFFER,
	dispatchIndirectBuffer = GL_DISPATCH_INDIRECT_BUFFER,
	elementArrayBuffer = GL_ELEMENT_ARRAY_BUFFER,
	pixelPackBuffer = GL_PIXEL_PACK_BUFFER,
	pixelUnpackBuffer = GL_PIXEL_UNPACK_BUFFER,
	queryBuffer = GL_QUERY_BUFFER,
	shaderStorageBuffer = GL_SHADER_STORAGE_BUFFER,
	textureBuffer = GL_TEXTURE_BUFFER,
	transformFeedbackBuffer = GL_TRANSFORM_FEEDBACK_BUFFER,
	uniformBuffer = GL_UNIFORM_BUFFER
}

///
enum BufferUsage
{
	streamDraw = GL_STREAM_DRAW,
	streamRead = GL_STREAM_READ,
	streamCopy = GL_STREAM_COPY,
	staticDraw = GL_STATIC_DRAW,
	staticRead = GL_STATIC_READ,
	staticCopy = GL_STATIC_COPY,
	dynamicDraw = GL_DYNAMIC_DRAW,
	dynamicRead = GL_DYNAMIC_READ,
	dynamicCopy = GL_DYNAMIC_COPY
}

///
struct Buffer
{
	///
	this(BufferTarget target)
	{
		glGenBuffers(1, &id);
		this.target = target;
	}

	~this()
	{
		if (id)
		{
			glDeleteBuffers(1, &id);
		}
	}

	///
	void bind()
	{
		if (id == boundBuffer && target == boundBufferTarget)
			return;
		glBindBuffer(target, id);
		boundBuffer = id;
		boundBufferTarget = target;
	}

	///
	void setData(T)(T[] data, BufferUsage usage)
	{
		bind();
		glBufferData(target, cast(GLsizei)(data.length * T.sizeof), data.ptr, usage);
	}

	///
	void setSubData(T)(int offset, T[] data)
	{
		bind();
		glBufferData(target, offset, cast(GLsizei)(data.length * T.sizeof), data.ptr);
	}

	///
	void setStorage(T)(T[] data, MapBufferUsageMask flags)
	{
		bind();
		glBufferStorage(target, cast(GLsizei)(data.length * T.sizeof), data.ptr, flags);
	}

	///
	void invalidate()
	{
		glInvalidateBufferData(id);
	}

	///
	void invalidateSubData(int offset, uint length)
	{
		glInvalidateBufferSubData(id, offset, length);
	}

	///
	void map(MapBufferUsageMask access)
	{
		bind();
		glMapBuffer(target, access);
	}

	///
	void mapRange(int offset, uint length, MapBufferUsageMask access)
	{
		bind();
		glMapBufferRange(target, offset, length, access);
	}

	///
	uint id;
	///
	BufferTarget target;
}

private __gshared BufferTarget boundBufferTarget;
private __gshared uint boundBuffer;
