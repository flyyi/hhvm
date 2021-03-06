<?hh
/**
 * Copyright (c) 2014, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the "hack" directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 */

interface SomeInterface {}
class Foo implements SomeInterface {}

function f(SomeInterface $bar): Foo {
  if (!($bar instanceof Foo)) {
    // At this point, $bar is of SomeInterface type.
    // All typing from Foo is lost.
    return new Foo();
  }
  return $bar;
}
