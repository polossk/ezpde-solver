# ezpde-solver
![Platfrom](https://img.shields.io/badge/matlab-2015b+-bb92ac.svg)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Status](https://img.shields.io/badge/status-工事現場-red.svg)

## Usage
- copy all codes and subfolder to your workspace directly.
- add `include(package_path)` in your code, where the default value of `package_path` is `'.\ezpde-solver\'`.

### Workspace Example

```plain
+ Workspace\
|
+--- your_code_1.m
+--- your_code_2.m
+---+ ezpde-solver\
|   |
|   +---+ module_core\
|   |   |
|   |   +---+ fem_1d_core\
|   |   +---+ fem_2d_core\
|   |   ...
|   +---+ module_errors\
|   +---+ module_solver\
|   +---+ utils\
| ...
```

## Note
- Homework of Mathematical Foundation of Finite Element Methods
- Naive FEM code, easy to use but no guarantee of its effectiveness
- I would to give my special thanks to Prof. He for his excellent teaching

## Copyright
Use this code whatever you want, under the circumstances of acknowleged the
mit license this page below. Star this repository if you like, and it will
be very generous of you!

## License
The MIT License (MIT)
Copyright (c) 2017 Shangkun Shen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
