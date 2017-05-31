# opengl

Dynamic & Static OpenGL bindings with documentation generated from
the spec using [ogl_gen](https://github.com/rikkimax/ogl_gen).

If you use the dynamic bindings (not ending with `-static`) you need
to additionally import `opengl.loader` and call `loadGL!(opengl.gl4);`
(replace gl4 with the version you use) after creating a GL context. It
will work on linux without GL context but not on windows.

```d

import opengl.gl4;

// if dynamic:
import opengl.loader;

void main()
{
	// ... create context

	// if dynamic:
	loadGL!(opengl.gl4);

	// OpenGL available
}

```