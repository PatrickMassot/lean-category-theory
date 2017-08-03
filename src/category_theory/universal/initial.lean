-- Copyright (c) 2017 Scott Morrison. All rights reserved.
-- Released under Apache 2.0 license as described in the file LICENSE.
-- Authors: Stephen Morgan, Scott Morrison

import ..functor_categories

open categories

namespace categories.initial

structure InitialObject ( C : Category ) :=
  (initial_object                              : C.Obj)
  (morphism_from_initial_object_to             : ∀ Y : C.Obj, C.Hom initial_object Y)
  (uniqueness_of_morphisms_from_initial_object : ∀ Y : C.Obj, ∀ f g : C.Hom initial_object Y, f = g)

attribute [applicable] InitialObject.morphism_from_initial_object_to
attribute [applicable,ematch] InitialObject.uniqueness_of_morphisms_from_initial_object

instance InitialObject_coercion_to_object { C : Category } : has_coe (InitialObject C) (C.Obj) :=
  { coe := InitialObject.initial_object }

structure is_initial { C : Category } ( X : C.Obj ) :=
  (morphism_from_initial_object_to           : ∀ Y : C.Obj, C.Hom X Y)
  (uniqueness_of_morphisms_from_initial_object : ∀ Y : C.Obj, ∀ f : C.Hom X Y, f = morphism_from_initial_object_to Y)

attribute [applicable,ematch] is_initial.uniqueness_of_morphisms_from_initial_object

structure TerminalObject ( C : Category ) :=
  (terminal_object                            : C.Obj)
  (morphism_to_terminal_object_from           : ∀ Y : C.Obj, C.Hom Y terminal_object)
  (uniqueness_of_morphisms_to_terminal_object : ∀ Y : C.Obj, ∀ f g : C.Hom Y terminal_object, f = g)

attribute [applicable] TerminalObject.morphism_to_terminal_object_from
attribute [applicable,ematch] TerminalObject.uniqueness_of_morphisms_to_terminal_object

instance TerminalObject_coercion_to_object { C : Category } : has_coe (TerminalObject C) (C.Obj) :=
  { coe := TerminalObject.terminal_object }

structure is_terminal { C : Category } ( X : C.Obj ) :=
  (morphism_to_terminal_object_from : ∀ Y : C.Obj, C.Hom Y X)
  (uniqueness_of_morphisms_to_terminal_object :  ∀ Y : C.Obj, ∀ f : C.Hom Y X, f = morphism_to_terminal_object_from Y)

attribute [applicable,ematch] is_terminal.uniqueness_of_morphisms_to_terminal_object

end categories.initial