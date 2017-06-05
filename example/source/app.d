import derelict.sdl2.sdl;
import opengl.d;
import opengl.gl4;
import opengl.loader;

import std.stdio;
import std.string;

/// Exception for SDL related issues
class SDLException : Exception
{
	/// Creates an exception from SDL_GetError()
	this(string file = __FILE__, size_t line = __LINE__) nothrow @nogc
	{
		super(cast(string) SDL_GetError().fromStringz, file, line);
	}
}

void main()
{
	DerelictSDL2.load();

	if (SDL_Init(SDL_INIT_VIDEO) < 0)
		throw new SDLException();

	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 2);

	auto window = SDL_CreateWindow("OpenGL 3.2 App", SDL_WINDOWPOS_UNDEFINED,
			SDL_WINDOWPOS_UNDEFINED, 400, 300, SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN);
	if (!window)
		throw new SDLException();

	const context = SDL_GL_CreateContext(window);
	if (!context)
		throw new SDLException();

	loadGL!(opengl.gl4);

	GL.enableDebugOutput = true;
	GL.debugMessageCallback = (DebugSource source, DebugType type, uint id,
			DebugSeverity severity, string message) {
		writefln("[%s] [%s] #%s %s: %s", source, type, id, severity, message);
	};

	if (SDL_GL_SetSwapInterval(1) < 0)
		writeln("Failed to set VSync");

	loadScene();

	bool quit = false;
	SDL_Event event;
	while (!quit)
	{
		while (SDL_PollEvent(&event))
		{
			switch (event.type)
			{
			case SDL_QUIT:
				quit = true;
				break;
			default:
				break;
			}
		}

		renderScene();

		SDL_GL_SwapWindow(window);
	}
}

//dfmt off
const float[] vertexBufferPositions = [
	-0.5f, -0.5f, 0,
	0.5f, -0.5f, 0,
	0, 0.5f, 0
];
const float[] vertexBufferColors = [
	1, 0, 0,
	0, 1, 0,
	0, 0, 1
];
//dfmt on
Buffer vertexBuffer;
Buffer colorBuffer;
Program program;
VertexArray vertexArray;

void loadScene()
{
	// create OpenGL buffers for vertex position and color data
	vertexArray = VertexArray();
	vertexArray.bind();

	// load position data
	vertexBuffer = Buffer(BufferTarget.arrayBuffer);
	vertexBuffer.setData(vertexBufferPositions, BufferUsage.staticDraw);

	// load color data
	colorBuffer = Buffer(BufferTarget.arrayBuffer);
	colorBuffer.setData(vertexBufferColors, BufferUsage.staticDraw);

	// compile shaders
	Shader vertexShader = Shader(ShaderType.vertex);
	vertexShader.shaderSource = import("shader.vert");
	vertexShader.source = "shader.vert";
	vertexShader.compile();

	Shader fragmentShader = Shader(ShaderType.fragment);
	fragmentShader.shaderSource = import("shader.frag");
	fragmentShader.source = "shader.frag";
	fragmentShader.compile();

	// link shaders
	program = Program();
	program.attach(vertexShader);
	program.attach(fragmentShader);
	program.link();
}

void renderScene()
{
	GL.clear(ClearBufferMask.COLOR_BUFFER_BIT);

	program.use();

	vertexArray.enable(0);
	vertexBuffer.bind();
	vertexArray.pointer(0, 3);
	vertexArray.enable(1);
	colorBuffer.bind();
	vertexArray.pointer(1, 3);
	vertexArray.draw(PrimitiveType.TRIANGLES, 0, 3); // Starting from vertex 0; 3 vertices total -> 1 triangle
	vertexArray.disable(0);
	vertexArray.disable(1);
}
