{ config, pkgs, ... }:

{
  environment.etc."user/http/upload.jeaye.com/jank-license".text =
  ''Copyright © 2017 Jesse 'Jeaye' Wilkerson. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted, free of charge, provided that the following
conditions are met:

Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

Redistributions in any form must be accompanied by information on how to obtain
complete source code for the distributed software and any accompanying software
that uses the distributed software. The source code must either be included in
the distribution or be available free of charge. For an executable file,
complete source code means the source code for all modules it contains. It does
not include source code for modules or files that typically accompany the major
components of the operating system on which the executable file runs.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.'';
}
