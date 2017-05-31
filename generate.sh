#!/bin/sh
pushd ogl_gen
dub build
./ogl_gen -b -4 -m opengl.gl4 -f ../dynamic/opengl/gl4.d
./ogl_gen -b -3 -m opengl.gl3 -f ../dynamic/opengl/gl3.d
./ogl_gen -b -2 -m opengl.gl2 -f ../dynamic/opengl/gl2.d
./ogl_gen -b -s -4 -m opengl.gl4 -f ../static/opengl/gl4.d
./ogl_gen -b -s -3 -m opengl.gl3 -f ../static/opengl/gl3.d
./ogl_gen -b -s -2 -m opengl.gl2 -f ../static/opengl/gl2.d
popd