# Advent of Code 2021 in Common Lisp

I'm using the Advent of Code 2021 to exercise my Common Lisp muscles.

https://adventofcode/2021

Learnings
---------

Learnings from 2020: https://github.com/atgreen/advent-of-code-2020/blob/main/README.md

Here are some of my personal learnings from 2021.

* Always remember that Common Lisp is three languages: Lisp, `loop`
  and `format`.  `loop` and `format` incredibly versatile -- use them.
* I have never used the `on` mechanism in `loop` before.
  [01.lisp](https://github.com/atgreen/advent-of-code-2021/blob/main/01.lisp)
  shows how it can be useful.
* `uiop:split-string` can replace `split-sequence:split-sequence`.

Anthony Green <green@redhat.com>
