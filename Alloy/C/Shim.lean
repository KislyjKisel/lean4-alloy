/-
Copyright (c) 2022 Mac Malone. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Mac Malone
-/
module

public meta import Alloy.Util.Shim
public meta import Alloy.Util.Extension

public import Lean.Elab.Command

import Alloy.C.Grammar

open Lean

public section

namespace Alloy.C
open Lean Elab Command

/-! ## Shim Extension -/

meta initialize shimExt : ModuleEnvExtension Shim ←
  registerModuleEnvExtension (pure {})

/-- Returns the C shim associated with the current module. -/
@[inline]
meta def getLocalShim (env : Environment) : Shim :=
  shimExt.getState env

/-- Returns the C shim associated with the named module (or an empty one if none). -/
meta def getModuleShim (env : Environment) (mod : Name) : Shim :=
  shimExt.find? env mod |>.getD {}

/--
`#print_c_shim [<mod>]` outputs the C shim of the specified module or the
current C shim of the current module if none is specified. Useful for debugging.
-/
elab outTk:"#print_c_shim" mod?:(ppSpace ident)? : command => do
  match mod? with
  | none => logInfoAt outTk <| toString <| C.getLocalShim (← getEnv)
  | some mod => logInfoAt outTk <| toString <| C.getModuleShim (← getEnv) mod.getId
