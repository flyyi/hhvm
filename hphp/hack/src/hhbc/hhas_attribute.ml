(**
 * Copyright (c) 2017, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the "hack" directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
*)

open Hh_core

type t = {
  attribute_name          : Litstr.id;
  attribute_arguments     : Typed_value.t list
}

let make attribute_name attribute_arguments =
  { attribute_name; attribute_arguments }

let name a = a.attribute_name
let arguments a = a.attribute_arguments

let is_ s attr = (name attr) = s
let has_ f attrs = List.exists attrs f

let is_memoized = is_ "__Memoize"
let is_native   = is_ "__Native"
let is_foldable = is_ "__IsFoldable"
let is_dynamically_callable = is_ "__DynamicallyCallable"

let has_memoized = has_ is_memoized
let has_native   = has_ is_native
let has_foldable = has_ is_foldable
let has_dynamically_callable = has_ is_dynamically_callable

let is_native_arg s attributes =
  let f attr =
    is_native attr &&
    List.exists (arguments attr)
      ~f:(function Typed_value.String s0 -> s = s0 | _ -> false)
  in
  List.exists attributes f
let is_native_opcode_impl = is_native_arg "OpCodeImpl"
let is_reads_caller_frame = is_native_arg "ReadsCallerFrame"
let is_writes_caller_frame = is_native_arg "WritesCallerFrame"
let is_accesses_caller_frame attr = is_reads_caller_frame attr || is_writes_caller_frame attr
let is_no_injection = is_native_arg "NoInjection"

let deprecation_info attributes =
  let f attr =
    if (name attr) = "__Deprecated" then Some (arguments attr) else None
  in
  List.find_map attributes f
