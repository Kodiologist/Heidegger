Heidegger is a map generator for roguelikes. It is a port of the Digger map generator in rot.js_, which itself is based on `the algorithm Mike Anderson described for his game Tyrant`_, from JavaScript to Hy_. Since Hy is little more than syntactic sugar for Python, you can use Hy to translate Heidegger into Python source code (``hy2py``) or bytecode (``hyc``) to use it from plain Python.

Also included in this package, in ``heidegger.pos``, is the ``Pos`` class, which implements arithmetic with 2D coordinate positions.

For usage information, see the source (particularly the comments under the arguments for ``heidegger.digger.generate-map``) and the file ``example.hy``. Note that in Python, hyphens in identifiers need to be written as underscores, so ``generate-map`` is ``generate_map`` in Python.

Dependencies: Hy, Kodhy_.

Example maps
============================================================

A sparse example
----------------------------------------

.. image:: http://i.imgur.com/u9Y0K4S.png
  :alt: Example dungeon map 1
  :align: center

A busy example
----------------------------------------

.. image:: http://i.imgur.com/AezWQIJ.png
  :alt: Example dungeon map 2
  :align: center

Licenses
============================================================

License for rot.js
----------------------------------------

Copyright (c) 2012-now(), Ondrej Zara

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

* Neither the name of Ondrej Zara nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
			
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

License for Heidegger
----------------------------------------

This program is copyright 2015, 2016 Kodi Arfer.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the `GNU General Public License`_ for more details.

.. _`GNU General Public License`: http://www.gnu.org/licenses/
.. _`the algorithm Mike Anderson described for his game Tyrant`: http://www.roguebasin.com/index.php?title=Dungeon-Building_Algorithm
.. _rot.js: http://ondras.github.io/rot.js
.. _Hy: http://hylang.org
.. _Kodhy: https://github.com/Kodiologist/Kodhy
